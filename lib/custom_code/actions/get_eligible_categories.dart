// DEPRECATED: Legacy Firebase categories system
// This file has been commented out during Firebase to Supabase migration
// Replaced by Supabase-based vehicle categories management system

/*
// Automatic FlutterFlow imports
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

// DEPRECATED: Legacy Firebase function - replaced by Supabase implementation
import 'dart:convert';
import 'dart:math' as math;
// DEPRECATED: Removed cloud_firestore import for Supabase migration

Future<List<dynamic>> getEligibleCategories(
  LatLng userLocation,
  double maxDistance,
) async {
  // DEPRECATED: Return empty list for legacy function
  return [];
}

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
*/

// Placeholder function to maintain compatibility
Future<List<String>> getEligibleCategories(
  int anoVeiculo,
  String tipoVeiculo,
  bool veiculoTemAr,
  bool veiculoTem4Portas,
  bool veiculoTemCouro,
) async {
  // This function has been deprecated and replaced by Supabase-based vehicle categories management
  print('getEligibleCategories: Function deprecated - migrated to Supabase');
  return [];
}
