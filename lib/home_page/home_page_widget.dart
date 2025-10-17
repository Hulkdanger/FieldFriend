import '/backend/backend.dart';
import '/components/card15_dashboard_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'homePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      currentUserLocationValue =
          await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0));
      await actions.setDarkStatusBar();
      FFAppState().userLocation = currentUserLocationValue;
      safeSetState(() {});
      FFAppState().installID = random_data.randomString(
        8,
        8,
        true,
        true,
        true,
      );
      safeSetState(() {});
      FFAppState().obsDateRef = DateTime.now().subtract(Duration(days: 90));
      safeSetState(() {});
      _model.nearestObservationText = await actions.findNearestObservation(
        context,
        FFAppState().userLocation,
      );
    });

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      await queryLocustObservationsRecordOnce();
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<LocustObservationsRecord>>(
      stream: FFAppState().homePageLoad(
        requestFn: () => queryLocustObservationsRecord(
          queryBuilder: (locustObservationsRecord) =>
              locustObservationsRecord.where(
            'obsDate',
            isGreaterThanOrEqualTo: FFAppState().obsDateRef,
          ),
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xFFFFFDEA),
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<LocustObservationsRecord> homePageLocustObservationsRecordList =
            snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFFFFFDEA),
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 30.0),
                    child: Text(
                      'Today\'s Forecast',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Sora',
                            color: Colors.black,
                            fontSize: 25.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 135.0,
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 10.0, 0.0),
                              child: wrapWithModel(
                                model: _model.card15DashboardModel,
                                updateCallback: () => safeSetState(() {}),
                                child: Card15DashboardWidget(),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.33, 0.23),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 20.0, 20.0, 20.0),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.825,
                                height: MediaQuery.sizeOf(context).height * 0.4,
                                child: custom_widgets.FirestoreMap(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.825,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.4,
                                  defaultZoom: 3.0,
                                  showLocation: true,
                                  showCompass: false,
                                  showMapToolbar: false,
                                  showTraffic: false,
                                  allowZoom: true,
                                  showZoomControls: false,
                                  observations:
                                      homePageLocustObservationsRecordList,
                                  centerCoordinates: FFAppState().userLocation,
                                  onClickMarker: () async {},
                                ),
                              ).animateOnPageLoad(animationsMap[
                                  'containerOnPageLoadAnimation']!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
