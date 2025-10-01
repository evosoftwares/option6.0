import '/backend/supabase/supabase.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import '../../utils/num_utils.dart';
import 'dart:math' show sin, cos, sqrt, atan2, pi;

/// Conecta interface do passageiro com dados reais do Supabase
/// Substitui dados estáticos por dados dinâmicos e funcionais

/// Busca viagens históricas do passageiro
Future<List<Map<String, dynamic>>> buscarViagensHistoricasPassageiro() async {
  try {
    final currentUserId = currentUserUid;
    if (currentUserId == null) return [];

    final tripsQuery = await TripsTable().queryRows(
      queryFn: (q) => q
          .eq('passenger_id', currentUserId)
          .order('created_at', ascending: false)
          .limit(10),
    );

    return tripsQuery.map((trip) => {
      'id': trip.id,
      'origin_address': trip.originAddress ?? 'Origem não informada',
      'destination_address': trip.destinationAddress ?? 'Destino não informado',
      'origin_neighborhood': trip.originNeighborhood ?? '',
      'destination_neighborhood': trip.destinationNeighborhood ?? '',
      'status': trip.status ?? 'unknown',
      'total_fare': trip.totalFare ?? 0.0,
      'created_at': trip.createdAt?.toIso8601String() ?? '',
      'trip_completed_at': trip.tripCompletedAt?.toIso8601String(),
      'driver_id': trip.driverId,
    }).toList();

  } catch (e) {
    print('❌ Erro ao buscar viagens históricas: $e');
    return [];
  }
}

/// Verifica se passageiro tem viagem ativa
Future<Map<String, dynamic>?> verificarViagemAtiva() async {
  try {
    final currentUserId = currentUserUid;
    if (currentUserId == null) return null;

    // Buscar viagem ativa (status diferente de completed, cancelled, timeout)
    final activeTripsQuery = await TripsTable().queryRows(
      queryFn: (q) => q
          .eq('passenger_id', currentUserId)
          .not('status', 'in', ['completed', 'cancelled'])
          .order('created_at', ascending: false)
          .limit(1),
    );

    if (activeTripsQuery.isNotEmpty) {
      final trip = activeTripsQuery.first;

      // Buscar dados do motorista se existe
      Map<String, dynamic>? driverData;
      if (trip.driverId != null) {
        final driverQuery = await DriversTable().queryRows(
          queryFn: (q) => q.eq('user_id', trip.driverId!),
        );
        if (driverQuery.isNotEmpty) {
          final driver = driverQuery.first;
          driverData = {
            'vehicle_brand': driver.vehicleBrand,
            'vehicle_model': driver.vehicleModel,
            'vehicle_color': driver.vehicleColor,
            'vehicle_plate': driver.vehiclePlate,
            'current_latitude': driver.currentLatitude,
            'current_longitude': driver.currentLongitude,
            'average_rating': driver.averageRating,
          };
        }
      }

      return {
        'trip_id': trip.id,
        'trip_code': trip.tripCode,
        'status': trip.status,
        'origin_address': trip.originAddress,
        'destination_address': trip.destinationAddress,
        'driver_id': trip.driverId,
        'driver_data': driverData,
        'estimated_fare': trip.totalFare,
        'created_at': trip.createdAt?.toIso8601String(),
      };
    }

    // Se não tem viagem ativa, verificar solicitações pendentes
    final pendingRequestsQuery = await TripRequestsTable().queryRows(
      queryFn: (q) => q
          .eq('passenger_id', currentUserId)
          .eq('status', 'searching')
          .order('created_at', ascending: false)
          .limit(1),
    );

    if (pendingRequestsQuery.isNotEmpty) {
      final request = pendingRequestsQuery.first;
      return {
        'request_id': request.id,
        'status': 'searching',
        'origin_address': request.originAddress,
        'destination_address': request.destinationAddress,
        'estimated_fare': request.estimatedFare,
        'created_at': request.createdAt?.toIso8601String(),
        'expires_at': request.expiresAt?.toIso8601String(),
      };
    }

    return null;
  } catch (e) {
    print('❌ Erro ao verificar viagem ativa: $e');
    return null;
  }
}

