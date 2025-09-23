import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'a_caminho_do_passageiro_widget.dart' show ACaminhoDoPassageiroWidget;
import 'package:flutter/material.dart';

class ACaminhoDoPassageiroModel
    extends FlutterFlowModel<ACaminhoDoPassageiroWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
