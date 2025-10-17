// Automatic FlutterFlow imports
import '/backend/backend.dart';
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;
import '/actions/actions.dart' as action_blocks;
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

// Global cache to persist markers across widget rebuilds
class _MapCache {
  static final _MapCache _instance = _MapCache._internal();
  factory _MapCache() => _instance;
  _MapCache._internal();

  Set<gmap.Marker>? markers;
  Map<String, DocumentReference>? markerDocRefs;
  int? lastDaysFilter;
  DateTime? lastLoadTime;
  bool isLoading = false;

  // Pre-processed marker icons for faster rendering
  final Map<String, gmap.BitmapDescriptor> _iconCache = {};

  void clear() {
    markers = null;
    markerDocRefs = null;
    lastDaysFilter = null;
    lastLoadTime = null;
  }

  gmap.BitmapDescriptor getCachedIcon(double hue) {
    if (kIsWeb) return gmap.BitmapDescriptor.defaultMarker;

    final key = hue.toStringAsFixed(1);
    if (!_iconCache.containsKey(key)) {
      _iconCache[key] = gmap.BitmapDescriptor.defaultMarkerWithHue(hue);
    }
    return _iconCache[key]!;
  }

  bool shouldReload(int daysFilter) {
    if (markers == null || markerDocRefs == null) return true;
    if (lastDaysFilter != daysFilter) return true;
    return false;
  }
}

/// Google Map with optimized lazy loading and persistent marker cache
class FirestoreMap extends StatefulWidget {
  const FirestoreMap({
    super.key,
    this.width,
    this.height,
    this.observations,
    this.centerCoordinates,
    this.defaultZoom,
    this.showLocation,
    this.showCompass,
    this.showMapToolbar,
    this.showTraffic,
    this.allowZoom,
    this.showZoomControls,
    this.onClickMarker,
  });

  final double? width;
  final double? height;
  final List<LocustObservationsRecord>? observations;
  final LatLng? centerCoordinates;
  final double? defaultZoom;
  final bool? showLocation;
  final bool? showCompass;
  final bool? showMapToolbar;
  final bool? showTraffic;
  final bool? allowZoom;
  final bool? showZoomControls;
  final Future Function()? onClickMarker;

  @override
  State<FirestoreMap> createState() => _FirestoreMapState();
}

class _FirestoreMapState extends State<FirestoreMap> {
  final _cache = _MapCache();
  gmap.GoogleMapController? _controller;
  Set<gmap.Marker> _markers = <gmap.Marker>{};
  bool _loadingMarkers = false;
  bool _mapInitialized = false;
  String? _initError;
  int _markersLoaded = 0;
  int _totalMarkers = 0;

  static const List<int> _dayOptions = [7, 30, 60, 90];
  int _daysFilter = 30;

  Map<String, DocumentReference> _markerDocRefs = {};

