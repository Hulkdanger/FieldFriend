import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _userLocation =
          latLngFromString(prefs.getString('ff_userLocation')) ?? _userLocation;
    });
    _safeInit(() {
      _installID = prefs.getString('ff_installID') ?? _installID;
    });
    _safeInit(() {
      _BreedingScore = prefs.getDouble('ff_BreedingScore') ?? _BreedingScore;
    });
    _safeInit(() {
      _BehaviourScore = prefs.getDouble('ff_BehaviourScore') ?? _BehaviourScore;
    });
    _safeInit(() {
      _MaturityScore = prefs.getDouble('ff_MaturityScore') ?? _MaturityScore;
    });
    _safeInit(() {
      _DistanceScore = prefs.getDouble('ff_DistanceScore') ?? _DistanceScore;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  LatLng? _userLocation = LatLng(26.820553, 30.802498);
  LatLng? get userLocation => _userLocation;
  set userLocation(LatLng? value) {
    _userLocation = value;
    value != null
        ? prefs.setString('ff_userLocation', value.serialize())
        : prefs.remove('ff_userLocation');
  }

  String _nearestObservationText = '';
  String get nearestObservationText => _nearestObservationText;
  set nearestObservationText(String value) {
    _nearestObservationText = value;
  }

  String _installID = '';
  String get installID => _installID;
  set installID(String value) {
    _installID = value;
    prefs.setString('ff_installID', value);
  }

  String _riskPreset = '';
  String get riskPreset => _riskPreset;
  set riskPreset(String value) {
    _riskPreset = value;
  }

  double _BreedingScore = 0.0;
  double get BreedingScore => _BreedingScore;
  set BreedingScore(double value) {
    _BreedingScore = value;
    prefs.setDouble('ff_BreedingScore', value);
  }

  double _BehaviourScore = 0.0;
  double get BehaviourScore => _BehaviourScore;
  set BehaviourScore(double value) {
    _BehaviourScore = value;
    prefs.setDouble('ff_BehaviourScore', value);
  }

  double _MaturityScore = 0.0;
  double get MaturityScore => _MaturityScore;
  set MaturityScore(double value) {
    _MaturityScore = value;
    prefs.setDouble('ff_MaturityScore', value);
  }

  double _DistanceScore = 0.0;
  double get DistanceScore => _DistanceScore;
  set DistanceScore(double value) {
    _DistanceScore = value;
    prefs.setDouble('ff_DistanceScore', value);
  }

  DateTime? _obsDateRef;
  DateTime? get obsDateRef => _obsDateRef;
  set obsDateRef(DateTime? value) {
    _obsDateRef = value;
  }

  final _reportLoadManager =
      StreamRequestManager<List<LocustObservationsRecord>>();
  Stream<List<LocustObservationsRecord>> reportLoad({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<LocustObservationsRecord>> Function() requestFn,
  }) =>
      _reportLoadManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearReportLoadCache() => _reportLoadManager.clear();
  void clearReportLoadCacheKey(String? uniqueKey) =>
      _reportLoadManager.clearRequest(uniqueKey);

  final _homePageLoadManager =
      StreamRequestManager<List<LocustObservationsRecord>>();
  Stream<List<LocustObservationsRecord>> homePageLoad({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<LocustObservationsRecord>> Function() requestFn,
  }) =>
      _homePageLoadManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearHomePageLoadCache() => _homePageLoadManager.clear();
  void clearHomePageLoadCacheKey(String? uniqueKey) =>
      _homePageLoadManager.clearRequest(uniqueKey);

  final _riskWijLoadManager =
      StreamRequestManager<List<LocustObservationsRecord>>();
  Stream<List<LocustObservationsRecord>> riskWijLoad({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<LocustObservationsRecord>> Function() requestFn,
  }) =>
      _riskWijLoadManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearRiskWijLoadCache() => _riskWijLoadManager.clear();
  void clearRiskWijLoadCacheKey(String? uniqueKey) =>
      _riskWijLoadManager.clearRequest(uniqueKey);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
