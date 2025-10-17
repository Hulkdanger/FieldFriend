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

import 'package:ff_commons/flutter_flow/lat_lng.dart';

Future<void> updateRiskScores(
  List<LocustObservationsRecord> observations,
  LatLng? userLocation,
) async {
  // Call the calculateLocustRiskWithBreakdown function
  dynamic breakdown = calculateLocustRiskWithBreakdown(
    observations,
    userLocation,
  );

  // Extract scores from the returned map
  double behaviourScore = (breakdown['behaviourScore'] ?? 0.0).toDouble();
  double maturityScore = (breakdown['maturityScore'] ?? 0.0).toDouble();
  double breedingScore = (breakdown['breedingScore'] ?? 0.0).toDouble();
  double distanceScore = (breakdown['distanceScore'] ?? 0.0).toDouble();
  double riskScore = (breakdown['riskScore'] ?? 0.0).toDouble();

  // Handle distance score special cases
  if (distanceScore == 0.0) {
    distanceScore = 0.3;
  } else if (distanceScore < 0.03) {
    distanceScore = 0.03;
  }

  // Update App State variables (as doubles)
  FFAppState().BehaviourScore = behaviourScore;
  FFAppState().MaturityScore = maturityScore;
  FFAppState().BreedingScore = breedingScore;
  FFAppState().DistanceScore = distanceScore;

  // Optional: If you have a RiskScore app state variable, update it too
  // Uncomment the lines below if you want to store the overall risk score
  // FFAppState().RiskScore = riskScore;
}