  @override
  void initState() {
    super.initState();
    print('[FirestoreMap] initState - checking cache');

    // OPTIMIZATION 1: Load from cache IMMEDIATELY before any async operations
    if (!_cache.shouldReload(_daysFilter) && _cache.markers != null) {
      print(
          '[FirestoreMap] ⚡ INSTANT load: ${_cache.markers!.length} markers from cache');
      _markers = Set<gmap.Marker>.from(_cache.markers!);
      _markerDocRefs =
          Map<String, DocumentReference>.from(_cache.markerDocRefs ?? {});
      _markersLoaded = _markers.length;
      _daysFilter = _cache.lastDaysFilter ?? 30;
      _mapInitialized = true; // Map ready immediately
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_mapInitialized) {
        _initializeMap();
      }
    });
  }

  Future<void> _initializeMap() async {
    try {
      if (mounted) {
        setState(() {
          _mapInitialized = true;
          _initError = null;
        });
      }

      // Load markers immediately
      await _loadMarkersLazy();
    } catch (e) {
      print('[FirestoreMap] Initialization error: $e');
      if (mounted) {
        setState(() {
          _mapInitialized = false;
          _initError =
              'Failed to initialize map. Please ensure Google Maps API key is configured.';
        });
      }
    }
  }

  Future<void> _loadMarkersLazy() async {
    if (!_mapInitialized) return;
    if (_cache.isLoading) {
      print(
          '[FirestoreMap] Already loading markers, skipping duplicate request');
      return;
    }

    _cache.isLoading = true;

    if (mounted) {
      setState(() {
        _loadingMarkers = true;
        _markers.clear();
        _markerDocRefs.clear();
        _markersLoaded = 0;
        _totalMarkers = 0;
      });
    }

    try {
      final List<Map<String, dynamic>> docsData = [];
      final List<DocumentReference> docRefsList = [];
      final DateTime now = DateTime.now();
      final DateTime cutoffDt = now.subtract(Duration(days: _daysFilter));
      final Timestamp cutoffTs = Timestamp.fromDate(cutoffDt);

      // OPTIMIZATION 2: Fetch data with index-optimized query
      if (widget.observations != null && widget.observations!.isNotEmpty) {
        // OPTIMIZATION 3: Parallel processing of observations
        final futures = <Future<Map<String, dynamic>?>>[];

        for (final r in widget.observations!) {
          futures.add(_extractObservationData(r, cutoffDt));
        }

        final results = await Future.wait(futures);

        for (int i = 0; i < results.length; i++) {
          final m = results[i];
          if (m != null) {
            docsData.add(m);
            docRefsList.add(widget.observations![i].reference);
          }
        }
      } else {
        final CollectionReference<Map<String, dynamic>> col =
            FirebaseFirestore.instance.collection('locustObservations');

        QuerySnapshot<Map<String, dynamic>> qs;
        try {
          // OPTIMIZATION 4: Use indexed query with limit for faster fetch
          qs = await col
              .where('obsDate', isGreaterThanOrEqualTo: cutoffTs)
              .where('reported', isEqualTo: false)
              .orderBy('obsDate', descending: true)
              .limit(1000) // Limit to prevent massive data loads
              .get();
        } catch (_) {
          // Fallback if compound index doesn't exist
          qs = await col
              .where('obsDate', isGreaterThanOrEqualTo: cutoffTs)
              .orderBy('obsDate', descending: true)
              .limit(1000)
              .get();
        }

        for (final d in qs.docs) {
          final m = d.data();
          if (m['reported'] == true) continue;

          final dt = _toDateTime(m['obsDate']);
          if (dt != null && !dt.isBefore(cutoffDt)) {
            docsData.add(m);
            docRefsList.add(d.reference);
          }
        }
      }

      print('[FirestoreMap] ⚡ Fetched ${docsData.length} observations');

      _totalMarkers = docsData.length;

      int skippedNoGeo = 0, skippedNoLocust = 0;
      gmap.LatLng? firstMarker;

      // OPTIMIZATION 5: Larger batch size and reduce delays
      const int batchSize = 50; // Increased from 20
      final Set<gmap.Marker> newMarkers = {};

      for (int i = 0; i < docsData.length; i++) {
        final data = docsData[i];

        final dynamic typeRaw = data['RAMSES_Locust_Type'];
        if (typeRaw != null && typeRaw is String && typeRaw == 'NO LOCUST') {
          skippedNoLocust++;
          continue;
        }

        final gmap.LatLng? pos = _extractLatLng(data['location']);
        if (pos == null) {
          skippedNoGeo++;
          continue;
        }

        firstMarker ??= pos;

        final String behaviour = _stringOrFallback(data['Behaviour'], 'N/A');
        final String maturity = _stringOrFallback(data['Maturity'], 'N/A');
        final String dateStr = _formatDateOnly(data['obsDate']);
        final bool isUCG = data['UCG'] == 'Yes';
        final String country = _stringOrFallback(data['Country'], 'Unknown');

        final String markerId = 'locust_${pos.latitude}_${pos.longitude}_$i';

        if (i < docRefsList.length) {
          _markerDocRefs[markerId] = docRefsList[i];
        }

        // OPTIMIZATION 6: Use cached icons
        final double hue = _riskHue(behaviour, maturity);
        final gmap.BitmapDescriptor icon = _cache.getCachedIcon(hue);

        String infoTitle = dateStr;
        String infoSnippet =
            'Behaviour: $behaviour\nMaturity: $maturity\nCountry: $country';

        if (isUCG) {
          infoTitle = 'Community Generated\n$dateStr';
        }

        newMarkers.add(
          gmap.Marker(
            markerId: gmap.MarkerId(markerId),
            position: pos,
            icon: icon,
            infoWindow: gmap.InfoWindow(
              title: infoTitle,
              snippet: infoSnippet,
              onTap: isUCG ? () => _showReportDialog(markerId) : null,
            ),
            onTap: () async {
              if (widget.onClickMarker != null) {
                await widget.onClickMarker!();
              }
            },
          ),
        );

        _markersLoaded++;

        // OPTIMIZATION 7: Update less frequently, only every 50 markers
        if (_markersLoaded % batchSize == 0) {
          _markers = Set<gmap.Marker>.from(newMarkers);
          if (mounted) {
            setState(() {});
          }
          // Minimal delay for UI responsiveness
          await Future<void>.delayed(const Duration(milliseconds: 16));
        }
      }

      // Final batch
      _markers = newMarkers;

      // OPTIMIZATION 8: Save to cache immediately
      _cache.markers = Set<gmap.Marker>.from(_markers);
      _cache.markerDocRefs =
          Map<String, DocumentReference>.from(_markerDocRefs);
      _cache.lastDaysFilter = _daysFilter;
      _cache.lastLoadTime = DateTime.now();

      if (mounted) {
        setState(() {});
      }

      // Center map on first marker (non-blocking)
      if (_controller != null &&
          widget.centerCoordinates == null &&
          firstMarker != null) {
        unawaited(_centerMapAsync(firstMarker));
      }

      print(
          '[FirestoreMap] ⚡ Loaded ${_markersLoaded} markers (skipped: noGeo=$skippedNoGeo, noLocust=$skippedNoLocust)');
    } catch (e, st) {
      print('[FirestoreMap] ERROR: $e');
      print(st);
      if (mounted && e.toString().contains('provideAPIKey')) {
        setState(() {
          _initError = 'Google Maps API key not configured.';
        });
      }
    } finally {
      _cache.isLoading = false;
      if (mounted) {
        setState(() => _loadingMarkers = false);
      }
    }
  }

  // OPTIMIZATION 9: Non-blocking map centering
  Future<void> _centerMapAsync(gmap.LatLng position) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      _controller?.animateCamera(
        gmap.CameraUpdate.newLatLngZoom(position, 4.5),
      );
    } catch (e) {
      print('[FirestoreMap] Map centering skipped: $e');
    }
  }

  // OPTIMIZATION 10: Extract observation data efficiently
  Future<Map<String, dynamic>?> _extractObservationData(
    LocustObservationsRecord r,
    DateTime cutoffDt,
  ) async {
    Map<String, dynamic>? m;

    try {
      final dyn = r as dynamic;
      if (dyn.snapshotData is Map<String, dynamic>) {
        m = Map<String, dynamic>.from(dyn.snapshotData);
      } else if (dyn.data is Map<String, dynamic>) {
        m = Map<String, dynamic>.from(dyn.data);
      }
    } catch (_) {}

    m ??= (await r.reference.get()).data() as Map<String, dynamic>?;

    if (m != null) {
      if (m['reported'] == true) return null;

      final dt = _toDateTime(m['obsDate']);
      if (dt != null && !dt.isBefore(cutoffDt)) {
        return m;
      }
    }
    return null;
  }

  Future<void> _showReportDialog(String markerId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report Community Observation'),
          content: Text(
            'Are you sure you want to report this community observation? '
            'This will remove it from the map.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Report', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _reportObservation(markerId);
    }
  }

  Future<void> _reportObservation(String markerId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      final docRef = _markerDocRefs[markerId];
      if (docRef != null) {
        await docRef.update({'reported': true});

        setState(() {
          _markers.removeWhere((m) => m.markerId.value == markerId);
          _markerDocRefs.remove(markerId);
        });

        // Update cache
        _cache.markers?.removeWhere((m) => m.markerId.value == markerId);
        _cache.markerDocRefs?.remove(markerId);
      }

      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Observation reported successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to report observation. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }

      print('Error reporting observation: $e');
    }
  }

  Widget _buildMapWidget(BuildContext context) {
    final gmap.LatLng center = widget.centerCoordinates != null
        ? gmap.LatLng(
            widget.centerCoordinates!.latitude,
            widget.centerCoordinates!.longitude,
          )
        : const gmap.LatLng(15.0, 20.0);

    final double zoom = (widget.defaultZoom ?? 3.5).clamp(0.0, 21.0).toDouble();

    try {
      return gmap.GoogleMap(
        initialCameraPosition: gmap.CameraPosition(target: center, zoom: zoom),
        onMapCreated: (c) {
          _controller = c;
        },
        mapType: gmap.MapType.normal,
        myLocationEnabled: widget.showLocation ?? false,
        myLocationButtonEnabled: widget.showLocation ?? false,
        compassEnabled: widget.showCompass ?? true,
        mapToolbarEnabled: widget.showMapToolbar ?? false,
        trafficEnabled: widget.showTraffic ?? false,
        zoomGesturesEnabled: widget.allowZoom ?? true,
        zoomControlsEnabled: widget.showZoomControls ?? false,
        markers: _markers,
        // OPTIMIZATION 11: Disable expensive features for faster rendering
        buildingsEnabled: false,
        indoorViewEnabled: false,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
      );
    } catch (e) {
      print('[FirestoreMap] Map creation error: $e');

      if (e.toString().contains('provideAPIKey') ||
          e.toString().contains('Google Maps SDK')) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 48, color: FlutterFlowTheme.of(context).error),
                const SizedBox(height: 16),
                Text(
                  'Google Maps Configuration Error',
                  style: FlutterFlowTheme.of(context).headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'The Google Maps API key is not configured properly.',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Unable to load map. Please try again later.',
            style: FlutterFlowTheme.of(context).bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initError != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 48, color: FlutterFlowTheme.of(context).error),
                const SizedBox(height: 16),
                Text(_initError!,
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _initializeMap, child: Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Positioned.fill(child: _buildMapWidget(context)),

          // Date filter UI
          if (_mapInitialized)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Last:',
                            style: FlutterFlowTheme.of(context).labelMedium),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _daysFilter,
                          underline: const SizedBox.shrink(),
                          items: _dayOptions
                              .map((d) => DropdownMenuItem<int>(
                                    value: d,
                                    child: Text('$d days',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val == null || val == _daysFilter) return;
                            setState(() => _daysFilter = val);
                            _loadMarkersLazy();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Loading indicator with progress
          if (_loadingMarkers)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Loading markers...',
                          style: FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Cache indicator
          if (_mapInitialized &&
              !_loadingMarkers &&
              _markers.isNotEmpty &&
              _cache.markers != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(8),
                  color: FlutterFlowTheme.of(context)
                      .secondaryBackground
                      .withOpacity(0.9),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          'Instant Load',
                          style:
                              FlutterFlowTheme.of(context).bodySmall?.copyWith(
                                    fontSize: 10,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Helper methods
  gmap.LatLng? _extractLatLng(dynamic loc) {
    if (loc is GeoPoint) {
      return gmap.LatLng(loc.latitude, loc.longitude);
    }
    if (loc is Map) {
      final lat = loc['lat'] ?? loc['latitude'];
      final lng = loc['lng'] ?? loc['longitude'];
      if (lat is num && lng is num) {
        return gmap.LatLng(lat.toDouble(), lng.toDouble());
      }
    }
    if (loc is LatLng) {
      return gmap.LatLng(loc.latitude, loc.longitude);
    }
    if (loc is String) {
      final reg = RegExp(r'(-?\d+(\.\d+)?)');
      final matches = reg.allMatches(loc).map((m) => m.group(0)!).toList();
      if (matches.length >= 2) {
        final lat = double.tryParse(matches[0]);
        final lng = double.tryParse(matches[1]);
        if (lat != null && lng != null) return gmap.LatLng(lat, lng);
      }
    }
    return null;
  }

  String _stringOrFallback(dynamic v, String fb) {
    if (v == null) return fb;
    final s = v.toString().trim();
    return s.isEmpty ? fb : s;
  }

  DateTime? _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  String _formatDateOnly(dynamic value) {
    final dt = _toDateTime(value);
    if (dt == null) return '—';
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final m = months[dt.month - 1];
    return '$m ${dt.day}, ${dt.year}';
  }

  double _riskHue(String behaviour, String maturity) {
    final b = behaviour.toLowerCase();
    final m = maturity.toLowerCase();
    final bool high =
        (b.contains('group') || b.contains('band') || b.contains('swarm')) ||
            m.contains('adult');
    final bool low = b.contains('scattered') || b.contains('solitary');
    if (high) return 0.0;
    if (low) return 120.0;
    return 30.0;
  }
}

// Helper to fire-and-forget async operations
void unawaited(Future<void> future) {
  future.catchError((e) => print('[FirestoreMap] Background task error: $e'));
}
