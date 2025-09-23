import '/backend/supabase/supabase.dart';
import '/backend/supabase/database/database.dart';

/// Processa uma avaliação de forma inteligente
/// Insere a avaliação e atualiza automaticamente as médias
/// Parâmetros:
/// - tripId: ID da viagem
/// - tipoAvaliacao: 'motorista' ou 'passageiro'
/// - rating: Nota de 1 a 5
/// - tags: Lista de tags selecionadas
/// - comentario: Comentário opcional
Future<Map<String, dynamic>> processarAvaliacao(
  String tripId,
  String tipoAvaliacao,
  int rating,
  List<String> tags,
  String? comentario,
) async {
  try {
    // 1. Buscar informações da viagem
    final tripQuery = await TripsTable().queryRows(
      queryFn: (q) => q.eq('id', tripId),
    );

    if (tripQuery.isEmpty) {
      return {
        'sucesso': false,
        'erro': 'Viagem não encontrada',
      };
    }

    final trip = tripQuery.first;
    final String? driverId = trip.driverId;
    final String? passengerId = trip.passengerId;

    if (driverId == null || passengerId == null) {
      return {
        'sucesso': false,
        'erro': 'Dados da viagem incompletos',
      };
    }

    // 2. Verificar se já existe avaliação para esta viagem
    final existingRating = await RatingsTable().queryRows(
      queryFn: (q) => q.eq('trip_id', tripId),
    );

    Map<String, dynamic> ratingData = {};

    if (tipoAvaliacao == 'motorista') {
      // Passageiro avaliando motorista
      ratingData = {
        'trip_id': tripId,
        'driver_rating': rating,
        'driver_rating_tags': tags,
        'driver_rating_comment': comentario,
        'driver_rated_at': DateTime.now().toIso8601String(),
      };
    } else {
      // Motorista avaliando passageiro
      ratingData = {
        'trip_id': tripId,
        'passenger_rating': rating,
        'passenger_rating_tags': tags,
        'passenger_rating_comment': comentario,
        'passenger_rated_at': DateTime.now().toIso8601String(),
      };
    }

    // 3. Inserir ou atualizar avaliação
    if (existingRating.isEmpty) {
      // Criar nova avaliação
      await RatingsTable().insert(ratingData);
    } else {
      // Atualizar avaliação existente
      await RatingsTable().update(
        data: ratingData,
        matchingRows: (rows) => rows.eq('trip_id', tripId),
      );
    }

    // 4. Recalcular rating médio
    if (tipoAvaliacao == 'motorista') {
      await _atualizarRatingMotorista(driverId);
    } else {
      await _atualizarRatingPassageiro(passengerId);
    }

    return {
      'sucesso': true,
      'mensagem': 'Avaliação enviada com sucesso!',
    };

  } catch (e) {
    return {
      'sucesso': false,
      'erro': 'Erro ao processar avaliação: ${e.toString()}',
    };
  }
}

/// Atualiza o rating médio do motorista
Future<void> _atualizarRatingMotorista(String driverId) async {
  try {
    // Buscar todas as avaliações do motorista
    final ratingsQuery = await RatingsTable().queryRows(
      queryFn: (q) => q
          .eq('trip_id', '')  // Vamos ajustar isso
          .not('driver_rating', 'is', null),
    );

    // Filtrar avaliações do motorista específico através das trips
    final tripsQuery = await TripsTable().queryRows(
      queryFn: (q) => q.eq('driver_id', driverId),
    );

    final tripIds = tripsQuery.map((trip) => trip.id).toList();

    final driverRatings = ratingsQuery
        .where((rating) =>
            tripIds.contains(rating.tripId) &&
            rating.driverRating != null)
        .toList();

    if (driverRatings.isNotEmpty) {
      // Calcular média
      final total = driverRatings
          .map((r) => r.driverRating!)
          .reduce((a, b) => a + b);
      final average = total / driverRatings.length;

      // Atualizar driver
      await DriversTable().update(
        data: {
          'average_rating': double.parse(average.toStringAsFixed(2)),
          'total_trips': driverRatings.length,
        },
        matchingRows: (rows) => rows.eq('id', driverId),
      );
    }
  } catch (e) {
    print('Erro ao atualizar rating do motorista: $e');
  }
}

/// Atualiza o rating médio do passageiro
Future<void> _atualizarRatingPassageiro(String passengerId) async {
  try {
    // Buscar todas as avaliações do passageiro
    final ratingsQuery = await RatingsTable().queryRows(
      queryFn: (q) => q.not('passenger_rating', 'is', null),
    );

    // Filtrar avaliações do passageiro específico através das trips
    final tripsQuery = await TripsTable().queryRows(
      queryFn: (q) => q.eq('passenger_id', passengerId),
    );

    final tripIds = tripsQuery.map((trip) => trip.id).toList();

    final passengerRatings = ratingsQuery
        .where((rating) =>
            tripIds.contains(rating.tripId) &&
            rating.passengerRating != null)
        .toList();

    if (passengerRatings.isNotEmpty) {
      // Calcular média
      final total = passengerRatings
          .map((r) => r.passengerRating!)
          .reduce((a, b) => a + b);
      final average = total / passengerRatings.length;

      // Atualizar passenger
      await PassengersTable().update(
        data: {
          'average_rating': double.parse(average.toStringAsFixed(2)),
          'total_trips': passengerRatings.length,
        },
        matchingRows: (rows) => rows.eq('id', passengerId),
      );
    }
  } catch (e) {
    print('Erro ao atualizar rating do passageiro: $e');
  }
}

/// Solicita avaliação após completar viagem
/// Chama essa função quando trip_status muda para 'completed'
Future<bool> solicitarAvaliacaoViagem(String tripId) async {
  try {
    // Aguardar 5 minutos antes de solicitar avaliação
    await Future.delayed(Duration(minutes: 5));

    // Verificar se a viagem ainda está completed
    final tripQuery = await TripsTable().queryRows(
      queryFn: (q) => q.eq('id', tripId),
    );

    if (tripQuery.isEmpty || tripQuery.first.status != 'completed') {
      return false;
    }

    // Verificar se já foram feitas avaliações
    final existingRating = await RatingsTable().queryRows(
      queryFn: (q) => q.eq('trip_id', tripId),
    );

    bool needsDriverRating = true;
    bool needsPassengerRating = true;

    if (existingRating.isNotEmpty) {
      final rating = existingRating.first;
      needsDriverRating = rating.driverRating == null;
      needsPassengerRating = rating.passengerRating == null;
    }

    // Enviar notificações push se necessário
    if (needsDriverRating || needsPassengerRating) {
      // Aqui seria implementado o envio de notificação push
      // Por enquanto, apenas retornamos true indicando que a solicitação foi feita
      return true;
    }

    return false;
  } catch (e) {
    print('Erro ao solicitar avaliação: $e');
    return false;
  }
}