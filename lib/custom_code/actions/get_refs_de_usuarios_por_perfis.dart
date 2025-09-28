// DEPRECATED: Legacy Firebase user reference system
// This file has been commented out during Firebase to Supabase migration
// Replaced by Supabase-based user management system

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

Future<List<DocumentReference>> getRefsDeUsuariosPorPerfis(
  // A lista de referências de documentos da coleção 'perfisMotorista'.
  List<DocumentReference>? listaPerfisMotorista,
) async {
  // Se a lista de entrada for nula ou vazia, retorna uma lista vazia imediatamente.
  if (listaPerfisMotorista == null || listaPerfisMotorista.isEmpty) {
    return [];
  }

  final List<DocumentReference> listaUserRefs = [];
  final firestore = FirebaseFirestore.instance;

  // Usa um Future.wait para buscar todos os documentos da lista em paralelo,
  // o que é mais eficiente do que um loop 'for' com 'await' dentro.
  try {
    final List<DocumentSnapshot> perfisDocs =
        await Future.wait(listaPerfisMotorista.map((ref) => ref.get()));

    for (var doc in perfisDocs) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        // Verifica se o campo 'idUsuario' existe e não é nulo.
        if (data.containsKey('idUsuario') && data['idUsuario'] != null) {
          // Adiciona a referência do usuário à lista de resultados.
          listaUserRefs.add(data['idUsuario'] as DocumentReference);
        }
      }
    }
  } catch (e) {
    // Em caso de erro na busca, imprime no console e retorna a lista vazia.
    print('Erro ao buscar perfis de motorista: $e');
    return [];
  }

  return listaUserRefs;
}
*/

// Placeholder function to maintain compatibility
Future<List<String>> getRefsDeUsuariosPorPerfis(
  List<String>? listaPerfisMotorista,
) async {
  // This function has been deprecated and replaced by Supabase-based user management
  return [];
}
