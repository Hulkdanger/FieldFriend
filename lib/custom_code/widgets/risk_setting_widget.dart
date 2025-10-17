// Automatic FlutterFlow imports
import '/backend/backend.dart';
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;
import '/actions/actions.dart' as action_blocks;
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class RiskSettingWidget extends StatefulWidget {
  const RiskSettingWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _RiskSettingWidgetState createState() => _RiskSettingWidgetState();
}

class _RiskSettingWidgetState extends State<RiskSettingWidget> {
  String? _currentRiskPreset;

  @override
  void initState() {
    super.initState();
    // Get the current app state value
    _currentRiskPreset = FFAppState().riskPreset;
  }

  void _updateRiskPreset(String preset) {
    setState(() {
      _currentRiskPreset = preset;
    });
    // Update the app state
    FFAppState().update(() {
      FFAppState().riskPreset = preset;
    });
  }

  Widget _buildRiskOption(String label, String value) {
    bool isSelected = _currentRiskPreset == value;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE67E50),
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Switch(
              value: isSelected,
              onChanged: (bool value) {
                if (value) {
                  _updateRiskPreset(
                      value ? value.toString().toLowerCase() : '');
                }
              },
              activeColor: Color(0xFFE67E50),
              activeTrackColor: Color(0xFFE8B4A0),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Color(0xFFE0E0E0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Color(0xFFF5EFE7),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Risk Settings',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 12.0, top: 4.0, bottom: 4.0),
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Color(0xFFE67E50),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0),
                ),
              ),
              child: Text(
                'Row',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          _buildRiskOption('Conservative', 'conservative'),
          _buildRiskOption('Standard', 'standard'),
          _buildRiskOption('Aggressive', 'aggressive'),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
