// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:google_maps_flutter/google_maps_flutter.dart'
    as google_maps_flutter;
import 'package:ff_commons/flutter_flow/lat_lng.dart' as ff_latlng;
import 'dart:async';
export 'dart:async' show Completer;
export 'package:google_maps_flutter/google_maps_flutter.dart' hide LatLng;
export 'package:ff_commons/flutter_flow/lat_lng.dart' show LatLng;
import 'dart:ui';

class CBCustomDataTypeMap extends StatefulWidget {
  const CBCustomDataTypeMap({
    super.key,
    this.width,
    this.height,
    this.places,
    required this.centerCoordinates,
    required this.showLocation,
    required this.showCompass,
    required this.showMapToolbar,
    required this.showTraffic,
    required this.allowZoom,
    required this.showZoomControls,
    required this.defaultZoom,
    this.onClickMarker,
    this.polygons,
    this.polylines,
  });

  final double? width;
  final double? height;
  final List<PlaceStruct>? places;
  final ff_latlng.LatLng centerCoordinates;
  final bool showLocation;
  final bool showCompass;
  final bool showMapToolbar;
  final bool showTraffic;
  final bool allowZoom;
  final bool showZoomControls;
  final double defaultZoom;
  final Future Function(PlaceStruct? placeRow)? onClickMarker;
  final List<PolygonStruct>? polygons;
  final List<PolylineStruct>? polylines;

  @override
  State<CBCustomDataTypeMap> createState() => _CBCustomDataTypeMapState();
}

class _CBCustomDataTypeMapState extends State<CBCustomDataTypeMap> {
  Completer<google_maps_flutter.GoogleMapController> _controller = Completer();
  Map<String, google_maps_flutter.BitmapDescriptor> _customIcons = {};
  Set<google_maps_flutter.Marker> _markers = {};
  Set<google_maps_flutter.Polygon> _polygons = {};
  Set<google_maps_flutter.Polyline> _polylines = {};

  late google_maps_flutter.LatLng _center;

  final HTTPS_PATH = "https";
  final IMAGES_PATH = "assets/images/";
  final UNDERSCORE = '_';
  final MARKER = "Marker";

  @override
  void initState() {
    super.initState();

    _center = google_maps_flutter.LatLng(
        widget.centerCoordinates.latitude, widget.centerCoordinates.longitude);

    _loadMarkerIcons();
  }

  @override
  void didUpdateWidget(CBCustomDataTypeMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.places != widget.places) {
      _loadMarkerIcons();
    }

    if (oldWidget.polygons != widget.polygons) {
      _loadPolygons();
    }

