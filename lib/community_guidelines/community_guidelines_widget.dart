import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'community_guidelines_model.dart';
export 'community_guidelines_model.dart';

class CommunityGuidelinesWidget extends StatefulWidget {
  const CommunityGuidelinesWidget({super.key});

  static String routeName = 'CommunityGuidelines';
  static String routePath = '/communityGuidelines';

  @override
  State<CommunityGuidelinesWidget> createState() =>
      _CommunityGuidelinesWidgetState();
}

class _CommunityGuidelinesWidgetState extends State<CommunityGuidelinesWidget> {
  late CommunityGuidelinesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityGuidelinesModel());

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
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Text(
                  'FieldFriend is for sharing clear, helpful locust sightings so everyone can act faster. Keep posts accurate and on-topic: choose the right categories (date, maturity, behavior, breeding), pick the correct location, and skip guesses or rumors. Be respectful—no harassment, spam, or off-topic promos—and don’t include personal info about yourself or others. If you see something wrong or inappropriate, tap Report on the post; you can also Block user from their post menu to hide their future stuff on your device.\n\nTo keep things useful and safe, we lightly moderate community posts before they appear and may limit or remove content that’s inaccurate or abusive. Sightings are tied to a pseudonymous installation ID (not your real name), and we may restrict IDs that break the rules. Remember: the risk score is a helper, not a guarantee—always ground-truth conditions and follow local guidance. Questions or concerns? Email FieldFriendApp@gmail.com\n and we’ll help.',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Sora',
                        color: Color(0xFF111111),
                        fontSize: 13.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
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
