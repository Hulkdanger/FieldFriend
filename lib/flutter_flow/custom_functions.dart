import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ff_commons/flutter_flow/lat_lng.dart';
import 'package:ff_commons/flutter_flow/place.dart';
import 'package:ff_commons/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;

double calculateLocustRisk(
  List<LocustObservationsRecord> observations,
  LatLng? userLocation,
) {
  // Helper function: Calculate distance between two points in km
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371.0; // Earth radius in km

    // Convert degrees to radians
    double lat1Rad = lat1 * (math.pi / 180);
    double lat2Rad = lat2 * (math.pi / 180);
    double deltaLat = (lat2 - lat1) * (math.pi / 180);
    double deltaLon = (lon2 - lon1) * (math.pi / 180);

    // Haversine formula
    double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  // Maturity weight lookup
  double getMaturityWeight(String maturity) {
    switch (maturity) {
      case 'Mature':
        return 1.00;
      case 'Immature':
        return 0.70;
      case 'Hopper/Nymph':
        return 0.80;
      case 'N/A':
      case 'Unknown':
      default:
        return 0.60;
    }
  }

  // Behaviour weight lookup
  double getBehaviourWeight(String behaviour) {
    switch (behaviour) {
      case 'Scattered':
      case 'Isolated':
        return 0.40; // Same weight as specified
      case 'Groups':
        return 0.65;
      case 'Swarms':
        return 1.00;
      case 'N/A':
      case 'Unknown':
      default:
        return 0.60;
    }
  }

  // Breeding weight lookup
  double getBreedingWeight(String breeding) {
    switch (breeding) {
      case 'Copulating':
        return 0.85;
      case 'Laying':
        return 1.00;
      case 'N/A':
      default:
        return 0.70;
    }
  }

  // Return 0 if no observations
  if (observations.isEmpty) {
    return 0.0;
  }

  // Configuration constants
  const double timeHalfLife = 30.0; // days
  const double maxDaysOld = 180.0; // days
  const double distanceHalfLife = 100.0; // km

  double maxRisk = 0.0;

  // Check if we have user location for distance-based calculation
  bool hasUserLocation = userLocation != null;

  // If no user location, calculate general area risk without distance factor
  if (!hasUserLocation) {
    for (var obs in observations) {
      final obsDate = obs.obsDate;
      final maturity = obs.maturity;
      final behaviour = obs.behaviour;
      final breeding = obs.breeding;

      if (obsDate == null) {
        continue;
      }

      DateTime now = DateTime.now();
      double daysSince = now.difference(obsDate).inDays.toDouble();

      if (daysSince > maxDaysOld) {
        continue;
      }

      daysSince = math.min(daysSince, maxDaysOld);

      double recencyDecay = math.pow(2, -daysSince / timeHalfLife).toDouble();

      double wm = getMaturityWeight(maturity ?? 'N/A');
      double wb = getBehaviourWeight(behaviour ?? 'N/A');
      double wbr = getBreedingWeight(breeding ?? 'N/A');

      double severity = math.pow(wm * wb * wbr, 1.0 / 3.0).toDouble();

      double risk = 60.0 * recencyDecay * severity;

      risk = risk.clamp(0.0, 100.0);

      maxRisk = math.max(maxRisk, risk);
    }
  } else {
    // Original calculation WITH user location and distance factor
    for (var obs in observations) {
      final location = obs.location;
      final obsDate = obs.obsDate;
      final maturity = obs.maturity;
      final behaviour = obs.behaviour;
      final breeding = obs.breeding;

      if (location == null || obsDate == null) {
        continue;
      }

      double distance = calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        location.latitude,
        location.longitude,
      );

      DateTime now = DateTime.now();
      double daysSince = now.difference(obsDate).inDays.toDouble();

      if (daysSince > maxDaysOld) {
        continue;
      }

      daysSince = math.min(daysSince, maxDaysOld);

      double distanceDecay =
          math.pow(2, -distance / distanceHalfLife).toDouble();

      double recencyDecay = math.pow(2, -daysSince / timeHalfLife).toDouble();

      double wm = getMaturityWeight(maturity ?? 'N/A');
      double wb = getBehaviourWeight(behaviour ?? 'N/A');
      double wbr = getBreedingWeight(breeding ?? 'N/A');

      double severity = math.pow(wm * wb * wbr, 1.0 / 3.0).toDouble();

      double risk = 100.0 * distanceDecay * recencyDecay * severity;

      risk = risk.clamp(0.0, 100.0);

      maxRisk = math.max(maxRisk, risk);
    }
  }

  // If computed risk is exactly zero, keep 0% (e.g., no valid/young observations)
  if (maxRisk <= 0.0) {
    return 0.0;
  }

  // Enforce minimum display of 5% for any non-zero risk below 5% (do this BEFORE rounding can zero it out)
  if (maxRisk < 5.0) {
    // Return 5% as 0.05 for the progress bar
    return 0.05;
  }

  // Format the risk value (>= 5%)
  double finalRisk;
  if (maxRisk >= 1.0) {
    // For risks 1% and above, round to nearest integer
    finalRisk = maxRisk.roundToDouble();
  } else {
    // For risks between 0.5% and 1%, keep one decimal place
    finalRisk = (maxRisk * 10).roundToDouble() / 10;
  }

  // Return as decimal (0.0 to 1.0) for progress bar
  return finalRisk / 100.0;
}

