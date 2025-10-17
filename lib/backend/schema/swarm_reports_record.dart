import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SwarmReportsRecord extends FirestoreRecord {
  SwarmReportsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "Title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "rawBehaviour" field.
  String? _rawBehaviour;
  String get rawBehaviour => _rawBehaviour ?? '';
  bool hasRawBehaviour() => _rawBehaviour != null;

  void _initializeFields() {
    _location = snapshotData['Location'] as LatLng?;
    _title = snapshotData['Title'] as String?;
    _rawBehaviour = snapshotData['rawBehaviour'] as String?;
  }

  static CollectionReference get collection => FirebaseFirestore.instanceFor(
          app: Firebase.app(), databaseId: '(default)')
      .collection('swarm_reports');

  static Stream<SwarmReportsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SwarmReportsRecord.fromSnapshot(s));

  static Future<SwarmReportsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SwarmReportsRecord.fromSnapshot(s));

  static SwarmReportsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SwarmReportsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SwarmReportsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SwarmReportsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SwarmReportsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SwarmReportsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSwarmReportsRecordData({
  LatLng? location,
  String? title,
  String? rawBehaviour,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Location': location,
      'Title': title,
      'rawBehaviour': rawBehaviour,
    }.withoutNulls,
  );

  return firestoreData;
}

class SwarmReportsRecordDocumentEquality
    implements Equality<SwarmReportsRecord> {
  const SwarmReportsRecordDocumentEquality();

  @override
  bool equals(SwarmReportsRecord? e1, SwarmReportsRecord? e2) {
    return e1?.location == e2?.location &&
        e1?.title == e2?.title &&
        e1?.rawBehaviour == e2?.rawBehaviour;
  }

  @override
  int hash(SwarmReportsRecord? e) =>
      const ListEquality().hash([e?.location, e?.title, e?.rawBehaviour]);

  @override
  bool isValidKey(Object? o) => o is SwarmReportsRecord;
}
