import '/components/card15_dashboard_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - findNearestObservation] action in homePage widget.
  String? nearestObservationText;
  // Model for Card15Dashboard component.
  late Card15DashboardModel card15DashboardModel;

  @override
  void initState(BuildContext context) {
    card15DashboardModel = createModel(context, () => Card15DashboardModel());
  }

  @override
  void dispose() {
    card15DashboardModel.dispose();
  }
}
