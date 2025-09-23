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

Future<void> criarMissoesPrestadores(
  DocumentReference requerimentoRef,
  List<String> listaPrestadores,
) async {
  try {
    final requerimentoDoc = await requerimentoRef.get();

    if (!requerimentoDoc.exists) {
      print('Requerimento com ID ${requerimentoRef.id} não encontrado.');
      return;
    }

    final Map<String, dynamic> requerimentoData =
        requerimentoDoc.data() as Map<String, dynamic>;
    if (requerimentoData == null) {
      print('Dados do requerimento estão vazios.');
      return;
    }

    for (final idPrestador in listaPrestadores) {
      final DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(idPrestador);

      final novaMissao = <String, dynamic>{
        'tipo': 'publica',
        'idParceiroAtribuido': userRef,
        'idRequerimento': requerimentoRef,
        'descricao': requerimentoData['descricao'],
        'temCheckList': requerimentoData['temCheckList'],
        'tituloCheckList': requerimentoData['tituloCheckList'],
        'itensCheckList': requerimentoData['itensCheckList'],
        'enderecoCompleto': requerimentoData['enderecoCompleto'],
        'enderecoGeoPoint': requerimentoData['enderecoGeoPoint'],
        'valorPagamento': requerimentoData['valorPagamento'],
        'status': requerimentoData['status'],
        'criadoPor': requerimentoData['criadoPor'],
        'criadoEm': requerimentoData['criadoEm'],
        'dataInicio': requerimentoData['dataInicio'],
      };

      await FirebaseFirestore.instance.collection('missoes').add(novaMissao);
    }

    await requerimentoRef.update({
      'idRequerimento': requerimentoRef,
    });

    print(
        'Missões criadas com sucesso para ${listaPrestadores.length} prestadores.');
  } catch (e) {
    print('Erro ao criar missões: $e');
  }
}
//Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
