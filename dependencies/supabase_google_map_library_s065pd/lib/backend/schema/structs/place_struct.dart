// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlaceStruct extends FFFirebaseStruct {
  PlaceStruct({
    String? title,
    String? description,
    LatLng? latLng,
    String? imageUrl,
    int? id,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _title = title,
        _description = description,
        _latLng = latLng,
        _imageUrl = imageUrl,
        _id = id,
        super(firestoreUtilData);

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "latLng" field.
  LatLng? _latLng;
  LatLng? get latLng => _latLng;
  set latLng(LatLng? val) => _latLng = val;

  bool hasLatLng() => _latLng != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  static PlaceStruct fromMap(Map<String, dynamic> data) => PlaceStruct(
        title: data['title'] as String?,
        description: data['description'] as String?,
        latLng: data['latLng'] as LatLng?,
        imageUrl: data['image_url'] as String?,
        id: castToType<int>(data['id']),
      );

  static PlaceStruct? maybeFromMap(dynamic data) =>
      data is Map ? PlaceStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'description': _description,
        'latLng': _latLng,
        'image_url': _imageUrl,
        'id': _id,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'latLng': serializeParam(
          _latLng,
          ParamType.LatLng,
        ),
        'image_url': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
      }.withoutNulls;

  static PlaceStruct fromSerializableMap(Map<String, dynamic> data) =>
      PlaceStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        latLng: deserializeParam(
          data['latLng'],
          ParamType.LatLng,
          false,
        ),
        imageUrl: deserializeParam(
          data['image_url'],
          ParamType.String,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'PlaceStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PlaceStruct &&
        title == other.title &&
        description == other.description &&
        latLng == other.latLng &&
        imageUrl == other.imageUrl &&
        id == other.id;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([title, description, latLng, imageUrl, id]);
}

PlaceStruct createPlaceStruct({
  String? title,
  String? description,
  LatLng? latLng,
  String? imageUrl,
  int? id,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PlaceStruct(
      title: title,
      description: description,
      latLng: latLng,
      imageUrl: imageUrl,
      id: id,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PlaceStruct? updatePlaceStruct(
  PlaceStruct? place, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    place
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPlaceStructData(
  Map<String, dynamic> firestoreData,
  PlaceStruct? place,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (place == null) {
    return;
  }
  if (place.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && place.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final placeData = getPlaceFirestoreData(place, forFieldValue);
  final nestedData = placeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = place.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPlaceFirestoreData(
  PlaceStruct? place, [
  bool forFieldValue = false,
]) {
  if (place == null) {
    return {};
  }
  final firestoreData = mapToFirestore(place.toMap());

  // Add any Firestore field values
  place.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPlaceListFirestoreData(
  List<PlaceStruct>? places,
) =>
    places?.map((e) => getPlaceFirestoreData(e, true)).toList() ?? [];
