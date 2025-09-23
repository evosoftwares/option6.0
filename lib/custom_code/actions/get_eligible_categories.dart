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

import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<DocumentReference>> getEligibleCategories(
  int anoVeiculo,
  String tipoVeiculo,
  bool veiculoTemAr,
  bool veiculoTem4Portas,
  bool veiculoTemCouro,
) async {
  List<DocumentReference> categoriasElegiveis = [];

  final snapshotCategorias = await FirebaseFirestore.instance
      .collection('categoriasMobilidade')
      .where('statusAtivo', isEqualTo: true)
      .get();

  for (var docCategoria in snapshotCategorias.docs) {
    final dadosCategoria = docCategoria.data();
    bool ehElegivel = true;

    // Verifica o ano mínimo da categoria
    if (dadosCategoria.containsKey('anoMinimoCategoria') &&
        anoVeiculo < dadosCategoria['anoMinimoCategoria']) {
      ehElegivel = false;
    }

    // Verifica se o tipo de veículo está na lista de permitidos
    if (ehElegivel &&
        dadosCategoria.containsKey('tiposPermitidos') &&
        (dadosCategoria['tiposPermitidos'] as List).isNotEmpty) {
      List<String> tiposPermitidos =
          List<String>.from(dadosCategoria['tiposPermitidos']);
      if (!tiposPermitidos.contains(tipoVeiculo)) {
        ehElegivel = false;
      }
    }

    // Verifica a exigência de ar condicionado
    if (ehElegivel &&
        dadosCategoria.containsKey('arCondicionado') &&
        dadosCategoria['arCondicionado'] == true &&
        !veiculoTemAr) {
      ehElegivel = false;
    }

    // Verifica a exigência de 4 portas
    if (ehElegivel &&
        dadosCategoria.containsKey('tem4Portas') &&
        dadosCategoria['tem4Portas'] == true &&
        !veiculoTem4Portas) {
      ehElegivel = false;
    }

    // Verifica a exigência de bancos de couro
    if (ehElegivel &&
        dadosCategoria.containsKey('bancosDeCouro') &&
        dadosCategoria['bancosDeCouro'] == true &&
        !veiculoTemCouro) {
      ehElegivel = false;
    }

    if (ehElegivel) {
      categoriasElegiveis.add(docCategoria.reference);
    }
  }

  return categoriasElegiveis;
}
