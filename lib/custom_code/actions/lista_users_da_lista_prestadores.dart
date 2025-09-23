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

Future<List<DocumentReference>> listaUsersDaListaPrestadores(
  List<String> listaPrestadores,
) async {
  final List<DocumentReference> referenciasUsuarios = [];

  print('Iniciando com lista de IDs de usuários: $listaPrestadores');

  for (final idPrestador in listaPrestadores) {
    try {
      final referenciaUsuario =
          FirebaseFirestore.instance.collection('users').doc(idPrestador);

      final perfisPrestadorQuery = await FirebaseFirestore.instance
          .collection('perfisPrestador')
          .where('idUsuario', isEqualTo: referenciaUsuario)
          .limit(1)
          .get();

      if (perfisPrestadorQuery.docs.isNotEmpty) {
        referenciasUsuarios.add(referenciaUsuario);
        print('Referência de usuário encontrada para $idPrestador.');
      } else {
        print(
            'AVISO: Nenhum perfil de prestador encontrado para o usuário $idPrestador.');
      }
    } catch (erro) {
      print(
          'Erro ao buscar o perfil do prestador para o usuário $idPrestador: $erro');
    }
  }

  print(
      'Finalizando, lista de referências de usuários encontrada tem ${referenciasUsuarios.length} itens.');
  return referenciasUsuarios;
}
