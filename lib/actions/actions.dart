import '/backend/backend.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

Future pageLoad(BuildContext context) async {
  await queryLocustObservationsRecordOnce(
    singleRecord: true,
  ).then((s) => s.firstOrNull);
}
