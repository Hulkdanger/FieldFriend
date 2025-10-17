// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PolylineStruct extends FFFirebaseStruct {
  PolylineStruct({
    int? id,
    String? title,
    double? zoom,
    int? strokeWeight,
    String? strokeColor,
    double? strokeOpacity,
    bool? geodesic,
    List<PolylinePlaceStruct>? polylinePlaces,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _title = title,
        _zoom = zoom,
        _strokeWeight = strokeWeight,
        _strokeColor = strokeColor,
        _strokeOpacity = strokeOpacity,
        _geodesic = geodesic,
        _polylinePlaces = polylinePlaces,
        super(firestoreUtilData);

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "zoom" field.
  double? _zoom;
  double get zoom => _zoom ?? 0.0;
  set zoom(double? val) => _zoom = val;

  void incrementZoom(double amount) => zoom = zoom + amount;

  bool hasZoom() => _zoom != null;

  // "stroke_weight" field.
  int? _strokeWeight;
  int get strokeWeight => _strokeWeight ?? 0;
  set strokeWeight(int? val) => _strokeWeight = val;

  void incrementStrokeWeight(int amount) =>
      strokeWeight = strokeWeight + amount;

  bool hasStrokeWeight() => _strokeWeight != null;

  // "stroke_color" field.
  String? _strokeColor;
  String get strokeColor => _strokeColor ?? '';
  set strokeColor(String? val) => _strokeColor = val;

  bool hasStrokeColor() => _strokeColor != null;

  // "stroke_opacity" field.
  double? _strokeOpacity;
  double get strokeOpacity => _strokeOpacity ?? 0.0;
  set strokeOpacity(double? val) => _strokeOpacity = val;

  void incrementStrokeOpacity(double amount) =>
      strokeOpacity = strokeOpacity + amount;

  bool hasStrokeOpacity() => _strokeOpacity != null;

  // "geodesic" field.
  bool? _geodesic;
  bool get geodesic => _geodesic ?? false;
  set geodesic(bool? val) => _geodesic = val;

  bool hasGeodesic() => _geodesic != null;

  // "polyline_places" field.
  List<PolylinePlaceStruct>? _polylinePlaces;
  List<PolylinePlaceStruct> get polylinePlaces => _polylinePlaces ?? const [];
  set polylinePlaces(List<PolylinePlaceStruct>? val) => _polylinePlaces = val;

  void updatePolylinePlaces(Function(List<PolylinePlaceStruct>) updateFn) {
    updateFn(_polylinePlaces ??= []);
  }

  bool hasPolylinePlaces() => _polylinePlaces != null;

  static PolylineStruct fromMap(Map<String, dynamic> data) => PolylineStruct(
        id: castToType<int>(data['id']),
        title: data['title'] as String?,
        zoom: castToType<double>(data['zoom']),
        strokeWeight: castToType<int>(data['stroke_weight']),
        strokeColor: data['stroke_color'] as String?,
        strokeOpacity: castToType<double>(data['stroke_opacity']),
        geodesic: data['geodesic'] as bool?,
        polylinePlaces: getStructList(
          data['polyline_places'],
          PolylinePlaceStruct.fromMap,
        ),
      );

  static PolylineStruct? maybeFromMap(dynamic data) =>
      data is Map ? PolylineStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'zoom': _zoom,
        'stroke_weight': _strokeWeight,
        'stroke_color': _strokeColor,
        'stroke_opacity': _strokeOpacity,
        'geodesic': _geodesic,
        'polyline_places': _polylinePlaces?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'zoom': serializeParam(
          _zoom,
          ParamType.double,
        ),
        'stroke_weight': serializeParam(
          _strokeWeight,
          ParamType.int,
        ),
        'stroke_color': serializeParam(
          _strokeColor,
          ParamType.String,
        ),
        'stroke_opacity': serializeParam(
          _strokeOpacity,
          ParamType.double,
        ),
        'geodesic': serializeParam(
          _geodesic,
          ParamType.bool,
        ),
        'polyline_places': serializeParam(
          _polylinePlaces,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static PolylineStruct fromSerializableMap(Map<String, dynamic> data) =>
      PolylineStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        zoom: deserializeParam(
          data['zoom'],
          ParamType.double,
          false,
        ),
        strokeWeight: deserializeParam(
          data['stroke_weight'],
          ParamType.int,
          false,
        ),
        strokeColor: deserializeParam(
          data['stroke_color'],
          ParamType.String,
          false,
        ),
        strokeOpacity: deserializeParam(
          data['stroke_opacity'],
          ParamType.double,
          false,
        ),
        geodesic: deserializeParam(
          data['geodesic'],
          ParamType.bool,
          false,
        ),
        polylinePlaces: deserializeStructParam<PolylinePlaceStruct>(
          data['polyline_places'],
          ParamType.DataStruct,
          true,
          structBuilder: PolylinePlaceStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'PolylineStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PolylineStruct &&
        id == other.id &&
        title == other.title &&
        zoom == other.zoom &&
        strokeWeight == other.strokeWeight &&
        strokeColor == other.strokeColor &&
        strokeOpacity == other.strokeOpacity &&
        geodesic == other.geodesic &&
        listEquality.equals(polylinePlaces, other.polylinePlaces);
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        title,
        zoom,
        strokeWeight,
        strokeColor,
        strokeOpacity,
        geodesic,
        polylinePlaces
      ]);
}

PolylineStruct createPolylineStruct({
  int? id,
  String? title,
  double? zoom,
  int? strokeWeight,
  String? strokeColor,
  double? strokeOpacity,
  bool? geodesic,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PolylineStruct(
      id: id,
      title: title,
      zoom: zoom,
      strokeWeight: strokeWeight,
      strokeColor: strokeColor,
      strokeOpacity: strokeOpacity,
      geodesic: geodesic,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PolylineStruct? updatePolylineStruct(
  PolylineStruct? polyline, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    polyline
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPolylineStructData(
  Map<String, dynamic> firestoreData,
  PolylineStruct? polyline,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (polyline == null) {
    return;
  }
  if (polyline.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && polyline.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final polylineData = getPolylineFirestoreData(polyline, forFieldValue);
  final nestedData = polylineData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = polyline.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPolylineFirestoreData(
  PolylineStruct? polyline, [
  bool forFieldValue = false,
]) {
  if (polyline == null) {
    return {};
  }
  final firestoreData = mapToFirestore(polyline.toMap());

  // Add any Firestore field values
  polyline.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPolylineListFirestoreData(
  List<PolylineStruct>? polylines,
) =>
    polylines?.map((e) => getPolylineFirestoreData(e, true)).toList() ?? [];
