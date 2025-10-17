import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'about_u_s_model.dart';
export 'about_u_s_model.dart';

class AboutUSWidget extends StatefulWidget {
  const AboutUSWidget({super.key});

  static String routeName = 'AboutUS';
  static String routePath = '/aboutUS';

  @override
  State<AboutUSWidget> createState() => _AboutUSWidgetState();
}

class _AboutUSWidgetState extends State<AboutUSWidget> {
  late AboutUSModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AboutUSModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  buttonSize: 53.4,
                  fillColor: Color(0xFFFFFDEA),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF040404),
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.safePop();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                child: Text(
                  'FieldFriend helps farmers, agronomists, and field teams see and share locust activity quickly. Open the app to view recent observations on an interactive map and a browsable Reports list, then tap any item for details and navigation. A simple risk panel summarizes what matters now so you can decide when to scout, protect, or move resources.\nThis app has been accomplished thanks to the valuable data provided through the Food and Agriculture Organization (FAO)’s Locust-hub (https://locust-hub-hqfao.hub.arcgis.com/). This\ndata is the appreciated result of field surveys and control operations on desert locust conducted by the FAO member countries. We wish to express our gratitude to FAO, its three Desert Locust Regional Commissions (CLCPRO, CRC and SWAC) and the member countries\nfor the shared data.\n\nQuestions or ideas? We’d love to hear from you. Email FieldFriendApp@gmail.com. If you encounter inaccurate or inappropriate content, use the in-app Report option so we can review it promptly.',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Sora',
                        color: Colors.black,
                        fontSize: 13.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
