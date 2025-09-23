// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Imports adicionais podem ser necessários dependendo do seu ambiente completo.
// import '/backend/backend.dart'; // Já incluído acima
// import '/backend/schema/enums/enums.dart'; // Já incluído acima

Future<bool> validarCpf(String cpfInput) async {
  // Este cpf é válido? (A lógica atual é apenas para CPF)

  // Remove caracteres não numéricos
  String cpf = cpfInput.replaceAll(RegExp(r'\D'), '');

  // Verifica se o comprimento é válido (11 dígitos)
  if (cpf.length != 11) return false;

  // Verifica se todos os dígitos são iguais (ex: 111.111.111-11), o que é inválido
  if (RegExp(r'^(.)\1*$').hasMatch(cpf)) return false;

  // Validação do primeiro dígito verificador
  int sum = 0;
  int weight = 10;

  for (int i = 0; i < 9; i++) {
    sum += int.parse(cpf[i]) * weight--;
  }

  int firstDigit = (sum * 10) % 11;
  if (firstDigit == 10 || firstDigit == 11) firstDigit = 0;

  if (firstDigit != int.parse(cpf[9])) return false;

  // Validação do segundo dígito verificador
  sum = 0;
  weight = 11; // O peso começa em 11 para o segundo dígito

  for (int i = 0; i < 10; i++) {
    sum += int.parse(cpf[i]) * weight--;
  }

  int secondDigit = (sum * 10) % 11;
  if (secondDigit == 10 || secondDigit == 11) secondDigit = 0;

  // Retorna true se o segundo dígito calculado for igual ao dígito fornecido no CPF
  return secondDigit == int.parse(cpf[10]);
}
// DO NOT REMOVE OR MODIFY THE CODE BELOW!
// End custom action code
