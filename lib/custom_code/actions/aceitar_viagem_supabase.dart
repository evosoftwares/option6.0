import '/backend/supabase/supabase.dart';
import '/backend/supabase/database/database.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'index.dart'
    as actions; // exporta iniciarRastreamentoViagem e encerrarLocEmTempoReal

/// Sistema de Aceitação de Viagem 100% Supabase
/// Substitui completamente o sistema Firebase antigo
/// User ID sempre vem do Firebase Auth

/// Motorista aceita uma solicitação de viagem
Future<Map<String, dynamic>> aceitarViagemSupabase({
  required String tripRequestId,
  BuildContext? context,
}) async {
  try {
    // 1. OBTER USER ID DO FIREBASE AUTH
    final currentUserId = currentUserUid;
    if (currentUserId == null || currentUserId.isEmpty) {
      return {
        'sucesso': false,
        'erro': 'Usuário não autenticado',
      };
    }

    print('🚗 Motorista $currentUserId tentando aceitar viagem $tripRequestId');

    // 2. VERIFICAR SE SOLICITAÇÃO AINDA ESTÁ DISPONÍVEL
    final requestQuery = await TripRequestsTable().queryRows(
      queryFn: (q) => q.eq('id', tripRequestId),
    );

    if (requestQuery.isEmpty) {
      return {
        'sucesso': false,
        'erro': 'Solicitação de viagem não encontrada',
      };
    }

    final request = requestQuery.first;

    // Verificar se ainda não foi aceita
    if (request.status != 'searching') {
      return {
        'sucesso': false,
        'erro': 'Esta viagem já foi aceita por outro motorista',
      };
    }

    // Verificar se este motorista pode aceitar
    final canAccept = request.targetDriverId == currentUserId ||
        request.fallbackDrivers.contains(currentUserId);

    if (!canAccept) {
      return {
        'sucesso': false,
        'erro': 'Você não está autorizado a aceitar esta viagem',
      };
    }

    // 3. BUSCAR DADOS DO MOTORISTA
    final driverQuery = await DriversTable().queryRows(
      queryFn: (q) => q.eq('user_id', currentUserId),
    );

    if (driverQuery.isEmpty) {
      return {
        'sucesso': false,
        'erro': 'Perfil de motorista não encontrado',
      };
    }

    final driver = driverQuery.first;

    // Verificar se motorista está online e disponível
    if (driver.isOnline != true) {
      return {
        'sucesso': false,
        'erro': 'Você precisa estar online para aceitar viagens',
      };
    }

    // 4. BUSCAR DADOS DO PASSAGEIRO
    final passengerQuery = await PassengersTable().queryRows(
      queryFn: (q) => q.eqOrNull('user_id', request.passengerId),
    );

    if (passengerQuery.isEmpty) {
      return {
        'sucesso': false,
        'erro': 'Dados do passageiro não encontrados',
      };
    }

    final passenger = passengerQuery.first;

    // 5. CRIAR VIAGEM NO SUPABASE
    final tripData = {
      'trip_code': _gerarCodigoViagem(),
      'request_id': tripRequestId,
      'passenger_id': request.passengerId,
      'driver_id': currentUserId,
      'status': 'driver_assigned',
      'origin_address': request.originAddress,
      'origin_latitude': request.originLatitude,
      'origin_longitude': request.originLongitude,
      'origin_neighborhood': request.originNeighborhood,
      'destination_address': request.destinationAddress,
      'destination_latitude': request.destinationLatitude,
      'destination_longitude': request.destinationLongitude,
      'destination_neighborhood': request.destinationNeighborhood,
      'vehicle_category': request.vehicleCategory,
      'needs_pet': request.needsPet,
      'needs_grocery_space': request.needsGrocerySpace,
      'needs_ac': request.needsAc,
      'is_condo_origin': request.isCondoOrigin,
      'is_condo_destination': request.isCondoDestination,
      'number_of_stops': request.numberOfStops,
      'estimated_distance_km': request.estimatedDistanceKm,
      'estimated_duration_minutes': request.estimatedDurationMinutes,
      'total_fare': request.estimatedFare,
      'base_fare': request.estimatedFare, // Será calculada depois
      'driver_earnings':
          (request.estimatedFare ?? 0.0) * 0.8, // 80% para motorista
      'platform_commission':
          (request.estimatedFare ?? 0.0) * 0.2, // 20% plataforma
      'created_at': DateTime.now().toIso8601String(),
      'driver_assigned_at': DateTime.now().toIso8601String(),
      'requested_at': request.createdAt?.toIso8601String(),
    };

    final tripResponse = await TripsTable().insert(tripData);
    final tripId = tripResponse.id;

    // 6. ATUALIZAR STATUS DA SOLICITAÇÃO
    await TripRequestsTable().update(
      data: {
        'status': 'accepted',
        'accepted_by_driver_id': currentUserId,
        'accepted_at': DateTime.now().toIso8601String(),
      },
      matchingRows: (rows) => rows.eq('id', tripRequestId),
    );

    // 7. CRIAR CHAT DA VIAGEM
    await _criarChatViagem(tripId, currentUserId, request.passengerId ?? '');

    // 8. NOTIFICAR PASSAGEIRO
    await _notificarPassageiroViagemAceita(
      passengerId: request.passengerId ?? '',
      tripId: tripId,
      driverName: 'Motorista', // TODO: Buscar nome real do Firebase Auth
      vehicleInfo:
          '${driver.vehicleBrand ?? ''} ${driver.vehicleModel ?? ''}'.trim(),
      vehiclePlate: driver.vehiclePlate ?? '',
      driverRating: driver.averageRating ?? 0.0,
    );

    // 9. ATUALIZAR STATUS DO MOTORISTA
    await DriversTable().update(
      data: {
        'updated_at': DateTime.now().toIso8601String(),
      },
      matchingRows: (rows) => rows.eq('user_id', currentUserId),
    );

    // 10. CANCELAR OUTRAS NOTIFICAÇÕES PENDENTES
    await _cancelarOutrasNotificacoesPendentes(tripRequestId, currentUserId);

    print('✅ Viagem aceita com sucesso! Trip ID: $tripId');

    // 11. INICIAR RASTREAMENTO EM BACKGROUND PARA A VIAGEM (30s)
    if (context != null) {
      try {
        await actions.iniciarRastreamentoViagemOtimizado(context, tripId);
        print('📡 Rastreamento em background iniciado para trip $tripId');
      } catch (e) {
        print('⚠️ Falha ao iniciar rastreamento: $e');
      }
    }

    return {
      'sucesso': true,
      'trip_id': tripId,
      'trip_code': tripData['trip_code'],
      'passenger_id': request.passengerId,
      'origin_address': request.originAddress,
      'destination_address': request.destinationAddress,
      'estimated_fare': request.estimatedFare,
      'mensagem': 'Viagem aceita! Indo buscar o passageiro.',
    };
  } catch (e) {
    print('❌ Erro ao aceitar viagem: $e');
    return {
      'sucesso': false,
      'erro': 'Erro interno: ${e.toString()}',
    };
  }
}

