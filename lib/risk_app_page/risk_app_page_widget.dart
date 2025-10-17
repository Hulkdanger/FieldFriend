import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'risk_app_page_model.dart';
export 'risk_app_page_model.dart';

/// Create a page with four progress bar on the right side with text labels on
/// for each progress bar.
///
/// Labels should be on the left. I like this page, but make sure the progress
/// bars are actual progress bars that can be binded to a dynamic value
class RiskAppPageWidget extends StatefulWidget {
  const RiskAppPageWidget({super.key});

  static String routeName = 'RiskAppPage';
  static String routePath = '/riskAppPage';

  @override
  State<RiskAppPageWidget> createState() => _RiskAppPageWidgetState();
}

class _RiskAppPageWidgetState extends State<RiskAppPageWidget> {
  late RiskAppPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RiskAppPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
              Align(
                alignment: AlignmentDirectional(-1.0, 0.0),
                child: FlutterFlowIconButton(
                  borderRadius: 8.0,
                  buttonSize: 50.0,
                  fillColor: Color(0xFFFFFDEA),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.safePop();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                      child: Text(
                        'Your Risk Breakdown',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: 'Sora',
                              color: Colors.black,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Maturity',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Sora',
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            LinearPercentIndicator(
                              percent: FFAppState().MaturityScore,
                              width: 170.0,
                              lineHeight: 8.0,
                              animation: true,
                              animateFromLastPercent: true,
                              progressColor:
                                  FlutterFlowTheme.of(context).primary,
                              backgroundColor: Color(0xFFCBCED1),
                              padding: EdgeInsets.zero,
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Behaviour',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Sora',
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            LinearPercentIndicator(
                              percent: FFAppState().BehaviourScore,
                              width: 170.0,
                              lineHeight: 8.0,
                              animation: true,
                              animateFromLastPercent: true,
                              progressColor:
                                  FlutterFlowTheme.of(context).secondary,
                              backgroundColor: Color(0xFFCBCED1),
                              padding: EdgeInsets.zero,
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Breeding Status',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Sora',
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            LinearPercentIndicator(
                              percent: FFAppState().BreedingScore,
                              width: 170.0,
                              lineHeight: 8.0,
                              animation: true,
                              animateFromLastPercent: true,
                              progressColor:
                                  FlutterFlowTheme.of(context).tertiary,
                              backgroundColor: Color(0xFFCBCED1),
                              padding: EdgeInsets.zero,
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Distance',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Sora',
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            LinearPercentIndicator(
                              percent: valueOrDefault<double>(
                                FFAppState().DistanceScore,
                                0.1,
                              ),
                              width: 170.0,
                              lineHeight: 8.0,
                              animation: true,
                              animateFromLastPercent: true,
                              progressColor:
                                  FlutterFlowTheme.of(context).success,
                              backgroundColor: Color(0xFFCBCED1),
                              padding: EdgeInsets.zero,
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                      ].divide(SizedBox(height: 24.0)),
                    ),
                  ].divide(SizedBox(height: 32.0)),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Time of Year',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Sora',
                              color: Colors.black,
                              fontSize: 13.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 25.0, 0.0),
                    child: LinearPercentIndicator(
                      percent: 0.3,
                      width: 170.0,
                      lineHeight: 8.0,
                      animation: true,
                      animateFromLastPercent: true,
                      progressColor: FlutterFlowTheme.of(context).tertiary,
                      backgroundColor: Color(0xFFCBCED1),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ].divide(SizedBox(width: 16.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
