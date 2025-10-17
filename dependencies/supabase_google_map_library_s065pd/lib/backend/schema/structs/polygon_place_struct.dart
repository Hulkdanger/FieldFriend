// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PolygonPlaceStruct extends FFFirebaseStruct {
  PolygonPlaceStruct({
    int? id,
    String? title,
    LatLng? coordinates,
    int? polygonId,
    int? order,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _title = title,
        _coordinates = coordinates,
        _polygonId = polygonId,
        _order = order,
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

  // "coordinates" field.
  LatLng? _coordinates;
  LatLng? get coordinates => _coordinates;
  set coordinates(LatLng? val) => _coordinates = val;

  bool hasCoordinates() => _coordinates != null;

  // "polygon_id" field.
  int? _polygonId;
  int get polygonId => _polygonId ?? 0;
  set polygonId(int? val) => _polygonId = val;

  void incrementPolygonId(int amount) => polygonId = polygonId + amount;

  bool hasPolygonId() => _polygonId != null;

  // "order" field.
  int? _order;
  int get order => _order ?? 0;
  set order(int? val) => _order = val;

  void incrementOrder(int amount) => order = order + amount;

  bool hasOrder() => _order != null;

  static PolygonPlaceStruct fromMap(Map<String, dynamic> data) =>
      PolygonPlaceStruct(
        id: castToType<int>(data['id']),
        title: data['title'] as String?,
        coordinates: data['coordinates'] as LatLng?,
        polygonId: castToType<int>(data['polygon_id']),
        order: castToType<int>(data['order']),
      );

  static PolygonPlaceStruct? maybeFromMap(dynamic data) => data is Map
      ? PolygonPlaceStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'coordinates': _coordinates,
        'polygon_id': _polygonId,
        'order': _order,
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
        'coordinates': serializeParam(
          _coordinates,
          ParamType.LatLng,
        ),
        'polygon_id': serializeParam(
          _polygonId,
          ParamType.int,
        ),
        'order': serializeParam(
          _order,
          ParamType.int,
        ),
      }.withoutNulls;

  static PolygonPlaceStruct fromSerializableMap(Map<String, dynamic> data) =>
      PolygonPlaceStruct(
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
        coordinates: deserializeParam(
          data['coordinates'],
          ParamType.LatLng,
          false,
        ),
        polygonId: deserializeParam(
          data['polygon_id'],
          ParamType.int,
          false,
        ),
        order: deserializeParam(
          data['order'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'PolygonPlaceStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PolygonPlaceStruct &&
        id == other.id &&
        title == other.title &&
        coordinates == other.coordinates &&
        polygonId == other.polygonId &&
        order == other.order;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, title, coordinates, polygonId, order]);
}

PolygonPlaceStruct createPolygonPlaceStruct({
  int? id,
  String? title,
  LatLng? coordinates,
  int? polygonId,
  int? order,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PolygonPlaceStruct(
      id: id,
      title: title,
      coordinates: coordinates,
      polygonId: polygonId,
      order: order,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PolygonPlaceStruct? updatePolygonPlaceStruct(
  PolygonPlaceStruct? polygonPlace, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    polygonPlace
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPolygonPlaceStructData(
  Map<String, dynamic> firestoreData,
  PolygonPlaceStruct? polygonPlace,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (polygonPlace == null) {
    return;
  }
  if (polygonPlace.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && polygonPlace.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final polygonPlaceData =
      getPolygonPlaceFirestoreData(polygonPlace, forFieldValue);
  final nestedData =
      polygonPlaceData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = polygonPlace.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPolygonPlaceFirestoreData(
  PolygonPlaceStruct? polygonPlace, [
  bool forFieldValue = false,
]) {
  if (polygonPlace == null) {
    return {};
  }
  final firestoreData = mapToFirestore(polygonPlace.toMap());

  // Add any Firestore field values
  polygonPlace.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPolygonPlaceListFirestoreData(
  List<PolygonPlaceStruct>? polygonPlaces,
) =>
    polygonPlaces?.map((e) => getPolygonPlaceFirestoreData(e, true)).toList() ??
    [];
