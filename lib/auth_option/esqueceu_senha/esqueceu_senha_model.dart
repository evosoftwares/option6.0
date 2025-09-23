import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'esqueceu_senha_widget.dart' show EsqueceuSenhaWidget;
import 'package:flutter/material.dart';

class EsqueceuSenhaModel extends FlutterFlowModel<EsqueceuSenhaWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    emailTextController?.dispose();
  }
}
