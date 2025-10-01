import '/backend/supabase/supabase.dart';
import 'package:flutter/material.dart';
import '../../utils/num_utils.dart';

/// Sistema Inteligente de Solicitação de Viagem
/// Substitui o sistema antigo Firebase por uma solução 100% Supabase
/// com matching inteligente e notificações em tempo real

/// Solicita uma viagem com algoritmo de matching inteligente
Future<Map<String, dynamic>> solicitarViagemInteligente({
  required String passengerId,
  required String originAddress,
  required double originLatitude,
  required double originLongitude,
  required String originNeighborhood,
  required String destinationAddress,
  required double destinationLatitude,
  required double destinationLongitude,
  required String destinationNeighborhood,
  required String vehicleCategory,
  bool needsPet = false,
  bool needsGrocerySpace = false,
  bool needsAc = false,
  bool isCondoOrigin = false,
  bool isCondoDestination = false,
  int numberOfStops = 0,
  double? estimatedDistanceKm,
  int? estimatedDurationMinutes,
  double? estimatedFare,
}) async {
  try {
    // 1. CRIAR SOLICITAÇÃO DE VIAGEM
    final tripRequestData = {
      'passenger_id': passengerId,
      'origin_address': originAddress,
      'origin_latitude': originLatitude,
      'origin_longitude': originLongitude,
      'origin_neighborhood': originNeighborhood,
      'destination_address': destinationAddress,
      'destination_latitude': destinationLatitude,
      'destination_longitude': destinationLongitude,
      'destination_neighborhood': destinationNeighborhood,
      'vehicle_category': vehicleCategory,
      'needs_pet': needsPet,
      'needs_grocery_space': needsGrocerySpace,
      'needs_ac': needsAc,
      'is_condo_origin': isCondoOrigin,
      'is_condo_destination': isCondoDestination,
      'number_of_stops': numberOfStops,
      'estimated_distance_km': estimatedDistanceKm,
      'estimated_duration_minutes': estimatedDurationMinutes,
      'estimated_fare': estimatedFare,
      'status': 'searching',
      'created_at': DateTime.now().toIso8601String(),
      'expires_at': DateTime.now().add(Duration(minutes: 10)).toIso8601String(),
    };

    final tripRequestResponse =
        await TripRequestsTable().insert(tripRequestData);
    final tripRequestId = tripRequestResponse.id;

    print('✅ Solicitação de viagem criada: $tripRequestId');

    // 2. BUSCAR MOTORISTAS COM ALGORITMO INTELIGENTE
    final motoristasInteligentes = await _buscarMotoristasInteligentes(
      originLatitude: originLatitude,
      originLongitude: originLongitude,
      vehicleCategory: vehicleCategory,
      needsPet: needsPet,
      needsGrocerySpace: needsGrocerySpace,
      needsAc: needsAc,
      isCondoOrigin: isCondoOrigin,
      isCondoDestination: isCondoDestination,
    );

    if (motoristasInteligentes.isEmpty) {
      // Atualizar status para "no_drivers"
      await TripRequestsTable().update(
        data: {'status': 'no_drivers'},
        matchingRows: (rows) => rows.eq('id', tripRequestId),
      );

      return {
        'sucesso': false,
        'erro': 'Nenhum motorista disponível na região',
        'trip_request_id': tripRequestId,
      };
    }

    // 3. DEFINIR ESTRATÉGIA DE FALLBACK INTELIGENTE
    final targetDriverId = motoristasInteligentes.first['driver_id'];
    final fallbackDrivers = motoristasInteligentes
        .skip(1)
        .take(4) // Máximo 4 fallbacks
        .map((m) => m['driver_id'] as String)
        .toList();

    // Atualizar solicitação com motoristas encontrados
    await TripRequestsTable().update(
      data: {
        'target_driver_id': targetDriverId,
        'fallback_drivers': fallbackDrivers,
        'current_fallback_index': 0,
        'timeout_count': 0,
      },
      matchingRows: (rows) => rows.eq('id', tripRequestId),
    );

    // 4. ENVIAR NOTIFICAÇÃO PARA O MOTORISTA PRINCIPAL
    await _enviarNotificacaoParaMotorista(
      driverId: targetDriverId,
      tripRequestId: tripRequestId,
      originAddress: originAddress,
      destinationAddress: destinationAddress,
      estimatedFare: estimatedFare ?? 0.0,
    );

    // 5. PROGRAMAR TIMEOUT E FALLBACK AUTOMÁTICO
    _programarTimeoutEFallback(tripRequestId, targetDriverId);

    return {
      'sucesso': true,
      'trip_request_id': tripRequestId,
      'motoristas_encontrados': motoristasInteligentes.length,
      'motorista_principal': targetDriverId,
      'fallbacks_disponiveis': fallbackDrivers.length,
      'tempo_limite': '30 segundos',
    };
  } catch (e) {
    print('❌ Erro ao solicitar viagem: $e');
    return {
      'sucesso': false,
      'erro': 'Erro interno: ${e.toString()}',
    };
  }
}

