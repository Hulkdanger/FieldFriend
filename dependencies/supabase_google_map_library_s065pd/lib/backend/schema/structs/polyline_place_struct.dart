// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PolylinePlaceStruct extends FFFirebaseStruct {
  PolylinePlaceStruct({
    int? id,
    String? title,
    LatLng? coordinates,
    int? polylineId,
    int? order,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _title = title,
        _coordinates = coordinates,
        _polylineId = polylineId,
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

  // "polyline_id" field.
  int? _polylineId;
  int get polylineId => _polylineId ?? 0;
  set polylineId(int? val) => _polylineId = val;

  void incrementPolylineId(int amount) => polylineId = polylineId + amount;

  bool hasPolylineId() => _polylineId != null;

  // "order" field.
  int? _order;
  int get order => _order ?? 0;
  set order(int? val) => _order = val;

  void incrementOrder(int amount) => order = order + amount;

  bool hasOrder() => _order != null;

  static PolylinePlaceStruct fromMap(Map<String, dynamic> data) =>
      PolylinePlaceStruct(
        id: castToType<int>(data['id']),
        title: data['title'] as String?,
        coordinates: data['coordinates'] as LatLng?,
        polylineId: castToType<int>(data['polyline_id']),
        order: castToType<int>(data['order']),
      );

  static PolylinePlaceStruct? maybeFromMap(dynamic data) => data is Map
      ? PolylinePlaceStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'coordinates': _coordinates,
        'polyline_id': _polylineId,
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
        'polyline_id': serializeParam(
          _polylineId,
          ParamType.int,
        ),
        'order': serializeParam(
          _order,
          ParamType.int,
        ),
      }.withoutNulls;

  static PolylinePlaceStruct fromSerializableMap(Map<String, dynamic> data) =>
      PolylinePlaceStruct(
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
        polylineId: deserializeParam(
          data['polyline_id'],
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
  String toString() => 'PolylinePlaceStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PolylinePlaceStruct &&
        id == other.id &&
        title == other.title &&
        coordinates == other.coordinates &&
        polylineId == other.polylineId &&
        order == other.order;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, title, coordinates, polylineId, order]);
}

PolylinePlaceStruct createPolylinePlaceStruct({
  int? id,
  String? title,
  LatLng? coordinates,
  int? polylineId,
  int? order,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PolylinePlaceStruct(
      id: id,
      title: title,
      coordinates: coordinates,
      polylineId: polylineId,
      order: order,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PolylinePlaceStruct? updatePolylinePlaceStruct(
  PolylinePlaceStruct? polylinePlace, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    polylinePlace
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPolylinePlaceStructData(
  Map<String, dynamic> firestoreData,
  PolylinePlaceStruct? polylinePlace,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (polylinePlace == null) {
    return;
  }
  if (polylinePlace.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && polylinePlace.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final polylinePlaceData =
      getPolylinePlaceFirestoreData(polylinePlace, forFieldValue);
  final nestedData =
      polylinePlaceData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = polylinePlace.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPolylinePlaceFirestoreData(
  PolylinePlaceStruct? polylinePlace, [
  bool forFieldValue = false,
]) {
  if (polylinePlace == null) {
    return {};
  }
  final firestoreData = mapToFirestore(polylinePlace.toMap());

  // Add any Firestore field values
  polylinePlace.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPolylinePlaceListFirestoreData(
  List<PolylinePlaceStruct>? polylinePlaces,
) =>
    polylinePlaces
        ?.map((e) => getPolylinePlaceFirestoreData(e, true))
        .toList() ??
    [];
