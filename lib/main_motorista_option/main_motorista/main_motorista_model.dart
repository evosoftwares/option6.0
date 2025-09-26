import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/supabase/supabase.dart';
import '/index.dart';
import 'main_motorista_widget.dart' show MainMotoristaWidget;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_google_map.dart';

class MainMotoristaModel extends FlutterFlowModel<MainMotoristaWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in mainMotorista widget.
  List<AppUsersRow>? checkpassageiro;
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 60000;
  int timerMilliseconds = 60000;
  String timerValue = StopWatchTimer.getDisplayTime(
    60000,
    hours: false,
    minute: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  Stream<List<DriverWalletsRow>>? containerSupabaseStream;

  // Prevent double taps on online/offline toggle
  bool isTogglingOnline = false;

  // Google Map state
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // Markers to display on the map (e.g., trip origin/destination)
  List<FlutterFlowMarker> mapMarkers = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
  }
}
