// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng2;

class CBTileMap extends StatefulWidget {
  const CBTileMap({
    super.key,
    this.width,
    this.height,
    required this.publicAccessToken,
    required this.urlTemplate,
    required this.allowZoom,
    required this.showZoomControls,
    required this.showLocation,
    required this.showCompass,
    required this.showMapToolbar,
    required this.showTraffic,
    required this.centerCoordinates,
    this.places,
    required this.defaultZoom,
    this.onClickMarker,
    this.polygons,
    this.polylines,
  });

  final double? width;
  final double? height;
  final String publicAccessToken;
  final String urlTemplate;
  final bool allowZoom;
  final bool showZoomControls;
  final bool showLocation;
  final bool showCompass;
  final bool showMapToolbar;
  final bool showTraffic;
  final LatLng centerCoordinates;
  final List<PlaceStruct>? places;
  final Future Function(PlaceStruct? place)? onClickMarker;
  final double defaultZoom;
  final List<PolygonStruct>? polygons;
  final List<PolylineStruct>? polylines;

  @override
  State<CBTileMap> createState() => _CBTileMapState();
}

class _CBTileMapState extends State<CBTileMap> {
  final ACCESS_TOKEN = "accessToken";
  final String HTTPS = "https";
  final IMAGES_PATH = "assets/images/";
  final UNDERSCORE = '_';
  final MARKER = "Marker";

  List<Marker> _markers = [];
  List<Polygon> _polygons = [];
  List<Polyline> _polylines = [];

  @override
  void didUpdateWidget(CBTileMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    updateMapData(oldWidget);
  }

  Future<void> updateMapData(CBTileMap oldWidget) async {
    await _precacheImages();

    if (oldWidget.places != widget.places) {
      _loadMarkers();
    }

    if (oldWidget.polygons != widget.polygons) {
      _loadPolygons();
    }

    if (oldWidget.polylines != widget.polylines) {
      _loadPolylines();
    }
  }

  Future<void> _precacheImages() async {
    // Precache all images
    for (var place in widget.places ?? []) {
      if (place?.imageUrl != null) {
        if (place!.imageUrl!.toLowerCase().contains(HTTPS)) {
          await precacheImage(NetworkImage(place.imageUrl!), context);
        } else {
          await precacheImage(
              AssetImage('$IMAGES_PATH${place.imageUrl!}'), context);
        }
      }
    }
  }

  Color getColorFromHex(String hexColor) {
    return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void _loadMarkers() {
    final markers = widget.places?.map((place) {
      var markerWidget;
      if (place?.imageUrl != null) {
        markerWidget = MapMarkerImage(
          imagePath: place!.imageUrl!,
          place: place,
          onTap: widget.onClickMarker,
        );
      } else {
        markerWidget = Icon(
          Icons.location_on,
          color: Colors.red,
          size: 50,
        );
      }
      return Marker(
        point: latlng2.LatLng(
            place?.latLng?.latitude ?? 0.0, place?.latLng?.longitude ?? 0.0),
        child: markerWidget,
      );
    }).toList();
    setState(() {
      _markers = markers ?? [];
    });
  }

  void _loadPolygons() {
    if (widget.polygons != null && widget.polygons!.isNotEmpty) {
      List<Polygon> polygons = [];
      widget.polygons?.forEach((polygon) {
        List<latlng2.LatLng> points = [];
        List<PolygonPlaceStruct> sorted =
            List.from(polygon.polygonPlaces ?? []);
        sorted.sort((a, b) => a.order.compareTo(b.order));
        sorted.forEach((polygonPlace) {
          points.add(
            latlng2.LatLng(polygonPlace.coordinates?.latitude ?? 0.0,
                polygonPlace.coordinates?.longitude ?? 0.0),
          );
        });
        polygons.add(
          Polygon(
            points: points,
            color: getColorFromHex(polygon.fillColor)
                .withOpacity(polygon.fillOpacity),
            borderColor: getColorFromHex(polygon.strokeColor),
            borderStrokeWidth: polygon.strokeWeight.toDouble(),
            isFilled: true,
          ),
        );
      });
      setState(() {
        _polygons = polygons;
      });
    }
  }

  void _loadPolylines() {
    if (widget.polylines != null && widget.polylines!.isNotEmpty) {
      List<Polyline> polylines = [];
      widget.polylines?.forEach((polyline) {
        List<latlng2.LatLng> points = [];
        List<PolylinePlaceStruct> sorted = List.from(polyline.polylinePlaces);
        sorted.sort((a, b) => a.order.compareTo(b.order));
        sorted.forEach((polylinePlace) {
          points.add(
            latlng2.LatLng(polylinePlace.coordinates?.latitude ?? 0.0,
                polylinePlace.coordinates?.longitude ?? 0.0),
          );
        });
        polylines.add(
          Polyline(
            points: points,
            color: getColorFromHex(polyline.strokeColor),
            strokeWidth: polyline.strokeWeight.toDouble(),
            strokeCap: StrokeCap.round,
            strokeJoin: StrokeJoin.round,
            pattern: const StrokePattern.solid(),
          ),
        );
      });
      setState(() {
        _polylines = polylines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
          initialCenter: latlng2.LatLng(widget.centerCoordinates.latitude,
              widget.centerCoordinates.longitude),
          initialZoom: widget.defaultZoom,
          maxZoom: widget.defaultZoom),
      children: [
        TileLayer(
          urlTemplate: "${widget.urlTemplate}",
          additionalOptions: {
            ACCESS_TOKEN: widget.publicAccessToken,
          },
        ),
        MarkerLayer(
          markers: _markers,
        ),
      ],
    );
  }
}

class MapMarkerImage extends StatelessWidget {
  final String imagePath;
  final PlaceStruct? place;
  final Future Function(PlaceStruct? place)? onTap;

  const MapMarkerImage({
    Key? key,
    required this.imagePath,
    this.place,
    this.onTap,
  }) : super(key: key);

  final String HTTPS = "https";
  final ASSETS_IMAGES_PATH = "assets/images/";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (onTap != null) {
          await onTap!(place);
        }
      },
      child: imagePath.toLowerCase().contains(HTTPS)
          ? Image.network(imagePath)
          : Image.asset("$ASSETS_IMAGES_PATH$imagePath"),
    );
  }
}
