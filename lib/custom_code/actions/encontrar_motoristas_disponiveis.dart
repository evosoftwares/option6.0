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

Future<List<DocumentReference>?> encontrarMotoristasDisponiveis(
  LatLng userGeo,
  DocumentReference categoriaRef,
  double maxDistanceKM,
) async {
  final firestore = FirebaseFirestore.instance;
  final supabase = SupaFlow.client;

  // --- ETAPA 1: BUSCAR TODOS OS MOTORISTAS ELEGÍVEIS
  final Map<String, DocumentReference> mapaMotoristas = {};

  try {
    final querySnapshot = await firestore
        .collection('perfisMotorista')
        .where('statusAtual', isEqualTo: true)
        .where('categoriasVeiculoAtual', arrayContains: categoriaRef)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print('Nenhum motorista elegível encontrado no Firestore.');
      return [];
    }

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      if (data.containsKey('idUsuario') && data['idUsuario'] != null) {
        // Primeiro, tratamos o campo como a referência que ele é.
        final userRef = data['idUsuario'] as DocumentReference;
        // Depois, extraímos o ID (que é uma String) da referência.
        final userId = userRef.id;
        mapaMotoristas[userId] = doc.reference;
      }
    }
  } catch (e) {
    print('ERRO_FIRESTORE_QUERY: Falha ao buscar motoristas elegíveis: $e');
    return [];
  }

  if (mapaMotoristas.isEmpty) {
    return [];
  }

  // ETAPA 2: BUSCA PROGRESSIVA NO SUPABASE
  try {
    double currentRadiusKM = maxDistanceKM;
    const double maxRadiusKM = 10.0; // O limite máximo de busca.
    const double radiusIncrementKM =
        3.0; // O valor a ser somado a cada tentativa.
    final List<String> motoristasElegiveisIds = mapaMotoristas.keys.toList();

    // Loop que continua enquanto o raio atual não ultrapassar o limite máximo.
    while (currentRadiusKM <= maxRadiusKM) {
      print('Buscando motoristas em um raio de ${currentRadiusKM}km...');

      final double maxDistanceMeters = currentRadiusKM * 1000;

      final List<dynamic> motoristasProximosData = await supabase.rpc(
        'buscar_motoristas_proximos_otimizado',
        params: {
          'lat_passageiro': userGeo.latitude,
          'lon_passageiro': userGeo.longitude,
          'raio_em_metros': maxDistanceMeters,
          'ids_dos_motoristas': motoristasElegiveisIds,
        },
      );

      // Se encontrou motoristas, reconstrói a lista e a retorna, saindo da função.
      if (motoristasProximosData.isNotEmpty) {
        print('${motoristasProximosData.length} motorista(s) encontrado(s)!');
        final List<DocumentReference> motoristasOrdenadosRefs =
            motoristasProximosData
                .map((motorista) =>
                    mapaMotoristas[motorista['user_id'] as String])
                .whereType<DocumentReference>()
                .toList();
        return motoristasOrdenadosRefs;
      }

      // Se não encontrou, aumenta o raio e o loop tentará novamente.
      print('Nenhum motorista encontrado. Aumentando o raio de busca...');
      currentRadiusKM += radiusIncrementKM;
    }

    // Se o loop terminar sem encontrar ninguém, retorna uma lista vazia.
    print(
        'Nenhum motorista encontrado dentro do raio máximo de ${maxRadiusKM}km.');
    return [];
  } catch (e) {
    print(
        'ERRO_SUPABASE_RPC: Falha ao chamar a função de busca no Supabase: $e');
    return [];
  }
}