String? getLocustRiskPercentage(
  List<LocustObservationsRecord>? observations,
  LatLng? userLocation,
) {
  // Handle null observations
  if (observations == null || observations.isEmpty) {
    return '0%';
  }

  // Calculate the risk value
  double riskValue = calculateLocustRisk(observations, userLocation);

  // Convert to percentage and return
  return '${(riskValue * 100)}%';
// Declare toPercentage FIRST
}

dynamic calculateLocustRiskWithBreakdown(
  List<LocustObservationsRecord>? observations,
  LatLng? userLocation,
) {
  // Handle null observations list
  if (observations == null || observations.isEmpty) {
    return {
      'riskScore': 0.0,
      'behaviourScore': 0.0,
      'maturityScore': 0.0,
      'breedingScore': 0.0,
      'distanceScore': 0.0,
    };
  }

  // Helper function: Calculate distance between two points in km
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371.0; // Earth radius in km

    // Convert degrees to radians
    double lat1Rad = lat1 * (math.pi / 180);
    double lat2Rad = lat2 * (math.pi / 180);
    double deltaLat = (lat2 - lat1) * (math.pi / 180);
    double deltaLon = (lon2 - lon1) * (math.pi / 180);

    // Haversine formula
    double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  // Maturity weight lookup
  double getMaturityWeight(String maturity) {
    switch (maturity) {
      case 'Mature':
        return 1.00;
      case 'Immature':
        return 0.70;
      case 'Hopper/Nymph':
        return 0.80;
      case 'N/A':
      case 'Unknown':
      default:
        return 0.60;
    }
  }

  // Behaviour weight lookup
  double getBehaviourWeight(String behaviour) {
    switch (behaviour) {
      case 'Scattered':
      case 'Isolated':
        return 0.40;
      case 'Groups':
        return 0.65;
      case 'Swarms':
        return 1.00;
      case 'N/A':
      case 'Unknown':
      default:
        return 0.60;
    }
  }

  // Breeding weight lookup
  double getBreedingWeight(String breeding) {
    switch (breeding) {
      case 'Copulating':
        return 0.85;
      case 'Laying':
        return 1.00;
      case 'N/A':
      default:
        return 0.70;
    }
  }

  // Configuration constants
  const double timeHalfLife = 30.0; // days
  const double maxDaysOld = 180.0; // days
  const double distanceHalfLife = 100.0; // km

  double maxRisk = 0.0;

  // Track component scores for the highest risk observation
  double maxBehaviourScore = 0.0;
  double maxMaturityScore = 0.0;
  double maxBreedingScore = 0.0;
  double maxDistanceScore = 0.0;

  // Check if we have user location for distance-based calculation
  bool hasUserLocation = userLocation != null;

  // If no user location, calculate general area risk without distance factor
  if (!hasUserLocation) {
    for (var obs in observations) {
      final obsDate = obs.obsDate;
      final maturity = obs.maturity;
      final behaviour = obs.behaviour;
      final breeding = obs.breeding;

      if (obsDate == null) {
        continue;
      }

      DateTime now = DateTime.now();
      double daysSince = now.difference(obsDate).inDays.toDouble();

      if (daysSince > maxDaysOld) {
        continue;
      }

      daysSince = math.min(daysSince, maxDaysOld);

      double recencyDecay = math.pow(2, -daysSince / timeHalfLife).toDouble();

      double wm = getMaturityWeight(maturity ?? 'N/A');
      double wb = getBehaviourWeight(behaviour ?? 'N/A');
      double wbr = getBreedingWeight(breeding ?? 'N/A');

      double severity = math.pow(wm * wb * wbr, 1.0 / 3.0).toDouble();

      double risk = 60.0 * recencyDecay * severity;

      risk = risk.clamp(0.0, 100.0);

      // If this is the highest risk, track component scores
      if (risk > maxRisk) {
        maxRisk = risk;
        maxBehaviourScore = wb;
        maxMaturityScore = wm;
        maxBreedingScore = wbr;
        maxDistanceScore = 1.0; // No distance factor when no user location
      }
    }
  } else {
    // Original calculation WITH user location and distance factor
    for (var obs in observations) {
      final location = obs.location;
      final obsDate = obs.obsDate;
      final maturity = obs.maturity;
      final behaviour = obs.behaviour;
      final breeding = obs.breeding;

      if (location == null || obsDate == null) {
        continue;
      }

      double distance = calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        location.latitude,
        location.longitude,
      );

      DateTime now = DateTime.now();
      double daysSince = now.difference(obsDate).inDays.toDouble();

      if (daysSince > maxDaysOld) {
        continue;
      }

      daysSince = math.min(daysSince, maxDaysOld);

      double distanceDecay =
          math.pow(2, -distance / distanceHalfLife).toDouble();

      double recencyDecay = math.pow(2, -daysSince / timeHalfLife).toDouble();

      double wm = getMaturityWeight(maturity ?? 'N/A');
      double wb = getBehaviourWeight(behaviour ?? 'N/A');
      double wbr = getBreedingWeight(breeding ?? 'N/A');

      double severity = math.pow(wm * wb * wbr, 1.0 / 3.0).toDouble();

      double risk = 100.0 * distanceDecay * recencyDecay * severity;

      risk = risk.clamp(0.0, 100.0);

      // If this is the highest risk, track component scores
      if (risk > maxRisk) {
        maxRisk = risk;
        maxBehaviourScore = wb;
        maxMaturityScore = wm;
        maxBreedingScore = wbr;
        maxDistanceScore = distanceDecay;
      }
    }
  }

  // Calculate final risk score
  double finalRiskScore;

  // If computed risk is exactly zero, keep 0%
  if (maxRisk <= 0.0) {
    finalRiskScore = 0.0;
  }
  // Enforce minimum display of 5% for any non-zero risk below 5%
  else if (maxRisk < 5.0) {
    finalRiskScore = 0.05;
  } else {
    // Format the risk value (>= 5%)
    if (maxRisk >= 1.0) {
      // For risks 1% and above, round to nearest integer
      finalRiskScore = maxRisk.roundToDouble() / 100.0;
    } else {
      // For risks between 0.5% and 1%, keep one decimal place
      finalRiskScore = ((maxRisk * 10).roundToDouble() / 10) / 100.0;
    }
  }

  // Return Map with all component scores
  return {
    'riskScore': finalRiskScore,
    'behaviourScore': maxBehaviourScore,
    'maturityScore': maxMaturityScore,
    'breedingScore': maxBreedingScore,
    'distanceScore': maxDistanceScore,
  };
}