/// Algoritmo de busca inteligente com scoring multi-fatores
Future<List<Map<String, dynamic>>> _buscarMotoristasInteligentes({
  required double originLatitude,
  required double originLongitude,
  required String vehicleCategory,
  required bool needsPet,
  required bool needsGrocerySpace,
  required bool needsAc,
  required bool isCondoOrigin,
  required bool isCondoDestination,
}) async {
  try {
    // Buscar motoristas em raio progressivo com RPC otimizada
    final motoristasProximos = await SupaFlow.client.rpc(
      'buscar_motoristas_inteligentes',
      params: {
        'lat_origem': originLatitude,
        'lon_origem': originLongitude,
        'categoria_veiculo': vehicleCategory,
        'precisa_pet': needsPet,
        'precisa_bagageiro': needsGrocerySpace,
        'precisa_ar': needsAc,
        'origem_condominio': isCondoOrigin,
        'destino_condominio': isCondoDestination,
        'raio_maximo_km': 15.0,
      },
    );

    // Aplicar scoring inteligente
    final motoristasComScore = await _aplicarScoringInteligente(
      motoristasProximos,
      originLatitude,
      originLongitude,
    );

    // Ordenar por score (maior para menor)
    motoristasComScore
        .sort((a, b) => toDoubleOrZero(b['score']).compareTo(toDoubleOrZero(a['score'])));

    print('🧠 Motoristas encontrados com IA: ${motoristasComScore.length}');
    for (var motorista in motoristasComScore.take(3)) {
      print(
          '   Driver ${motorista['driver_id']}: Score ${motorista['score'].toStringAsFixed(2)}');
    }

    return motoristasComScore;
  } catch (e) {
    print('❌ Erro na busca inteligente: $e');
    return [];
  }
}

/// Sistema de scoring inteligente baseado em múltiplos fatores
Future<List<Map<String, dynamic>>> _aplicarScoringInteligente(
  List<dynamic> motoristas,
  double originLatitude,
  double originLongitude,
) async {
  List<Map<String, dynamic>> motoristasComScore = [];

  for (var motorista in motoristas) {
    double score = 0.0;

    // FATOR 1: Proximidade (35% do score)
    final distancia = motorista['distancia_km'] as double;
    final scoreProximidade = _calcularScoreProximidade(distancia);
    score += scoreProximidade * 0.35;

    // FATOR 2: Rating do motorista (25% do score)
    final rating = (motorista['average_rating'] as double?) ?? 0.0;
    final scoreRating = _calcularScoreRating(rating);
    score += scoreRating * 0.25;

    // FATOR 3: Taxa de aceitação histórica (20% do score)
    final totalViagens = (motorista['total_trips'] as int?) ?? 0;
    final scoreTaxaAceitacao = _calcularScoreTaxaAceitacao(totalViagens);
    score += scoreTaxaAceitacao * 0.20;

    // FATOR 4: Tempo desde última atualização de localização (10% do score)
    final ultimaAtualizacao =
        DateTime.tryParse(motorista['last_location_update'] ?? '');
    final scoreAtualizacao = _calcularScoreAtualizacao(ultimaAtualizacao);
    score += scoreAtualizacao * 0.10;

    // FATOR 5: Histórico de cancelamentos (10% do score, penalidade)
    final cancelamentos = (motorista['consecutive_cancellations'] as int?) ?? 0;
    final scoreCancelamentos = _calcularScoreCancelamentos(cancelamentos);
    score += scoreCancelamentos * 0.10;

    motoristasComScore.add({
      ...Map<String, dynamic>.from(motorista),
      'score': score,
      'score_breakdown': {
        'proximidade': scoreProximidade,
        'rating': scoreRating,
        'taxa_aceitacao': scoreTaxaAceitacao,
        'atualizacao': scoreAtualizacao,
        'cancelamentos': scoreCancelamentos,
      },
    });
  }

  return motoristasComScore;
}

/// Calcula score baseado na proximidade (quanto mais perto, melhor)
double _calcularScoreProximidade(double distanciaKm) {
  if (distanciaKm <= 1.0) return 1.0;
  if (distanciaKm <= 3.0) return 0.8;
  if (distanciaKm <= 5.0) return 0.6;
  if (distanciaKm <= 10.0) return 0.4;
  return 0.2;
}

/// Calcula score baseado no rating (quanto maior, melhor)
double _calcularScoreRating(double rating) {
  if (rating >= 4.8) return 1.0;
  if (rating >= 4.5) return 0.8;
  if (rating >= 4.0) return 0.6;
  if (rating >= 3.5) return 0.4;
  return 0.2;
}

