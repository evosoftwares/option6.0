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

Future<List<ChecklistItemStructStruct>> atualizarItemDaLista(
  List<ChecklistItemStructStruct> listaCompleta,
  int indiceDoItem,
  bool novoStatus,
  RequerimentoRecord requerimento,
) async {
  // Cria uma cópia modificável da lista.
  List<ChecklistItemStructStruct> novaLista = List.from(listaCompleta);

  // Verifica se o índice é válido.
  if (indiceDoItem >= 0 && indiceDoItem < novaLista.length) {
    // Pega o item a ser atualizado.
    ChecklistItemStructStruct itemAntigo = novaLista[indiceDoItem];

    ChecklistItemStructStruct itemAtualizado = ChecklistItemStructStruct(
      textoItem: itemAntigo.textoItem, // Mantém o texto original
      concluido: novoStatus, // Usa o novo status (true ou false)
    );

    // Substitui o item antigo pelo novo na lista.
    novaLista[indiceDoItem] = itemAtualizado;

    final checkListData = requerimento.numerosCheckList;
    int total = checkListData.total;
    int totalFeito = checkListData.totalFeito;

    if (novoStatus == true) {
      totalFeito += 1;
    } else {
      totalFeito -= 1;
    }

    if (total > 0) {
      totalFeito = totalFeito.clamp(0, total).toInt();
    } else {
      totalFeito = 0;
    }

    double novaPorcentagem = 0.0;
    if (total > 0) {
      novaPorcentagem = (totalFeito / total) * 100;
    }

    final Map<String, dynamic> dadosParaAtualizar = {
      'numerosCheckList': {
        'total': total,
        'totalFeito': totalFeito,
        'porcentagemFeita': novaPorcentagem,
      }
    };

    await requerimento.reference.update(dadosParaAtualizar);
  }

  // Retorna a lista completa com o item modificado.
  return novaLista;

  // Add your function code here!
}
