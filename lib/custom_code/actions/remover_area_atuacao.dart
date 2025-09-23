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

Future<List<AreaAtuacaoStruct>> removerAreaAtuacao(
  String cidadeParaRemover,
  List<AreaAtuacaoStruct> listaOriginal,
) async {
  // Retorna uma lista vazia se a lista de entrada for nula ou vazia.
  if (listaOriginal == null || listaOriginal.isEmpty) {
    return [];
  }

  // Cria uma cópia da lista para poder modificá-la.
  List<AreaAtuacaoStruct> novaLista = List.from(listaOriginal);

  novaLista.removeWhere((item) => item.areaAtuacaoCidade == cidadeParaRemover);

  // Retorna a nova lista já sem o item removido.
  return novaLista;
}