/// Calcula score baseado no histórico de viagens (experiência)
double _calcularScoreTaxaAceitacao(int totalViagens) {
  if (totalViagens >= 100) return 1.0;
  if (totalViagens >= 50) return 0.8;
  if (totalViagens >= 20) return 0.6;
  if (totalViagens >= 5) return 0.4;
  return 0.2;
}

/// Calcula score baseado na atualização de localização (quanto mais recente, melhor)
double _calcularScoreAtualizacao(DateTime? ultimaAtualizacao) {
  if (ultimaAtualizacao == null) return 0.0;

  final agora = DateTime.now();
  final diferenca = agora.difference(ultimaAtualizacao).inMinutes;

  if (diferenca <= 2) return 1.0;
  if (diferenca <= 5) return 0.8;
  if (diferenca <= 10) return 0.6;
  if (diferenca <= 30) return 0.4;
  return 0.2;
}

/// Penaliza motoristas com histórico de cancelamentos
double _calcularScoreCancelamentos(int cancelamentos) {
  if (cancelamentos == 0) return 1.0;
  if (cancelamentos == 1) return 0.8;
  if (cancelamentos == 2) return 0.6;
  if (cancelamentos >= 3) return 0.2;
  return 0.4;
}

/// Envia notificação push para o motorista
Future<void> _enviarNotificacaoParaMotorista(
  String driverId,
  String tripRequestId,
  String originAddress,
  String destinationAddress,
  double estimatedFare,
) async {
  try {
    // Buscar dados do motorista para notificação
    final driverQuery = await DriversTable().queryRows(
      queryFn: (q) => q.eq('user_id', driverId),
    );

    if (driverQuery.isEmpty) return;

    final driver = driverQuery.first;
    final fcmToken = driver.fcmToken;
    final onesignalId = driver.onesignalPlayerId;

    // Criar notificação na tabela
    await NotificationsTable().insert({
      'user_id': driverId,
      'title': '🚗 Nova Corrida Disponível',
      'body':
          'De: $originAddress\nPara: $destinationAddress\nValor: R\$ ${estimatedFare.toStringAsFixed(2)}',
      'type': 'nova_corrida',
      'data': {
        'trip_request_id': tripRequestId,
        'origin_address': originAddress,
        'destination_address': destinationAddress,
        'estimated_fare': estimatedFare,
        'action': 'aceitar_corrida',
        'timeout_seconds': 30,
      },
      'is_read': false,
      'sent_at': DateTime.now().toIso8601String(),
    });

    // TODO: Implementar envio via FCM/OneSignal quando disponível
    print('🔔 Notificação enviada para motorista $driverId');
  } catch (e) {
    print('❌ Erro ao enviar notificação: $e');
  }
}

/// Sistema de timeout automático com fallback
void _programarTimeoutEFallback(String tripRequestId, String targetDriverId) {
  // Timeout de 30 segundos
  Future.delayed(Duration(seconds: 30), () async {
    await _processarTimeoutEFallback(tripRequestId);
  });
}

/// Processa timeout e move para próximo motorista
Future<void> _processarTimeoutEFallback(String tripRequestId) async {
  try {
    // Buscar estado atual da solicitação
    final requestQuery = await TripRequestsTable().queryRows(
      queryFn: (q) => q.eq('id', tripRequestId),
    );

    if (requestQuery.isEmpty) return;

    final request = requestQuery.first;

    // Se já foi aceita, não processar timeout
    if (request.status == 'accepted') return;

    final currentIndex = request.currentFallbackIndex ?? 0;
    final fallbackDrivers = request.fallbackDrivers;
    final timeoutCount = (request.timeoutCount ?? 0) + 1;

    // Se ainda há fallbacks disponíveis
    if (currentIndex < fallbackDrivers.length) {
      final nextDriverId = fallbackDrivers[currentIndex];

      // Atualizar para próximo motorista
      await TripRequestsTable().update(
        data: {
          'target_driver_id': nextDriverId,
          'current_fallback_index': currentIndex + 1,
          'timeout_count': timeoutCount,
        },
        matchingRows: (rows) => rows.eq('id', tripRequestId),
      );

      // Enviar notificação para próximo motorista
      await _enviarNotificacaoParaMotorista(
        nextDriverId,
        tripRequestId,
        request.originAddress ?? '',
        request.destinationAddress ?? '',
        request.estimatedFare ?? 0.0,
      );

      // Programar novo timeout
      _programarTimeoutEFallback(tripRequestId, nextDriverId);

      print(
          '⏰ Timeout - Movendo para fallback ${currentIndex + 1}: $nextDriverId');
    } else {
      // Esgotaram-se os motoristas
      await TripRequestsTable().update(
        data: {'status': 'timeout'},
        matchingRows: (rows) => rows.eq('id', tripRequestId),
      );

      print(
          '⏰ Timeout final - Nenhum motorista aceitou a corrida $tripRequestId');
    }
  } catch (e) {
    print('❌ Erro no timeout/fallback: $e');
  }
}
