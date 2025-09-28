// DEPRECATED: Legacy Firebase product brands system
// This file has been commented out during Firebase to Supabase migration
// Replaced by Supabase-based product and brand management system

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

Future<List<String>> getMarcasFromProdutos(
  List<dynamic> produtos,
) async {
  // DEPRECATED: Return empty list for legacy function
  return [];
}
import 'dart:async';

Future<List<DocumentReference>> getMarcasFromProdutos(
  List<String> listaIdProdutos,
) async {
  // Sai cedo se a lista de entrada for vazia.
  if (listaIdProdutos == null || listaIdProdutos.isEmpty) {
    return [];
  }

  final firestore = FirebaseFirestore.instance;

  final List<List<String>> chunksDeProdutos = [];
  for (var i = 0; i < listaIdProdutos.length; i += 30) {
    chunksDeProdutos.add(listaIdProdutos.sublist(
        i, i + 30 > listaIdProdutos.length ? listaIdProdutos.length : i + 30));
  }

  // Busca os lotes de produtos em paralelo para mais performance.
  final List<QuerySnapshot<Map<String, dynamic>>> snapshotsDeProdutos =
      await Future.wait(
    chunksDeProdutos.map((chunk) {
      return firestore
          .collection('produto')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
    }),
  );

  // Junta os resultados de todas as buscas em uma lista única.
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docsDeProdutos =
      snapshotsDeProdutos.expand((snapshot) => snapshot.docs).toList();

  if (docsDeProdutos.isEmpty) {
    return [];
  }

  // Pega os IDs das marcas (o 'Set' garante que não haverá repetidos).
  final Set<String> idsDasMarcasUnicas = {};
  for (var doc in docsDeProdutos) {
    final data = doc.data();
    if (data.containsKey('pertenceMarca')) {
      final idMarca = data['pertenceMarca'] as String?;
      if (idMarca != null && idMarca.isNotEmpty) {
        idsDasMarcasUnicas.add(idMarca);
      }
    }
  }

  if (idsDasMarcasUnicas.isEmpty) {
    return [];
  }

  // Repete o processo de quebra para a lista de marcas.
  final List<String> listaDeMarcas = idsDasMarcasUnicas.toList();
  final List<List<String>> chunksDeMarcas = [];
  for (var i = 0; i < listaDeMarcas.length; i += 30) {
    chunksDeMarcas.add(listaDeMarcas.sublist(
        i, i + 30 > listaDeMarcas.length ? listaDeMarcas.length : i + 30));
  }

  // Busca os lotes de marcas em paralelo.
  final List<QuerySnapshot<Map<String, dynamic>>> snapshotsDeMarcas =
      await Future.wait(
    chunksDeMarcas.map((chunk) {
      return firestore
          .collection('marca')
          .where('idMarca', whereIn: chunk)
          .get();
    }),
  );

  // Mapeia os documentos encontrados para DocumentReference e retorna.
  final List<DocumentReference> referenciasDasMarcas = snapshotsDeMarcas
      .expand((snapshot) => snapshot.docs)
      .map((doc) => doc.reference)
      .toList();

  return referenciasDasMarcas;
}
*/

// Placeholder function to maintain compatibility
Future<List<String>> getMarcasFromProdutos(
  List<String> listaIdProdutos,
) async {
  // This function has been deprecated and replaced by Supabase-based product and brand management
  print('getMarcasFromProdutos: Function deprecated - migrated to Supabase');
  return [];
}