/// Busca motoristas disponíveis em tempo real para escolha
Future<List<Map<String, dynamic>>> buscarMotoristasDisponiveis({
  required double originLatitude,
  required double originLongitude,
  required String vehicleCategory,
  bool needsPet = false,
  bool needsGrocerySpace = false,
  bool needsAc = false,
  bool isCondoOrigin = false,
  bool isCondoDestination = false,
}) async {
  try {
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
        'raio_maximo_km': 10.0,
      },
    ).timeout(Duration(seconds: 8), onTimeout: () => []);
    List<Map<String, dynamic>> motoristasFormatados = [];

    for (var motorista in motoristasProximos) {
      final distanciaKm = motorista['distancia_km'] as double;
      final tempoChegadaMinutos = _calcularTempoChegada(distanciaKm);
      final precoEstimado = _calcularPrecoEstimado(distanciaKm);

      motoristasFormatados.add({
        'driver_id': motorista['user_id'],
        'nome': 'Motorista', // Nome vem do Firebase Auth
        'vehicle_info': '${motorista['vehicle_brand'] ?? ''} ${motorista['vehicle_model'] ?? ''}'.trim(),
        'vehicle_color': motorista['vehicle_color'] ?? '',
        'vehicle_plate': motorista['vehicle_plate'] ?? '',
        'rating': (motorista['average_rating'] as double?) ?? 0.0,
        'total_trips': motorista['total_trips'] ?? 0,
        'distancia_km': distanciaKm,
        'tempo_chegada_minutos': tempoChegadaMinutos,
        'preco_estimado': precoEstimado,
        'aceita_pet': motorista['accepts_pet'] ?? false,
        'aceita_bagagem': motorista['accepts_grocery'] ?? false,
        'politica_ar': motorista['ac_policy'] ?? 'opcional',
      });
    }

    // Ordenar por melhor custo-benefício (rating + proximidade)
    motoristasFormatados.sort((a, b) {
      final ratingA = toDoubleOrZero(a['rating']);
      final ratingB = toDoubleOrZero(b['rating']);
      final distA = toDoubleOrZero(a['distancia_km']);
      final distB = toDoubleOrZero(b['distancia_km']);
      final scoreA = ratingA * 0.7 + (10.0 - distA) * 0.3;
      final scoreB = ratingB * 0.7 + (10.0 - distB) * 0.3;
      return scoreB.compareTo(scoreA);
    });

    return motoristasFormatados;

  } catch (e) {
    print('❌ Erro ao buscar motoristas disponíveis: $e');
    return [];
  }
}

/// Calcula tempo estimado de chegada baseado na distância
int _calcularTempoChegada(double distanciaKm) {
  // Velocidade média urbana: 20km/h
  final tempoHoras = distanciaKm / 20.0;
  final tempoMinutos = (tempoHoras * 60).round();
  return tempoMinutos < 3 ? 3 : tempoMinutos; // Mínimo 3 minutos
}

/// Calcula preço estimado baseado na distância
double _calcularPrecoEstimado(double distanciaKm) {
  final precoBase = 8.0; // R$ 8,00 bandeirada
  final precoPorKm = 2.5; // R$ 2,50 por km
  return precoBase + (distanciaKm * precoPorKm);
}

/// Verifica disponibilidade de motoristas em tempo real
Future<Map<String, dynamic>> verificarDisponibilidadeMotoristas({
  required double latitude,
  required double longitude,
  required String vehicleCategory,
}) async {
  try {
    final disponibilidade = await SupaFlow.client.rpc(
      'verificar_disponibilidade_motoristas',
      params: {
        'categoria_veiculo': vehicleCategory,
        'lat_origem': latitude,
        'lon_origem': longitude,
        'raio_km': 10.0,
      },
    ).timeout(Duration(seconds: 6), onTimeout: () => []);

    if (disponibilidade.isNotEmpty) {
      final dados = disponibilidade.first;
      return {
        'motoristas_disponiveis': dados['motoristas_disponiveis'] ?? 0,
        'tempo_medio_chegada': dados['tempo_medio_chegada'] ?? 15,
        'preco_estimado': dados['preco_estimado'] ?? 20.0,
        'disponivel': (dados['motoristas_disponiveis'] ?? 0) > 0,
      };
    }

    return {
      'motoristas_disponiveis': 0,
      'tempo_medio_chegada': 15,
      'preco_estimado': 20.0,
      'disponivel': false,
    };

  } catch (e) {
    print('❌ Erro ao verificar disponibilidade: $e');
    return {
      'motoristas_disponiveis': 0,
      'tempo_medio_chegada': 15,
      'preco_estimado': 20.0,
      'disponivel': false,
    };
  }
}

