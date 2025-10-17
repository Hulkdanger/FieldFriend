import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ScheduledLocustObservationsRecord extends FirestoreRecord {
  ScheduledLocustObservationsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Maturity" field.
  String? _maturity;
  String get maturity => _maturity ?? '';
  bool hasMaturity() => _maturity != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "obsDate" field.
  DateTime? _obsDate;
  DateTime? get obsDate => _obsDate;
  bool hasObsDate() => _obsDate != null;

  // "Country" field.
  String? _country;
  String get country => _country ?? '';
  bool hasCountry() => _country != null;

  // "scheduledTime" field.
  DateTime? _scheduledTime;
  DateTime? get scheduledTime => _scheduledTime;
  bool hasScheduledTime() => _scheduledTime != null;

  // "isScheduled" field.
  bool? _isScheduled;
  bool get isScheduled => _isScheduled ?? false;
  bool hasIsScheduled() => _isScheduled != null;

  // "UCG" field.
  String? _ucg;
  String get ucg => _ucg ?? '';
  bool hasUcg() => _ucg != null;

  // "Breeding" field.
  String? _breeding;
  String get breeding => _breeding ?? '';
  bool hasBreeding() => _breeding != null;

  // "Behaviour" field.
  String? _behaviour;
  String get behaviour => _behaviour ?? '';
  bool hasBehaviour() => _behaviour != null;

  // "submittedAt" field.
  DateTime? _submittedAt;
  DateTime? get submittedAt => _submittedAt;
  bool hasSubmittedAt() => _submittedAt != null;

  // "userId" field.
  String? _userId;
  String get userId => _userId ?? '';
  bool hasUserId() => _userId != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "documentId" field.
  String? _documentId;
  String get documentId => _documentId ?? '';
  bool hasDocumentId() => _documentId != null;

  void _initializeFields() {
    _maturity = snapshotData['Maturity'] as String?;
    _location = snapshotData['location'] as LatLng?;
    _obsDate = snapshotData['obsDate'] as DateTime?;
    _country = snapshotData['Country'] as String?;
    _scheduledTime = snapshotData['scheduledTime'] as DateTime?;
    _isScheduled = snapshotData['isScheduled'] as bool?;
    _ucg = snapshotData['UCG'] as String?;
    _breeding = snapshotData['Breeding'] as String?;
    _behaviour = snapshotData['Behaviour'] as String?;
    _submittedAt = snapshotData['submittedAt'] as DateTime?;
    _userId = snapshotData['userId'] as String?;
    _status = snapshotData['status'] as String?;
    _documentId = snapshotData['documentId'] as String?;
  }

  static CollectionReference get collection => FirebaseFirestore.instanceFor(
          app: Firebase.app(), databaseId: '(default)')
      .collection('scheduledLocustObservations');

  static Stream<ScheduledLocustObservationsRecord> getDocument(
          DocumentReference ref) =>
      ref
          .snapshots()
          .map((s) => ScheduledLocustObservationsRecord.fromSnapshot(s));

  static Future<ScheduledLocustObservationsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ScheduledLocustObservationsRecord.fromSnapshot(s));

  static ScheduledLocustObservationsRecord fromSnapshot(
          DocumentSnapshot snapshot) =>
      ScheduledLocustObservationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ScheduledLocustObservationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ScheduledLocustObservationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ScheduledLocustObservationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ScheduledLocustObservationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createScheduledLocustObservationsRecordData({
  String? maturity,
  LatLng? location,
  DateTime? obsDate,
  String? country,
  DateTime? scheduledTime,
  bool? isScheduled,
  String? ucg,
  String? breeding,
  String? behaviour,
  DateTime? submittedAt,
  String? userId,
  String? status,
  String? documentId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Maturity': maturity,
      'location': location,
      'obsDate': obsDate,
      'Country': country,
      'scheduledTime': scheduledTime,
      'isScheduled': isScheduled,
      'UCG': ucg,
      'Breeding': breeding,
      'Behaviour': behaviour,
      'submittedAt': submittedAt,
      'userId': userId,
      'status': status,
      'documentId': documentId,
    }.withoutNulls,
  );

  return firestoreData;
}

class ScheduledLocustObservationsRecordDocumentEquality
    implements Equality<ScheduledLocustObservationsRecord> {
  const ScheduledLocustObservationsRecordDocumentEquality();

  @override
  bool equals(ScheduledLocustObservationsRecord? e1,
      ScheduledLocustObservationsRecord? e2) {
    return e1?.maturity == e2?.maturity &&
        e1?.location == e2?.location &&
        e1?.obsDate == e2?.obsDate &&
        e1?.country == e2?.country &&
        e1?.scheduledTime == e2?.scheduledTime &&
        e1?.isScheduled == e2?.isScheduled &&
        e1?.ucg == e2?.ucg &&
        e1?.breeding == e2?.breeding &&
        e1?.behaviour == e2?.behaviour &&
        e1?.submittedAt == e2?.submittedAt &&
        e1?.userId == e2?.userId &&
        e1?.status == e2?.status &&
        e1?.documentId == e2?.documentId;
  }

  @override
  int hash(ScheduledLocustObservationsRecord? e) => const ListEquality().hash([
        e?.maturity,
        e?.location,
        e?.obsDate,
        e?.country,
        e?.scheduledTime,
        e?.isScheduled,
        e?.ucg,
        e?.breeding,
        e?.behaviour,
        e?.submittedAt,
        e?.userId,
        e?.status,
        e?.documentId
      ]);

  @override
  bool isValidKey(Object? o) => o is ScheduledLocustObservationsRecord;
}
