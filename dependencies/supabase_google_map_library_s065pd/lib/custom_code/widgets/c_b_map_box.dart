// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';

class CBMapBox extends StatefulWidget {
  const CBMapBox({
    super.key,
    this.width,
    this.height,
    required this.places,
    required this.zoom,
    required this.centerCoordinates,
    this.onClickMarker,
    required this.publicAccessToken,
  });

  final double? width;
  final double? height;
  final List<PlaceStruct> places;
  final double zoom;
  final LatLng centerCoordinates;
  final Future Function(PlaceStruct? place)? onClickMarker;
  final String publicAccessToken;

  @override
  State<CBMapBox> createState() => _CBMapBoxState();
}

class _CBMapBoxState extends State<CBMapBox> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  PointAnnotation? selectedAnnotation;
  PlaceStruct? selectedPlace;

  Future<Uint8List?> loadImage(String path) async {
    if (path.toLowerCase().startsWith('http')) {
      return await loadNetworkImage(path);
    } else {
      return await loadAssetImage(path);
    }
  }

  Future<Uint8List?> loadNetworkImage(String path) async {
    final completer = Completer<ImageInfo>();
    var image = NetworkImage(path);
    image.resolve(const ImageConfiguration()).addListener(ImageStreamListener(
        (ImageInfo info, bool _) => completer.complete(info)));
    final imageInfo = await completer.future;
    final byteData =
        await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<Uint8List?> loadAssetImage(String path) async {
    final completer = Completer<ImageInfo>();
    final assetPath =
        path.startsWith('assets/images/') ? path : 'assets/images/$path';
    var image = AssetImage(assetPath);
    image.resolve(const ImageConfiguration()).addListener(ImageStreamListener(
        (ImageInfo info, bool _) => completer.complete(info)));
    final imageInfo = await completer.future;
    final byteData =
        await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
    MapboxOptions.setAccessToken(widget.publicAccessToken);
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    // Add click listener
    pointAnnotationManager?.addOnPointAnnotationClickListener(
      MarkerClickListener(
        onClick: (annotation) async {
          setState(() {
            selectedAnnotation = annotation;
            selectedPlace = widget.places.firstWhere(
              (place) =>
                  place?.latLng?.latitude ==
                      annotation.geometry.coordinates.lat &&
                  place?.latLng?.longitude ==
                      annotation.geometry.coordinates.lng,
              orElse: () => widget.places.first,
            );
          });
          final callback = widget.onClickMarker;
          if (callback != null) {
            await callback(selectedPlace);
          }
        },
      ),
    );

    // Create markers for all places
    await _updateMarkers();
  }

  @override
  void didUpdateWidget(CBMapBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.places != widget.places) {
      _updateMarkers();
    }
  }

  Future<void> _updateMarkers() async {
    if (pointAnnotationManager != null) {
      // Clear existing markers
      await pointAnnotationManager?.deleteAll();

      // Create new markers for all places
      for (var place in widget.places) {
        if (place.imageUrl != null) {
          final imageData = await loadImage(place.imageUrl!);
          if (imageData != null) {
            PointAnnotationOptions pointAnnotationOptions =
                PointAnnotationOptions(
              geometry: Point(
                  coordinates: Position(place?.latLng?.longitude ?? 0.0,
                      place.latLng?.latitude ?? 0.0)),
              image: imageData,
              iconSize: 1.0,
            );

            try {
              await pointAnnotationManager?.create(pointAnnotationOptions);
            } catch (e) {
              print('Error creating point annotation: $e');
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: MapWidget(
        key: ValueKey("mapWidget"),
        cameraOptions: CameraOptions(
          center: Point(
            coordinates: Position(
              widget.centerCoordinates.longitude,
              widget.centerCoordinates.latitude,
            ),
          ),
          zoom: widget.zoom,
        ),
        styleUri: MapboxStyles.STANDARD,
        textureView: true,
        onMapCreated: _onMapCreated,
      ),
    );
  }
}

class MarkerClickListener extends OnPointAnnotationClickListener {
  final Function(PointAnnotation) onClick;

  MarkerClickListener({required this.onClick});

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    onClick(annotation);
  }
}
