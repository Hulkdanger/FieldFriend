// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PolygonStruct extends FFFirebaseStruct {
  PolygonStruct({
    int? id,
    String? title,
    double? zoom,
    String? strokeColor,
    double? strokeOpacity,
    double? fillOpacity,
    String? fillColor,
    List<PolygonPlaceStruct>? polygonPlaces,
    int? strokeWeight,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _title = title,
        _zoom = zoom,
        _strokeColor = strokeColor,
        _strokeOpacity = strokeOpacity,
        _fillOpacity = fillOpacity,
        _fillColor = fillColor,
        _polygonPlaces = polygonPlaces,
        _strokeWeight = strokeWeight,
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

  // "fill_opacity" field.
  double? _fillOpacity;
  double get fillOpacity => _fillOpacity ?? 0.0;
  set fillOpacity(double? val) => _fillOpacity = val;

  void incrementFillOpacity(double amount) =>
      fillOpacity = fillOpacity + amount;

  bool hasFillOpacity() => _fillOpacity != null;

  // "fill_color" field.
  String? _fillColor;
  String get fillColor => _fillColor ?? '';
  set fillColor(String? val) => _fillColor = val;

  bool hasFillColor() => _fillColor != null;

  // "polygon_places" field.
  List<PolygonPlaceStruct>? _polygonPlaces;
  List<PolygonPlaceStruct> get polygonPlaces => _polygonPlaces ?? const [];
  set polygonPlaces(List<PolygonPlaceStruct>? val) => _polygonPlaces = val;

  void updatePolygonPlaces(Function(List<PolygonPlaceStruct>) updateFn) {
    updateFn(_polygonPlaces ??= []);
  }

  bool hasPolygonPlaces() => _polygonPlaces != null;

  // "stroke_weight" field.
  int? _strokeWeight;
  int get strokeWeight => _strokeWeight ?? 0;
  set strokeWeight(int? val) => _strokeWeight = val;

  void incrementStrokeWeight(int amount) =>
      strokeWeight = strokeWeight + amount;

  bool hasStrokeWeight() => _strokeWeight != null;

  static PolygonStruct fromMap(Map<String, dynamic> data) => PolygonStruct(
        id: castToType<int>(data['id']),
        title: data['title'] as String?,
        zoom: castToType<double>(data['zoom']),
        strokeColor: data['stroke_color'] as String?,
        strokeOpacity: castToType<double>(data['stroke_opacity']),
        fillOpacity: castToType<double>(data['fill_opacity']),
        fillColor: data['fill_color'] as String?,
        polygonPlaces: getStructList(
          data['polygon_places'],
          PolygonPlaceStruct.fromMap,
        ),
        strokeWeight: castToType<int>(data['stroke_weight']),
      );

  static PolygonStruct? maybeFromMap(dynamic data) =>
      data is Map ? PolygonStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'zoom': _zoom,
        'stroke_color': _strokeColor,
        'stroke_opacity': _strokeOpacity,
        'fill_opacity': _fillOpacity,
        'fill_color': _fillColor,
        'polygon_places': _polygonPlaces?.map((e) => e.toMap()).toList(),
        'stroke_weight': _strokeWeight,
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
        'stroke_color': serializeParam(
          _strokeColor,
          ParamType.String,
        ),
        'stroke_opacity': serializeParam(
          _strokeOpacity,
          ParamType.double,
        ),
        'fill_opacity': serializeParam(
          _fillOpacity,
          ParamType.double,
        ),
        'fill_color': serializeParam(
          _fillColor,
          ParamType.String,
        ),
        'polygon_places': serializeParam(
          _polygonPlaces,
          ParamType.DataStruct,
          isList: true,
        ),
        'stroke_weight': serializeParam(
          _strokeWeight,
          ParamType.int,
        ),
      }.withoutNulls;

  static PolygonStruct fromSerializableMap(Map<String, dynamic> data) =>
      PolygonStruct(
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
        fillOpacity: deserializeParam(
          data['fill_opacity'],
          ParamType.double,
          false,
        ),
        fillColor: deserializeParam(
          data['fill_color'],
          ParamType.String,
          false,
        ),
        polygonPlaces: deserializeStructParam<PolygonPlaceStruct>(
          data['polygon_places'],
          ParamType.DataStruct,
          true,
          structBuilder: PolygonPlaceStruct.fromSerializableMap,
        ),
        strokeWeight: deserializeParam(
          data['stroke_weight'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'PolygonStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PolygonStruct &&
        id == other.id &&
        title == other.title &&
        zoom == other.zoom &&
        strokeColor == other.strokeColor &&
        strokeOpacity == other.strokeOpacity &&
        fillOpacity == other.fillOpacity &&
        fillColor == other.fillColor &&
        listEquality.equals(polygonPlaces, other.polygonPlaces) &&
        strokeWeight == other.strokeWeight;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        title,
        zoom,
        strokeColor,
        strokeOpacity,
        fillOpacity,
        fillColor,
        polygonPlaces,
        strokeWeight
      ]);
}

PolygonStruct createPolygonStruct({
  int? id,
  String? title,
  double? zoom,
  String? strokeColor,
  double? strokeOpacity,
  double? fillOpacity,
  String? fillColor,
  int? strokeWeight,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PolygonStruct(
      id: id,
      title: title,
      zoom: zoom,
      strokeColor: strokeColor,
      strokeOpacity: strokeOpacity,
      fillOpacity: fillOpacity,
      fillColor: fillColor,
      strokeWeight: strokeWeight,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PolygonStruct? updatePolygonStruct(
  PolygonStruct? polygon, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    polygon
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPolygonStructData(
  Map<String, dynamic> firestoreData,
  PolygonStruct? polygon,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (polygon == null) {
    return;
  }
  if (polygon.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && polygon.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final polygonData = getPolygonFirestoreData(polygon, forFieldValue);
  final nestedData = polygonData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = polygon.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPolygonFirestoreData(
  PolygonStruct? polygon, [
  bool forFieldValue = false,
]) {
  if (polygon == null) {
    return {};
  }
  final firestoreData = mapToFirestore(polygon.toMap());

  // Add any Firestore field values
  polygon.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPolygonListFirestoreData(
  List<PolygonStruct>? polygons,
) =>
    polygons?.map((e) => getPolygonFirestoreData(e, true)).toList() ?? [];
