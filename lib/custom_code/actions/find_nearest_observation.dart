// Automatic FlutterFlow imports
import '/backend/backend.dart';
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;
import '/actions/actions.dart' as action_blocks;
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

/// Finds the nearest observation to [userLocation] within the last 30 days,
/// skipping "NO LOCUST"; writes a message to App State and returns it.
Future<String> findNearestObservation(
  BuildContext context,
  LatLng? userLocation,
) async {
  const na = 'N/A';

  try {
    if (userLocation == null) {
      const msg = 'Location unavailable.';
      _writeToAppState(msg);
      return msg;
    }

    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    final cutoffTs = Timestamp.fromDate(cutoff);
    debugPrint('[Nearest] cutoff (>=): ${cutoff.toIso8601String()}');

    final qs = await FirebaseFirestore.instance
        .collection('locustObservations')
        .where('obsDate', isGreaterThanOrEqualTo: cutoffTs)
        .get();

    if (qs.docs.isEmpty) {
      const msg = 'No observations found.';
      _writeToAppState(msg);
      return msg;
    }

    double? bestKm;
    String bestBehaviour = na;
    String bestMaturity = na;

    int scanned = 0, skippedNoLocust = 0, skippedNoGeo = 0;

    for (final d in qs.docs) {
      scanned++;
      final data = d.data();

      final typeVal =
          (data['RAMSES_Locust_Type'] ?? '').toString().toUpperCase();
      if (typeVal == 'NO LOCUST') {
        skippedNoLocust++;
        continue;
      }

      final gp = data['location'];
      if (gp is! GeoPoint) {
        skippedNoGeo++;
        continue;
      }

      final obs = LatLng(gp.latitude, gp.longitude);
      final dk = _distanceKm(userLocation, obs);

      if (bestKm == null || dk < bestKm) {
        bestKm = dk;
        bestBehaviour = _firstNonEmptyString(
            data,
            const [
              'Behaviour',
              'behavior',
              'behaviour',
              'Behavior',
            ],
            fallback: na);
        bestMaturity = _firstNonEmptyString(
            data,
            const [
              'Maturity',
              'maturity',
              'Breeding',
              'breeding',
            ],
            fallback: na);
      }

      // Optional: log a few documents for verification
      final ts = data['obsDate'];
      if (ts is Timestamp && scanned <= 5) {
        debugPrint(
            '[Nearest] sample#${scanned}: obsDate=${ts.toDate().toIso8601String()} type=$typeVal');
      }
    }

    debugPrint(
        '[Nearest] scanned=$scanned, skippedNoLocust=$skippedNoLocust, skippedNoGeo=$skippedNoGeo, bestKm=$bestKm');

    if (bestKm == null) {
      const msg = 'No valid locations found.';
      _writeToAppState(msg);
      return msg;
    }

    final msg = 'Nearest observation is ${bestKm.toStringAsFixed(2)} km away. '
        'Behaviour: $bestBehaviour, Maturity: $bestMaturity.';
    _writeToAppState(msg);
    return msg;
  } catch (e, st) {
    final msg = 'Error: ${e.toString()}';
    debugPrint('[Nearest] ERROR: $e');
    debugPrint(st.toString());
    _writeToAppState(msg);
    return msg;
  }
}

void _writeToAppState(String value) {
  FFAppState().update(() {
    FFAppState().nearestObservationText = value;
  });
}

double _distanceKm(LatLng a, LatLng b) {
  const R = 6371.0;
  final dLat = _deg2rad(b.latitude - a.latitude);
  final dLon = _deg2rad(b.longitude - a.longitude);
  final la1 = _deg2rad(a.latitude);
  final la2 = _deg2rad(b.latitude);

  final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(la1) * math.cos(la2) * math.sin(dLon / 2) * math.sin(dLon / 2);

  return 2 * R * math.asin(math.sqrt(h));
}

double _deg2rad(double deg) => deg * math.pi / 180.0;

String _firstNonEmptyString(Map<String, dynamic> data, List<String> keys,
    {String fallback = '—'}) {
  for (final k in keys) {
    final v = data[k];
    if (v != null) {
      final s = v.toString().trim();
      if (s.isNotEmpty) return s;
    }
  }
  return fallback;
}