/// Gera código único para a viagem
String _gerarCodigoViagem() {
  final agora = DateTime.now();
  final codigo = agora.millisecondsSinceEpoch.toString().substring(7);
  return 'VGM$codigo';
}

/// Cria chat entre motorista e passageiro
Future<void> _criarChatViagem(
  String tripId,
  String driverId,
  String passengerId,
) async {
  try {
    await TripChatsTable().insert({
      'trip_id': tripId,
      'sender_id': driverId,
      'message': 'Chat da viagem iniciado',
      'created_at': DateTime.now().toIso8601String(),
    });

    print('💬 Chat da viagem criado para trip $tripId');
  } catch (e) {
    print('❌ Erro ao criar chat: $e');
  }
}

/// Notifica passageiro que viagem foi aceita
Future<void> _notificarPassageiroViagemAceita({
  required String passengerId,
  required String tripId,
  required String driverName,
  required String vehicleInfo,
  required String vehiclePlate,
  required double driverRating,
}) async {
  try {
    await NotificationsTable().insert({
      'user_id': passengerId,
      'title': '🎉 Motorista Encontrado!',
      'body':
          'Seu motorista está indo te buscar.\n$vehicleInfo - $vehiclePlate',
      'type': 'viagem_aceita',
      'data': {
        'trip_id': tripId,
        'driver_name': driverName,
        'vehicle_info': vehicleInfo,
        'vehicle_plate': vehiclePlate,
        'driver_rating': driverRating,
        'action': 'acompanhar_viagem',
      },
      'is_read': false,
      'sent_at': DateTime.now().toIso8601String(),
    });

    print('🔔 Passageiro $passengerId notificado sobre viagem aceita');
  } catch (e) {
    print('❌ Erro ao notificar passageiro: $e');
  }
}

