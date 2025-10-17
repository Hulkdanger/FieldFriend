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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';

class LocustObservationsWidget extends StatefulWidget {
  const LocustObservationsWidget({
    Key? key,
    this.width,
    this.height,
    this.maxDistance,
    this.maxResults,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double? maxDistance;
  final int? maxResults;

  @override
  _LocustObservationsWidgetState createState() =>
      _LocustObservationsWidgetState();
}

class _LocustObservationsWidgetState extends State<LocustObservationsWidget> {
  List<Map<String, dynamic>> allObservations = [];
  List<Map<String, dynamic>> filteredObservations = [];
  List<Map<String, dynamic>> displayedObservations = [];
  bool isLoading = true;
  Set<int> expandedTiles = {};

  double selectedDaysFilter = 180.0;
  Set<String> selectedRiskLevels = {'Low', 'Medium', 'High'};

  double _tempDaysFilter = 180.0;
  Set<String> _tempRiskLevels = {'Low', 'Medium', 'High'};

  final ScrollController _scrollController = ScrollController();
  static const int itemsPerPage = 50;
  int currentPage = 0;
  bool _isLoadingMore = false;

  static final _tileBorder = Border.all(color: Colors.black, width: 1);
  static final _tileRadius = BorderRadius.circular(8);
  static const _creamColor = Color(0xFFFFFDEA);

  @override
  void initState() {
    super.initState();
    fetchObservations();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    if (displayedObservations.length < filteredObservations.length &&
        !_isLoadingMore) {
      _isLoadingMore = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            currentPage++;
            int endIndex = (currentPage + 1) * itemsPerPage;
            if (endIndex > filteredObservations.length) {
              endIndex = filteredObservations.length;
            }
            displayedObservations = filteredObservations.sublist(0, endIndex);
            _isLoadingMore = false;
          });
        }
      });
    }
  }

  void _resetPagination() {
    currentPage = 0;
    int endIndex = itemsPerPage;
    if (endIndex > filteredObservations.length) {
      endIndex = filteredObservations.length;
    }
    displayedObservations = filteredObservations.sublist(0, endIndex);
  }

  Future<void> fetchObservations() async {
    try {
      final userLocation = FFAppState().userLocation;

      if (userLocation == null) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('locustObservations')
          .where('RAMSES_Locust_Type', isNotEqualTo: 'NO LOCUST')
          .get();

      List<Map<String, dynamic>> tempObservations =
          List.generate(0, (_) => {}, growable: true);

      final userLat = userLocation.latitude;
      final userLon = userLocation.longitude;
      final maxDist = widget.maxDistance;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final GeoPoint? geoPoint = data['location'];

        if (geoPoint != null) {
          final distance = _calculateDistanceFast(
            userLat,
            userLon,
            geoPoint.latitude,
            geoPoint.longitude,
          );

          if (maxDist != null && distance > maxDist) {
            continue;
          }

          tempObservations.add({
            'id': doc.id,
            'Country': data['Country'] ?? 'Unknown',
            'obsDate': data['obsDate'],
            'distance': distance,
            'Breeding': data['Breeding'] ?? 'Unknown',
            'Maturity': data['Maturity'] ?? 'Unknown',
            'Behaviour': data['Behaviour'] ?? 'Unknown',
            'latitude': geoPoint.latitude,
            'longitude': geoPoint.longitude,
          });
        }
      }

      tempObservations.sort((a, b) => a['distance'].compareTo(b['distance']));

      if (widget.maxResults != null &&
          tempObservations.length > widget.maxResults!) {
        tempObservations = tempObservations.take(widget.maxResults!).toList();
      }

      if (mounted) {
        setState(() {
          allObservations = tempObservations;
          applyFilters();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching observations: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void applyFilters() {
    List<Map<String, dynamic>> tempFiltered = allObservations;

    if (selectedDaysFilter < 120.0) {
      final cutoffTimestamp = DateTime.now()
          .subtract(Duration(days: selectedDaysFilter.round()))
          .millisecondsSinceEpoch;

      tempFiltered = tempFiltered.where((obs) {
        if (obs['obsDate'] == null) return false;
        final obsTimestamp =
            (obs['obsDate'] as Timestamp).millisecondsSinceEpoch;
        return obsTimestamp > cutoffTimestamp;
      }).toList();
    }

    if (selectedRiskLevels.length < 3) {
      tempFiltered = tempFiltered.where((obs) {
        final riskLevel = _calculateRiskLevel(obs);
        return selectedRiskLevels.contains(riskLevel);
      }).toList();
    }

    filteredObservations = tempFiltered;
    expandedTiles.clear();
    _resetPagination();
  }

  double _calculateDistanceFast(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0;

    final dLat = (lat2 - lat1) * 0.017453292519943295;
    final dLon = (lon2 - lon1) * 0.017453292519943295;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * 0.017453292519943295) *
            math.cos(lat2 * 0.017453292519943295) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  String _calculateRiskLevel(Map<String, dynamic> observation) {
    final userLocation = FFAppState().userLocation;
    if (userLocation == null) return 'Unknown';

    final obsDate = observation['obsDate'] as Timestamp?;
    final maturity = observation['Maturity'] as String?;
    final behaviour = observation['Behaviour'] as String?;
    final breeding = observation['Breeding'] as String?;
    final latitude = observation['latitude'] as double?;
    final longitude = observation['longitude'] as double?;

    if (obsDate == null || latitude == null || longitude == null) {
      return 'Unknown';
    }

    final distance = _calculateDistanceFast(
      userLocation.latitude,
      userLocation.longitude,
      latitude,
      longitude,
    );

    final daysSince =
        DateTime.now().difference(obsDate.toDate()).inDays.toDouble();

    if (daysSince > 120.0) {
      return 'Low';
    }

    const double timeHalfLife = 30.0;
    const double distanceHalfLife = 100.0;

    final distanceDecay = math.pow(2, -distance / distanceHalfLife).toDouble();
    final recencyDecay = math.pow(2, -daysSince / timeHalfLife).toDouble();

    final wm = _getMaturityWeight(maturity ?? 'N/A');
    final wb = _getBehaviourWeight(behaviour ?? 'N/A');
    final wbr = _getBreedingWeight(breeding ?? 'N/A');

    final severity = math.pow(wm * wb * wbr, 1.0 / 3.0).toDouble();
    final risk = 100.0 * distanceDecay * recencyDecay * severity;

    if (risk >= 60.0) {
      return 'High';
    } else if (risk >= 30.0) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

  double _getMaturityWeight(String maturity) {
    switch (maturity) {
      case 'Mature':
        return 1.00;
      case 'Immature':
        return 0.70;
      case 'Hopper/Nymph':
        return 0.80;
      default:
        return 0.60;
    }
  }

  double _getBehaviourWeight(String behaviour) {
    switch (behaviour) {
      case 'Scattered':
      case 'Isolated':
        return 0.40;
      case 'Groups':
        return 0.65;
      case 'Swarms':
        return 1.00;
      default:
        return 0.60;
    }
  }

  double _getBreedingWeight(String breeding) {
    switch (breeding) {
      case 'Copulating':
        return 0.85;
      case 'Laying':
        return 1.00;
      default:
        return 0.70;
    }
  }

  String _getFilterSummary() {
    List<String> activeFilters = [];

    if (selectedDaysFilter < 120.0) {
      activeFilters.add('${selectedDaysFilter.round()}d');
    }

    if (selectedRiskLevels.length < 3) {
      if (selectedRiskLevels.length == 1) {
        activeFilters.add(selectedRiskLevels.first);
      } else if (selectedRiskLevels.length == 2) {
        activeFilters.add(selectedRiskLevels.join(' & '));
      }
    }

    return activeFilters.isEmpty ? 'All' : activeFilters.join(' • ');
  }

  void _showFilterModal() {
    _tempDaysFilter = selectedDaysFilter;
    _tempRiskLevels = Set.from(selectedRiskLevels);

    // Ensure temp value is within valid range
    if (_tempDaysFilter < 10.0 || _tempDaysFilter > 120.0) {
      _tempDaysFilter = 120.0;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: _creamColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border.all(color: Colors.black, width: 2),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Observations',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Date Range',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: Colors.black,
                            inactiveTrackColor: Colors.black.withOpacity(0.2),
                            thumbColor: Colors.black,
                            overlayColor: Colors.black.withOpacity(0.2),
                            valueIndicatorColor: Colors.black,
                            valueIndicatorTextStyle: TextStyle(
                              color: Color(0xFFFFFDEA),
                              fontFamily: 'Sora',
                            ),
                          ),
                          child: Slider(
                            value: _tempDaysFilter,
                            min: 10.0,
                            max: 120.0,
                            divisions: 11,
                            label: _tempDaysFilter >= 120.0
                                ? 'All'
                                : '${_tempDaysFilter.round()} days',
                            onChanged: (value) {
                              setModalState(() {
                                // Snap to 10-day increments
                                double snapped = (value / 10).round() * 10.0;
                                _tempDaysFilter = snapped.clamp(10.0, 120.0);
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Text(
                          _tempDaysFilter >= 120.0
                              ? 'All'
                              : '${_tempDaysFilter.round()}d',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Risk Levels',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildRiskCheckbox(
                    'Low',
                    Colors.green.shade700,
                    _tempRiskLevels.contains('Low'),
                    (value) {
                      setModalState(() {
                        if (value == true) {
                          _tempRiskLevels.add('Low');
                        } else {
                          _tempRiskLevels.remove('Low');
                        }
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  _buildRiskCheckbox(
                    'Medium',
                    Colors.orange.shade700,
                    _tempRiskLevels.contains('Medium'),
                    (value) {
                      setModalState(() {
                        if (value == true) {
                          _tempRiskLevels.add('Medium');
                        } else {
                          _tempRiskLevels.remove('Medium');
                        }
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  _buildRiskCheckbox(
                    'High',
                    Colors.red.shade700,
                    _tempRiskLevels.contains('High'),
                    (value) {
                      setModalState(() {
                        if (value == true) {
                          _tempRiskLevels.add('High');
                        } else {
                          _tempRiskLevels.remove('High');
                        }
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              _tempDaysFilter = 120.0;
                              _tempRiskLevels = {'Low', 'Medium', 'High'};
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 2),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedDaysFilter = _tempDaysFilter;
                              selectedRiskLevels = Set.from(_tempRiskLevels);
                              applyFilters();
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: _creamColor,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Apply Filters',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRiskCheckbox(
      String label, Color color, bool value, Function(bool?) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: value ? color.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: value ? color : Colors.black.withOpacity(0.3),
            width: value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: value ? color : Colors.transparent,
                border: Border.all(color: color, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: value
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 15,
                fontWeight: value ? FontWeight.w600 : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown date';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  String formatDistance(double distance) {
    if (distance < 1) {
      return '${(distance * 1000).round()} m';
    } else {
      return '${distance.toStringAsFixed(1)} km';
    }
  }

  Future<void> openInMaps(
      double latitude, double longitude, String country) async {
    final url =
        Uri.parse('http://maps.apple.com/?ll=$latitude,$longitude&q=$country');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        final googleMapsUrl = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
        if (await canLaunchUrl(googleMapsUrl)) {
          await launchUrl(googleMapsUrl);
        }
      }
    } catch (e) {
      print('Error opening maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure selectedDaysFilter is within valid range
    if (selectedDaysFilter < 10.0 || selectedDaysFilter > 120.0) {
      selectedDaysFilter = 120.0;
    }

    if (isLoading) {
      return Container(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: GestureDetector(
              onTap: _showFilterModal,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _creamColor,
                  border: _tileBorder,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.filter_list, color: Colors.black, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getFilterSummary(),
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black.withOpacity(0.2),
            margin: EdgeInsets.only(bottom: 4),
          ),
          Expanded(
            child: displayedObservations.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No observations match your filters.\nTry adjusting your criteria.',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(8),
                    itemCount: displayedObservations.length,
                    itemBuilder: (context, index) {
                      final riskLevel =
                          _calculateRiskLevel(displayedObservations[index]);
                      return _ObservationTile(
                        observation: displayedObservations[index],
                        index: index,
                        isExpanded: expandedTiles.contains(index),
                        riskLevel: riskLevel,
                        onTap: () {
                          setState(() {
                            if (expandedTiles.contains(index)) {
                              expandedTiles.remove(index);
                            } else {
                              expandedTiles.add(index);
                            }
                          });
                        },
                        onOpenMaps: openInMaps,
                        formatDate: formatDate,
                        formatDistance: formatDistance,
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              'Showing ${displayedObservations.length} of ${filteredObservations.length} observations',
              style: TextStyle(
                fontFamily: 'Sora',
                color: Colors.black.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ObservationTile extends StatelessWidget {
  final Map<String, dynamic> observation;
  final int index;
  final bool isExpanded;
  final String riskLevel;
  final VoidCallback onTap;
  final Function(double, double, String) onOpenMaps;
  final String Function(Timestamp?) formatDate;
  final String Function(double) formatDistance;

  const _ObservationTile({
    required this.observation,
    required this.index,
    required this.isExpanded,
    required this.riskLevel,
    required this.onTap,
    required this.onOpenMaps,
    required this.formatDate,
    required this.formatDistance,
  });

  static const _creamColor = Color(0xFFFFFDEA);

  Color _getRiskColor() {
    switch (riskLevel) {
      case 'High':
        return Colors.red.shade700;
      case 'Medium':
        return Colors.orange.shade700;
      case 'Low':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _creamColor,
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  observation['Country'],
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getRiskColor(),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  riskLevel.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Date: ${formatDate(observation['obsDate'])}',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        formatDistance(observation['distance']),
                        style: TextStyle(
                          fontFamily: 'Sora',
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black.withOpacity(0.2),
                  ),
                  SizedBox(height: 12),
                  _InfoRow(label: 'Behaviour', value: observation['Behaviour']),
                  SizedBox(height: 8),
                  _InfoRow(
                      label: 'Breeding Status', value: observation['Breeding']),
                  SizedBox(height: 8),
                  _InfoRow(label: 'Maturity', value: observation['Maturity']),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        onOpenMaps(
                          observation['latitude'],
                          observation['longitude'],
                          observation['Country'],
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: _creamColor,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Open in Maps',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (!isExpanded) ...[
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Tap for more details',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontFamily: 'Sora',
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Sora',
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
