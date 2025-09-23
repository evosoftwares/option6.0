import '/flutter_flow/flutter_flow_util.dart';
import '/backend/supabase/supabase.dart';
import '/backend/supabase/database/database.dart';
import '/index.dart';
import 'menu_motorista_widget.dart' show MenuMotoristaWidget;
import 'package:flutter/material.dart';

class MenuMotoristaModel extends FlutterFlowModel<MenuMotoristaWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Container widget.
  List<DriversRow>? rowDriver;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