/// Cancela notificações pendentes de outros motoristas
Future<void> _cancelarOutrasNotificacoesPendentes(
  String tripRequestId,
  String driverIdQueAceitou,
) async {
  try {
    // Buscar todas as notificações pendentes relacionadas a esta viagem
    final notificacoesPendentes = await NotificationsTable().queryRows(
      queryFn: (q) => q
          .eq('type', 'nova_corrida')
          .eq('is_read', false)
          .contains('data', {'trip_request_id': tripRequestId}),
    );

    // Marcar como lidas (canceladas) todas as notificações de outros motoristas
    for (var notificacao in notificacoesPendentes) {
      if (notificacao.userId != driverIdQueAceitou) {
        await NotificationsTable().update(
          data: {
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
          },
          matchingRows: (rows) => rows.eq('id', notificacao.id),
        );
      }
    }

    print('🚫 Notificações pendentes canceladas para outros motoristas');
  } catch (e) {
    print('❌ Erro ao cancelar notificações: $e');
  }
}

/// Atualiza localização do motorista em tempo real
Future<Map<String, dynamic>> atualizarLocalizacaoMotorista({
  required double latitude,
  required double longitude,
}) async {
  try {
    final currentUserId = currentUserUid;
    if (currentUserId == null) {
      return {'sucesso': false, 'erro': 'Usuário não autenticado'};
    }

    // Atualizar localização na tabela drivers
    await DriversTable().update(
      data: {
        'current_latitude': latitude,
        'current_longitude': longitude,
        'last_location_update': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      matchingRows: (rows) => rows.eq('user_id', currentUserId),
    );

    // Inserir no histórico de localização
    await LocationUpdatesTable().insert({
      'sharing_id': currentUserId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': DateTime.now().toIso8601String(),
    });

    return {'sucesso': true};
  } catch (e) {
    print('❌ Erro ao atualizar localização: $e');
    return {'sucesso': false, 'erro': e.toString()};
  }
}

/// Finaliza viagem e integra com sistema de avaliações
Future<Map<String, dynamic>> finalizarViagemSupabase({
  required String tripId,
  required double actualDistanceKm,
  required int actualDurationMinutes,
  BuildContext? context,
}) async {
  try {
    final currentUserId = currentUserUid;
    if (currentUserId == null) {
      return {'sucesso': false, 'erro': 'Usuário não autenticado'};
    }

    // 1. ATUALIZAR VIAGEM COMO COMPLETA
    await TripsTable().update(
      data: {
        'status': 'completed',
        'actual_distance_km': actualDistanceKm,
        'actual_duration_minutes': actualDurationMinutes,
        'trip_completed_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      matchingRows: (rows) => rows.eq('id', tripId),
    );

    // 2. INTEGRAR COM SISTEMA DE AVALIAÇÕES
    // Usar a função existente do sistema de avaliações
    final avaliacaoResult = context != null
        ? await actions.finalizarViagemComAvaliacao(tripId, context)
        : {
            'sucesso': false,
            'mensagem': 'Sem contexto; avaliação não iniciada automaticamente',
          };

    // 3. ATUALIZAR ESTATÍSTICAS DO MOTORISTA
    await _atualizarEstatisticasMotorista(currentUserId);

    // 3.5 Encerrar rastreamento em background da viagem
    try {
      await actions.pararRastreamentoOtimizado();
      print('🛑 Rastreamento em background encerrado para trip $tripId');
    } catch (e) {
      print('⚠️ Falha ao encerrar rastreamento: $e');
    }

    // 4. BUSCAR DADOS DA VIAGEM PARA RETORNO
    final tripQuery = await TripsTable().queryRows(
      queryFn: (q) => q.eq('id', tripId),
    );

    if (tripQuery.isNotEmpty) {
      final trip = tripQuery.first;

      return {
        'sucesso': true,
        'trip_id': tripId,
        'passenger_id': trip.passengerId,
        'earnings': trip.driverEarnings,
        'actual_distance': actualDistanceKm,
        'actual_duration': actualDurationMinutes,
        'avaliacao_programada': avaliacaoResult['sucesso'] ?? false,
        'mensagem': 'Viagem finalizada com sucesso!',
      };
    }

    return {
      'sucesso': true,
      'trip_id': tripId,
      'avaliacao_programada': avaliacaoResult['sucesso'] ?? false,
    };
  } catch (e) {
    print('❌ Erro ao finalizar viagem: $e');
    return {
      'sucesso': false,
      'erro': 'Erro ao finalizar viagem: ${e.toString()}',
    };
  }
}

/// Atualiza estatísticas do motorista
Future<void> _atualizarEstatisticasMotorista(String driverId) async {
  try {
    // Esta função será implementada via trigger no Supabase
    // por enquanto apenas logamos a ação
    print('📊 Atualizando estatísticas do motorista $driverId');
  } catch (e) {
    print('❌ Erro ao atualizar estatísticas: $e');
  }
}