    if (oldWidget.polylines != widget.polylines) {
      _loadPolylines();
    }
  }

  void _loadPolygons() {
    Set<google_maps_flutter.Polygon> polygons = {};
    if (widget.polygons != null && widget.polygons!.isNotEmpty) {
      widget.polygons?.forEach((polygon) {
        List<google_maps_flutter.LatLng> points = [];
        List<PolygonPlaceStruct> sorted =
            List.from(polygon?.polygonPlaces ?? []);
        sorted.sort((a, b) => a.order.compareTo(b.order));
        sorted!.forEach((polygon) {
          points.add(google_maps_flutter.LatLng(
              polygon.coordinates?.latitude ?? 0.0,
              polygon.coordinates?.longitude ?? 0.0));
        });
        polygons.add(google_maps_flutter.Polygon(
          polygonId: google_maps_flutter.PolygonId('generic_polygon_id'),
          points: points,
          fillColor: getColorFromHex(polygon.fillColor)
              .withOpacity(polygon.fillOpacity),
          strokeColor: getColorFromHex(polygon.strokeColor),
          strokeWidth: polygon.strokeWeight,
        ));
      });
    }
    setState(() {
      _polygons = polygons;
    });
  }

  void _loadPolylines() {
    Set<google_maps_flutter.Polyline> polylines = {};
    if (widget.polygons != null && widget.polygons!.isNotEmpty) {
      widget.polylines?.forEach((polyline) {
        List<google_maps_flutter.LatLng> points = [];
        List<PolylinePlaceStruct> sorted =
            List.from(polyline?.polylinePlaces ?? []);
        sorted.sort((a, b) => a.order.compareTo(b.order));
        sorted!.forEach((polyline) {
          points.add(google_maps_flutter.LatLng(
              polyline.coordinates?.latitude ?? 0.0,
              polyline.coordinates?.longitude ?? 0.0));
        });
        polylines.add(google_maps_flutter.Polyline(
            polylineId: google_maps_flutter.PolylineId('generic_polyline_id'),
            points: points,
            color: getColorFromHex(polyline.strokeColor),
            width: polyline.strokeWeight,
            geodesic: polyline.geodesic));
      });
    }
    setState(() {
      _polylines = polylines;
    });
  }

  Future<void> _loadMarkerIcons() async {
    Set<String?> uniqueIconPaths =
        widget.places?.map((data) => data.imageUrl).toSet() ??
            {}; // Extract unique icon paths

    for (String? path in uniqueIconPaths) {
      if (path != null && path.isNotEmpty) {
        if (path.contains(HTTPS_PATH)) {
          Uint8List? imageData = await loadNetworkImage(path);
          if (imageData != null) {
            google_maps_flutter.BitmapDescriptor descriptor =
                await google_maps_flutter.BitmapDescriptor.fromBytes(imageData);
            _customIcons[path] = descriptor;
          }
        } else {
          google_maps_flutter.BitmapDescriptor descriptor =
              await google_maps_flutter.BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.5),
            "$IMAGES_PATH$path",
          );
          _customIcons[path] = descriptor;
        }
      }
    }

    _updateMarkers(); // Update markers once icons are loaded
  }

  Future<void> _updateMarkers() async {
    _markers = await _createMarkers();
    setState(() {});
  }

  Color getColorFromHex(String hexColor) {
    return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void _onMapCreated(google_maps_flutter.GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<Set<google_maps_flutter.Marker>> _createMarkers() async {
    var tmp = <google_maps_flutter.Marker>{};

    for (int i = 0; i < (widget.places ?? []).length; i++) {
      var place = widget.places?[i];

      final ff_latlng.LatLng coordinates = ff_latlng.LatLng(
          place?.latLng?.latitude ?? 0.0, place?.latLng?.longitude ?? 0.0);

      final google_maps_flutter.LatLng googleMapsLatLng =
          google_maps_flutter.LatLng(
        coordinates.latitude,
        coordinates.longitude,
      );

      google_maps_flutter.BitmapDescriptor icon =
          _customIcons[place?.imageUrl] ??
              google_maps_flutter.BitmapDescriptor.defaultMarker;

      final google_maps_flutter.Marker marker = google_maps_flutter.Marker(
        markerId: google_maps_flutter.MarkerId(
            '${place?.title ?? MARKER}$UNDERSCORE$i'),
        // Use index to ensure uniqueness
        position: googleMapsLatLng,
        icon: icon,
        infoWindow: google_maps_flutter.InfoWindow(
            title: place?.title, snippet: place?.description),
        onTap: () async {
          final callback = widget.onClickMarker;
          if (callback != null) {
            await callback(place);
          }
        },
      );

      tmp.add(marker);
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return google_maps_flutter.GoogleMap(
      onMapCreated: _onMapCreated,
      zoomGesturesEnabled: widget.allowZoom,
      zoomControlsEnabled: widget.showZoomControls,
      myLocationEnabled: widget.showLocation,
      compassEnabled: widget.showCompass,
      mapToolbarEnabled: widget.showMapToolbar,
      trafficEnabled: widget.showTraffic,
      initialCameraPosition: google_maps_flutter.CameraPosition(
        target: _center,
        zoom: widget.defaultZoom,
      ),
      polygons: _polygons,
      polylines: _polylines,
      markers: _markers,
    );
  }
}

Future<Uint8List?> loadNetworkImage(String path) async {
  final completer = Completer<ImageInfo>();
  var image = NetworkImage(path);
  image.resolve(const ImageConfiguration()).addListener(ImageStreamListener(
      (ImageInfo info, bool _) => completer.complete(info)));
  final imageInfo = await completer.future;
  final byteData =
      await imageInfo.image.toByteData(format: ImageByteFormat.png);
  return byteData?.buffer.asUint8List();
}
