import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'card15_dashboard_model.dart';
export 'card15_dashboard_model.dart';

class Card15DashboardWidget extends StatefulWidget {
  const Card15DashboardWidget({super.key});

  @override
  State<Card15DashboardWidget> createState() => _Card15DashboardWidgetState();
}

class _Card15DashboardWidgetState extends State<Card15DashboardWidget>
    with TickerProviderStateMixin {
  late Card15DashboardModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Card15DashboardModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 50.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(40.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'progressBarOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(-50.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.7, 0.7),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: StreamBuilder<List<LocustObservationsRecord>>(
        stream: FFAppState().riskWijLoad(
          requestFn: () => queryLocustObservationsRecord(),
        ),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            );
          }
          List<LocustObservationsRecord>
              dashboardMainCardLocustObservationsRecordList = snapshot.data!;

          return Container(
            width: double.infinity,
            height: 200.0,
            decoration: BoxDecoration(
              color: Color(0xFFFFFDEA),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  color: Color(0x33000000),
                  offset: Offset(
                    0.0,
                    2.0,
                  ),
                )
              ],
              borderRadius: BorderRadius.circular(12.0),
            ),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-0.5, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 15.0),
                              child: Text(
                                'Your Risk',
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      fontFamily: 'Sora',
                                      color: () {
                                        if (functions.calculateLocustRisk(
                                                dashboardMainCardLocustObservationsRecordList
                                                    .toList(),
                                                FFAppState().userLocation) <=
                                            0.3) {
                                          return Color(0xFF388E3C);
                                        } else if ((functions.calculateLocustRisk(
                                                    dashboardMainCardLocustObservationsRecordList
                                                        .toList(),
                                                    FFAppState().userLocation) >
                                                0.3) &&
                                            (functions.calculateLocustRisk(
                                                    dashboardMainCardLocustObservationsRecordList
                                                        .toList(),
                                                    FFAppState().userLocation) <
                                                0.6)) {
                                          return Color(0xFFF57C00);
                                        } else {
                                          return Color(0xFF388E3C);
                                        }
                                      }(),
                                      fontSize: 24.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(RiskAppPageWidget.routeName);
                            },
                            text: 'Why this risk?',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: () {
                                if (functions.calculateLocustRisk(
                                        dashboardMainCardLocustObservationsRecordList
                                            .toList(),
                                        FFAppState().userLocation) <=
                                    0.3) {
                                  return Color(0xFF388E3C);
                                } else if ((functions.calculateLocustRisk(
                                            dashboardMainCardLocustObservationsRecordList
                                                .toList(),
                                            FFAppState().userLocation) >
                                        0.3) &&
                                    (functions.calculateLocustRisk(
                                            dashboardMainCardLocustObservationsRecordList
                                                .toList(),
                                            FFAppState().userLocation) <
                                        0.6)) {
                                  return Color(0xFFF57C00);
                                } else {
                                  return Color(0xFFD32F2F);
                                }
                              }(),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Sora',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ],
                      ).animateOnPageLoad(
                          animationsMap['columnOnPageLoadAnimation']!),
                    ),
                  ),
                  CircularPercentIndicator(
                    percent: functions.calculateLocustRisk(
                        dashboardMainCardLocustObservationsRecordList.toList(),
                        FFAppState().userLocation),
                    radius: 45.0,
                    lineWidth: 8.0,
                    animation: true,
                    animateFromLastPercent: true,
                    progressColor: Color(0xFF151414),
                    backgroundColor: Color(0xFFF0E9E9),
                    center: Text(
                      functions.getLocustRiskPercentage(
                          dashboardMainCardLocustObservationsRecordList
                              .toList(),
                          FFAppState().userLocation)!,
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Sora',
                                color: () {
                                  if (functions.calculateLocustRisk(
                                          dashboardMainCardLocustObservationsRecordList
                                              .toList(),
                                          FFAppState().userLocation) <
                                      0.3) {
                                    return Color(0xFF388E3C);
                                  } else if ((functions.calculateLocustRisk(
                                              dashboardMainCardLocustObservationsRecordList
                                                  .toList(),
                                              FFAppState().userLocation) >
                                          0.3) &&
                                      (functions.calculateLocustRisk(
                                              dashboardMainCardLocustObservationsRecordList
                                                  .toList(),
                                              FFAppState().userLocation) >
                                          0.6)) {
                                    return Color(0xFFF57C00);
                                  } else {
                                    return Color(0xFFD32F2F);
                                  }
                                }(),
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    startAngle: 1.0,
                  ).animateOnPageLoad(
                      animationsMap['progressBarOnPageLoadAnimation']!),
                ],
              ),
            ),
          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
        },
      ),
    );
  }
}
