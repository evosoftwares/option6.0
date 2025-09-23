import '/flutter_flow/flutter_flow_util.dart';
import 'avaliar_motorista_widget.dart' show AvaliarMotoristaWidget;
import 'package:flutter/material.dart';

class AvaliarMotoristaModel extends FlutterFlowModel<AvaliarMotoristaWidget> {
  ///  State fields for stateful widgets in this page.

  // Rating atual selecionado (1-5 estrelas)
  int rating = 0;

  // Tags selecionadas para a avaliação
  List<String> tagsSelecionadas = [];

  // State field(s) for comentario widget.
  FocusNode? comentarioFocusNode;
  TextEditingController? comentarioTextController;
  String? Function(BuildContext, String?)? comentarioTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    comentarioFocusNode?.dispose();
    comentarioTextController?.dispose();
  }
}