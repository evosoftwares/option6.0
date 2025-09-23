import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'cadastrar_widget.dart' show CadastrarWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastrarModel extends FlutterFlowModel<CadastrarWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    print('VALIDANDO CAMPO NOME: "$val"');
    if (val == null || val.isEmpty) {
      print('ERRO: Nome vazio ou null');
      return 'Nome completo é obrigatório';
    }
    print('✓ Nome válido');
    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    print('VALIDANDO CAMPO EMAIL: "$val"');
    if (val == null || val.isEmpty) {
      print('ERRO: Email vazio ou null');
      return 'E-mail é obrigatório';
    }

    // Validação básica de email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    final emailTrimmed = val.trim();
    print('Email trimmed: "$emailTrimmed"');
    print('Regex match: ${emailRegex.hasMatch(emailTrimmed)}');
    if (!emailRegex.hasMatch(emailTrimmed)) {
      print('ERRO: Email não passou na validação regex');
      return 'Digite um e-mail válido';
    }

    print('✓ Email válido');
    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  late MaskTextInputFormatter textFieldMask3;
  String? Function(BuildContext, String?)? textController3Validator;
  String? _textController3Validator(BuildContext context, String? val) {
    print('VALIDANDO CAMPO TELEFONE: "$val"');
    if (val == null || val.isEmpty) {
      print('ERRO: Telefone vazio ou null');
      return 'Telefone é obrigatório';
    }
    print('✓ Telefone preenchido: "$val"');
    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  late bool passwordVisibility1;
  String? Function(BuildContext, String?)? textController4Validator;
  String? _textController4Validator(BuildContext context, String? val) {
    print('VALIDANDO CAMPO SENHA: [${val?.length ?? 0} caracteres]');
    if (val == null || val.isEmpty) {
      print('ERRO: Senha vazia ou null');
      return 'Senha é obrigatória';
    }

    if (val.length < 6) {
      print('ERRO: Senha muito curta - ${val.length} caracteres');
      return 'Senha deve ter pelo menos 6 caracteres';
    }

    print('✓ Senha válida - ${val.length} caracteres');
    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5;
  late bool passwordVisibility2;
  String? Function(BuildContext, String?)? textController5Validator;
  String? _textController5Validator(BuildContext context, String? val) {
    print('VALIDANDO CAMPO CONFIRMAR SENHA: [${val?.length ?? 0} caracteres]');
    if (val == null || val.isEmpty) {
      print('ERRO: Confirmar senha vazia ou null');
      return 'Confirmar Senha é obrigatória';
    }
    print('✓ Confirmar senha preenchida - ${val.length} caracteres');
    return null;
  }

  @override
  void initState(BuildContext context) {
    print('=== INICIALIZANDO CadastrarModel ===');
    print('Configurando validadores dos campos...');
    textController1Validator = _textController1Validator;
    textController2Validator = _textController2Validator;
    textController3Validator = _textController3Validator;
    passwordVisibility1 = false;
    textController4Validator = _textController4Validator;
    passwordVisibility2 = false;
    textController5Validator = _textController5Validator;
    print('✓ CadastrarModel inicializado com sucesso');
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();

    textFieldFocusNode5?.dispose();
    textController5?.dispose();
  }
}