/// Cancela viagem ou solicitação ativa
Future<Map<String, dynamic>> cancelarViagemPassageiro({
  String? tripId,
  String? requestId,
  required String motivo,
}) async {
  try {
    final currentUserId = currentUserUid;
    if (currentUserId == null) {
      return {'sucesso': false, 'erro': 'Usuário não autenticado'};
    }

    if (tripId != null) {
      // Cancelar viagem ativa
      await TripsTable().update(
        data: {
          'status': 'cancelled',
          'cancellation_reason': motivo,
          'cancelled_by': 'passenger',
          'cancelled_at': DateTime.now().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq('id', tripId),
      );

      // TODO: Calcular taxa de cancelamento se aplicável
      // TODO: Notificar motorista do cancelamento

      return {
        'sucesso': true,
        'tipo': 'viagem',
        'mensagem': 'Viagem cancelada com sucesso',
      };
    }

    if (requestId != null) {
      // Cancelar solicitação pendente
      await TripRequestsTable().update(
        data: {
          'status': 'cancelled',
        },
        matchingRows: (rows) => rows.eq('id', requestId),
      );

      return {
        'sucesso': true,
        'tipo': 'solicitacao',
        'mensagem': 'Solicitação cancelada com sucesso',
      };
    }

    return {'sucesso': false, 'erro': 'Nenhuma viagem ou solicitação encontrada'};

  } catch (e) {
    print('❌ Erro ao cancelar: $e');
    return {'sucesso': false, 'erro': e.toString()};
  }
}

/// Busca estatísticas do passageiro
Future<Map<String, dynamic>> buscarEstatisticasPassageiro() async {
  try {
    final currentUserId = currentUserUid;
    if (currentUserId == null) return {};

    final passengerQuery = await PassengersTable().queryRows(
      queryFn: (q) => q.eq('user_id', currentUserId),
    );

    if (passengerQuery.isNotEmpty) {
      final passenger = passengerQuery.first;
      return {
        'total_trips': passenger.totalTrips ?? 0,
        'average_rating': passenger.averageRating ?? 0.0,
        'consecutive_cancellations': passenger.consecutiveCancellations ?? 0,
      };
    }

    return {
      'total_trips': 0,
      'average_rating': 0.0,
      'consecutive_cancellations': 0,
    };

  } catch (e) {
    print('❌ Erro ao buscar estatísticas: $e');
    return {};
  }
}

/// Calcula estimativa de viagem completa
Future<Map<String, dynamic>> calcularEstimativaViagem({
  required double originLatitude,
  required double originLongitude,
  required double destinationLatitude,
  required double destinationLongitude,
  required String vehicleCategory,
  int numberOfStops = 0,
}) async {
  try {
    // Cálculo básico de distância usando fórmula haversine
    final distanciaKm = _calcularDistanciaHaversine(
      originLatitude,
      originLongitude,
      destinationLatitude,
      destinationLongitude,
    );

    // Adicionar distância extra para paradas
    final distanciaTotal = distanciaKm + (numberOfStops * 0.5);

    // Calcular duração (velocidade média urbana 25km/h)
    final duracaoMinutos = ((distanciaTotal / 25.0) * 60).round();

    // Calcular preço
    final precoBase = 8.0;
    final precoPorKm = 2.5;
    final precoParadas = numberOfStops * 3.0; // R$ 3,00 por parada
    final precoTotal = precoBase + (distanciaTotal * precoPorKm) + precoParadas;

    return {
      'distancia_km': distanciaTotal,
      'duracao_minutos': duracaoMinutos,
      'preco_estimado': precoTotal,
      'preco_base': precoBase,
      'preco_por_km': precoPorKm,
      'preco_paradas': precoParadas,
      'numero_paradas': numberOfStops,
    };

  } catch (e) {
    print('❌ Erro ao calcular estimativa: $e');
    return {};
  }
}

/// Calcula distância usando fórmula haversine
double _calcularDistanciaHaversine(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const double earthRadius = 6371; // Raio da Terra em km

  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);

  final a = (sin(dLat / 2) * sin(dLat / 2)) +
      cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double _toRadians(double degree) {
  return degree * (pi / 180);
}