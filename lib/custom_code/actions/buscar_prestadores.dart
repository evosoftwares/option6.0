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

Future<List<String>> buscarPrestadores(
  String tituloCategoriaDesejada,
  String cidadeDesejada,
  String uidSolicitante,
) async {
  final firestore = FirebaseFirestore.instance;

  final categoriaSnapshot = await firestore
      .collection('categoria')
      .where('titulo', isEqualTo: tituloCategoriaDesejada)
      .limit(1)
      .get();

  if (categoriaSnapshot.docs.isEmpty) {
    return [];
  }

  final DocumentReference categoriaRef = categoriaSnapshot.docs.first.reference;

  final prestadoresQuerySnapshot = await firestore
      .collection('perfisPrestador')
      .where('categorias', arrayContains: categoriaRef)
      .where('online', isEqualTo: true)
      .get();

  List<String> uidsEncontrados = [];
  for (var doc in prestadoresQuerySnapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;

    if (data['areasCidades'] is List &&
        data['idUsuario'] is DocumentReference) {
      final List<String> cidadesDoPrestador = List.from(data['areasCidades']);
      final String uidPrestador = data['idUsuario'].id;

      if (cidadesDoPrestador.contains(cidadeDesejada)) {
        if (uidSolicitante == null || uidSolicitante != uidPrestador) {
          uidsEncontrados.add(uidPrestador);
        }
      }
    }
  }

  return uidsEncontrados;
}
