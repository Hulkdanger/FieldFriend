import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LocustObservationsRecord extends FirestoreRecord {
  LocustObservationsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "Behaviour" field.
  String? _behaviour;
  String get behaviour => _behaviour ?? '';
  bool hasBehaviour() => _behaviour != null;

  // "Maturity" field.
  String? _maturity;
  String get maturity => _maturity ?? '';
  bool hasMaturity() => _maturity != null;

  // "obsDate" field.
  DateTime? _obsDate;
  DateTime? get obsDate => _obsDate;
  bool hasObsDate() => _obsDate != null;

  // "Country" field.
  String? _country;
  String get country => _country ?? '';
  bool hasCountry() => _country != null;

  // "UCG" field.
  String? _ucg;
  String get ucg => _ucg ?? '';
  bool hasUcg() => _ucg != null;

  // "Breeding" field.
  String? _breeding;
  String get breeding => _breeding ?? '';
  bool hasBreeding() => _breeding != null;

  void _initializeFields() {
    _location = snapshotData['location'] as LatLng?;
    _behaviour = snapshotData['Behaviour'] as String?;
    _maturity = snapshotData['Maturity'] as String?;
    _obsDate = snapshotData['obsDate'] as DateTime?;
    _country = snapshotData['Country'] as String?;
    _ucg = snapshotData['UCG'] as String?;
    _breeding = snapshotData['Breeding'] as String?;
  }

  static CollectionReference get collection => FirebaseFirestore.instanceFor(
          app: Firebase.app(), databaseId: '(default)')
      .collection('locustObservations');

  static Stream<LocustObservationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LocustObservationsRecord.fromSnapshot(s));

  static Future<LocustObservationsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => LocustObservationsRecord.fromSnapshot(s));

  static LocustObservationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      LocustObservationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LocustObservationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LocustObservationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LocustObservationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LocustObservationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLocustObservationsRecordData({
  LatLng? location,
  String? behaviour,
  String? maturity,
  DateTime? obsDate,
  String? country,
  String? ucg,
  String? breeding,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'location': location,
      'Behaviour': behaviour,
      'Maturity': maturity,
      'obsDate': obsDate,
      'Country': country,
      'UCG': ucg,
      'Breeding': breeding,
    }.withoutNulls,
  );

  return firestoreData;
}

class LocustObservationsRecordDocumentEquality
    implements Equality<LocustObservationsRecord> {
  const LocustObservationsRecordDocumentEquality();

  @override
  bool equals(LocustObservationsRecord? e1, LocustObservationsRecord? e2) {
    return e1?.location == e2?.location &&
        e1?.behaviour == e2?.behaviour &&
        e1?.maturity == e2?.maturity &&
        e1?.obsDate == e2?.obsDate &&
        e1?.country == e2?.country &&
        e1?.ucg == e2?.ucg &&
        e1?.breeding == e2?.breeding;
  }

  @override
  int hash(LocustObservationsRecord? e) => const ListEquality().hash([
        e?.location,
        e?.behaviour,
        e?.maturity,
        e?.obsDate,
        e?.country,
        e?.ucg,
        e?.breeding
      ]);

  @override
  bool isValidKey(Object? o) => o is LocustObservationsRecord;
}
