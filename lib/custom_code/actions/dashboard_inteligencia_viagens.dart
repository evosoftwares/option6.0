import '/backend/supabase/supabase.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';

/// Dashboard e Monitoramento do Sistema Inteligente de Viagens
/// Fornece métricas em tempo real e insights sobre performance

/// Busca métricas gerais do sistema
Future<Map<String, dynamic>> buscarMetricasGeraisSistema() async {
  try {
    // Métricas de hoje
    final hoje = DateTime.now();
    final inicioHoje = DateTime(hoje.year, hoje.month, hoje.day);
    final fimHoje = inicioHoje.add(Duration(days: 1));

    // Buscar dados agregados via queries paralelas
    final results = await Future.wait([
      _buscarMetricasViagensHoje(inicioHoje, fimHoje),
      _buscarMetricasMotoristas(),
      _buscarMetricasPassageiros(),
      _buscarMetricasPerformance(),
    ]);

    return {
      'viagens_hoje': results[0],
      'motoristas': results[1],
      'passageiros': results[2],
      'performance': results[3],
      'atualizado_em': DateTime.now().toIso8601String(),
    };

  } catch (e) {
    print('❌ Erro ao buscar métricas gerais: $e');
    return {};
  }
}

/// Busca métricas de viagens de hoje
Future<Map<String, dynamic>> _buscarMetricasViagensHoje(
  DateTime inicio,
  DateTime fim,
) async {
  try {
    // Total de viagens criadas hoje
    final viagensCriadasQuery = await TripsTable().queryRows(
      queryFn: (q) => q
          .gte('created_at', inicio.toIso8601String())
          .lt('created_at', fim.toIso8601String()),
    );

    // Viagens completadas hoje
    final viagensCompletadas = viagensCriadasQuery
        .where((trip) => trip.status == 'completed')
        .length;

    // Viagens canceladas hoje
    final viagensCanceladas = viagensCriadasQuery
        .where((trip) => trip.status == 'cancelled')
        .length;

    // Receita total hoje
    final receitaTotal = viagensCriadasQuery
        .where((trip) => trip.status == 'completed')
        .fold(0.0, (sum, trip) => sum + (trip.totalFare ?? 0.0));

    // Taxa de sucesso
    final total = viagensCriadasQuery.length;
    final taxaSucesso = total > 0 ? (viagensCompletadas / total) * 100 : 0.0;

    return {
      'total_viagens': total,
      'viagens_completadas': viagensCompletadas,
      'viagens_canceladas': viagensCanceladas,
      'receita_total': receitaTotal,
      'taxa_sucesso': taxaSucesso,
    };

  } catch (e) {
    print('❌ Erro nas métricas de viagens: $e');
    return {};
  }
}

/// Busca métricas de motoristas
Future<Map<String, dynamic>> _buscarMetricasMotoristas() async {
  try {
    final motoristasQuery = await DriversTable().queryRows(
      queryFn: (q) => q.eq('approval_status', 'approved'),
    );

    final motoristasOnline = motoristasQuery
        .where((driver) => driver.isOnline == true)
        .length;

    final motoristasAtivos = motoristasQuery
        .where((driver) =>
            driver.lastLocationUpdate != null &&
            driver.lastLocationUpdate!.isAfter(
              DateTime.now().subtract(Duration(minutes: 10))
            ))
        .length;

    final ratingMedio = motoristasQuery.isEmpty
        ? 0.0
        : motoristasQuery
            .map((d) => d.averageRating ?? 0.0)
            .reduce((a, b) => a + b) / motoristasQuery.length;

    return {
      'total_motoristas': motoristasQuery.length,
      'motoristas_online': motoristasOnline,
      'motoristas_ativos': motoristasAtivos,
      'rating_medio': ratingMedio,
      'taxa_online': motoristasQuery.isNotEmpty
          ? (motoristasOnline / motoristasQuery.length) * 100
          : 0.0,
    };

  } catch (e) {
    print('❌ Erro nas métricas de motoristas: $e');
    return {};
  }
}

/// Busca métricas de passageiros
Future<Map<String, dynamic>> _buscarMetricasPassageiros() async {
  try {
    final passageirosQuery = await PassengersTable().queryRows(
      queryFn: (q) => q.limit(1000), // Limitar para performance
    );

    final passageirosAtivos = passageirosQuery
        .where((p) => (p.totalTrips ?? 0) > 0)
        .length;

    final ratingMedio = passageirosQuery.isEmpty
        ? 0.0
        : passageirosQuery
            .map((p) => p.averageRating ?? 0.0)
            .reduce((a, b) => a + b) / passageirosQuery.length;

    return {
      'total_passageiros': passageirosQuery.length,
      'passageiros_ativos': passageirosAtivos,
      'rating_medio': ratingMedio,
    };

  } catch (e) {
    print('❌ Erro nas métricas de passageiros: $e');
    return {};
  }
}

/// Busca métricas de performance do sistema
Future<Map<String, dynamic>> _buscarMetricasPerformance() async {
  try {
    final ultimaHora = DateTime.now().subtract(Duration(hours: 1));

    // Solicitações da última hora
    final solicitacoesQuery = await TripRequestsTable().queryRows(
      queryFn: (q) => q.gte('created_at', ultimaHora.toIso8601String()),
    );

    // Taxa de aceitação
    final solicitacoesAceitas = solicitacoesQuery
        .where((req) => req.status == 'accepted')
        .length;

    final taxaAceitacao = solicitacoesQuery.isNotEmpty
        ? (solicitacoesAceitas / solicitacoesQuery.length) * 100
        : 0.0;

    // Tempo médio de resposta
    final temposResposta = solicitacoesQuery
        .where((req) => req.acceptedAt != null && req.createdAt != null)
        .map((req) => req.acceptedAt!.difference(req.createdAt!).inSeconds)
        .toList();

    final tempoMedioResposta = temposResposta.isNotEmpty
        ? temposResposta.reduce((a, b) => a + b) / temposResposta.length
        : 0.0;

    return {
      'solicitacoes_ultima_hora': solicitacoesQuery.length,
      'solicitacoes_aceitas': solicitacoesAceitas,
      'taxa_aceitacao': taxaAceitacao,
      'tempo_medio_resposta_segundos': tempoMedioResposta,
    };

  } catch (e) {
    print('❌ Erro nas métricas de performance: $e');
    return {};
  }
}

/// Busca relatório detalhado de viagens por período
Future<List<Map<String, dynamic>>> buscarRelatorioViagens({
  required DateTime dataInicio,
  required DateTime dataFim,
  String? status,
  String? driverId,
  String? passengerId,
}) async {
  try {
    var query = TripsTable().queryRows(
      queryFn: (q) {
        var baseQuery = q
            .gte('created_at', dataInicio.toIso8601String())
            .lte('created_at', dataFim.toIso8601String());

        if (status != null) {
          baseQuery = baseQuery.eq('status', status);
        }
        if (driverId != null) {
          baseQuery = baseQuery.eq('driver_id', driverId);
        }
        if (passengerId != null) {
          baseQuery = baseQuery.eq('passenger_id', passengerId);
        }

        return baseQuery.order('created_at', ascending: false);
      },
    );

    final trips = await query;

    return trips.map((trip) => {
      'id': trip.id,
      'trip_code': trip.tripCode,
      'status': trip.status,
      'passenger_id': trip.passengerId,
      'driver_id': trip.driverId,
      'origin_address': trip.originAddress,
      'destination_address': trip.destinationAddress,
      'distance_km': trip.actualDistanceKm ?? trip.estimatedDistanceKm,
      'duration_minutes': trip.actualDurationMinutes ?? trip.estimatedDurationMinutes,
      'total_fare': trip.totalFare,
      'driver_earnings': trip.driverEarnings,
      'platform_commission': trip.platformCommission,
      'created_at': trip.createdAt?.toIso8601String(),
      'completed_at': trip.tripCompletedAt?.toIso8601String(),
      'cancelled_at': trip.cancelledAt?.toIso8601String(),
      'cancellation_reason': trip.cancellationReason,
    }).toList();

  } catch (e) {
    print('❌ Erro no relatório de viagens: $e');
    return [];
  }
}

/// Analisa eficiência do algoritmo de matching
Future<Map<String, dynamic>> analisarEficienciaMatching({
  int ultimosDias = 7,
}) async {
  try {
    final dataInicio = DateTime.now().subtract(Duration(days: ultimosDias));

    // Buscar solicitações do período
    final solicitacoesQuery = await TripRequestsTable().queryRows(
      queryFn: (q) => q.gte('created_at', dataInicio.toIso8601String()),
    );

    if (solicitacoesQuery.isEmpty) {
      return {
        'total_solicitacoes': 0,
        'taxa_sucesso': 0.0,
        'tempo_medio_matching': 0.0,
        'uso_fallbacks': 0.0,
      };
    }

    // Análise de taxa de sucesso
    final solicitacoesSucesso = solicitacoesQuery
        .where((req) => req.status == 'accepted')
        .length;

    final taxaSucesso = (solicitacoesSucesso / solicitacoesQuery.length) * 100;

    // Análise de tempo de matching
    final temposMatching = solicitacoesQuery
        .where((req) => req.acceptedAt != null && req.createdAt != null)
        .map((req) => req.acceptedAt!.difference(req.createdAt!).inSeconds)
        .toList();

    final tempoMedioMatching = temposMatching.isNotEmpty
        ? temposMatching.reduce((a, b) => a + b) / temposMatching.length
        : 0.0;

    // Análise de uso de fallbacks
    final comFallback = solicitacoesQuery
        .where((req) => (req.currentFallbackIndex ?? 0) > 0)
        .length;

    final usoFallbacks = (comFallback / solicitacoesQuery.length) * 100;

    // Análise de timeouts
    final timeouts = solicitacoesQuery
        .where((req) => req.status == 'timeout')
        .length;

    return {
      'total_solicitacoes': solicitacoesQuery.length,
      'solicitacoes_sucesso': solicitacoesSucesso,
      'taxa_sucesso': taxaSucesso,
      'tempo_medio_matching_segundos': tempoMedioMatching,
      'uso_fallbacks_percent': usoFallbacks,
      'total_timeouts': timeouts,
      'taxa_timeout': (timeouts / solicitacoesQuery.length) * 100,
      'periodo_analise_dias': ultimosDias,
    };

  } catch (e) {
    print('❌ Erro na análise de matching: $e');
    return {};
  }
}

/// Gera insights baseados em dados históricos
Future<Map<String, dynamic>> gerarInsightsSistema({
  int ultimosDias = 30,
}) async {
  try {
    final dataInicio = DateTime.now().subtract(Duration(days: ultimosDias));

    // Análise de horários de pico
    final viagensQuery = await TripsTable().queryRows(
      queryFn: (q) => q
          .gte('created_at', dataInicio.toIso8601String())
          .eq('status', 'completed'),
    );

    // Agrupar por hora do dia
    Map<int, int> viagensPorHora = {};
    for (var trip in viagensQuery) {
      if (trip.createdAt != null) {
        final hora = trip.createdAt!.hour;
        viagensPorHora[hora] = (viagensPorHora[hora] ?? 0) + 1;
      }
    }

    // Encontrar horário de pico
    final horarioPico = viagensPorHora.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    // Análise de regiões populares
    Map<String, int> origemPopular = {};
    for (var trip in viagensQuery) {
      final bairro = trip.originNeighborhood ?? 'Outros';
      origemPopular[bairro] = (origemPopular[bairro] ?? 0) + 1;
    }

    final regiaoMaisPopular = origemPopular.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    // Análise de distância média
    final distancias = viagensQuery
        .where((trip) => trip.actualDistanceKm != null)
        .map((trip) => trip.actualDistanceKm!)
        .toList();

    final distanciaMedia = distancias.isNotEmpty
        ? distancias.reduce((a, b) => a + b) / distancias.length
        : 0.0;

    return {
      'horario_pico': {
        'hora': horarioPico.key,
        'total_viagens': horarioPico.value,
      },
      'regiao_mais_popular': {
        'bairro': regiaoMaisPopular.key,
        'total_viagens': regiaoMaisPopular.value,
      },
      'distancia_media_km': distanciaMedia,
      'total_viagens_analisadas': viagensQuery.length,
      'periodo_analise_dias': ultimosDias,
      'recomendacoes': _gerarRecomendacoes(
        viagensPorHora,
        origemPopular,
        distanciaMedia,
      ),
    };

  } catch (e) {
    print('❌ Erro ao gerar insights: $e');
    return {};
  }
}

/// Gera recomendações baseadas nos dados
List<String> _gerarRecomendacoes(
  Map<int, int> viagensPorHora,
  Map<String, int> origemPopular,
  double distanciaMedia,
) {
  List<String> recomendacoes = [];

  // Recomendação de horário
  final horarios = viagensPorHora.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  if (horarios.isNotEmpty) {
    final pico = horarios.first;
    recomendacoes.add(
      'Horário de pico: ${pico.key}h com ${pico.value} viagens. '
      'Considere incentivos para motoristas neste horário.'
    );
  }

  // Recomendação de região
  final regioes = origemPopular.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  if (regioes.length >= 2) {
    recomendacoes.add(
      'Região ${regioes.first.key} tem alta demanda (${regioes.first.value} viagens). '
      'Concentre motoristas nesta área.'
    );
  }

  // Recomendação de distância
  if (distanciaMedia > 15.0) {
    recomendacoes.add(
      'Distância média alta (${distanciaMedia.toStringAsFixed(1)}km). '
      'Considere ajustar preços para viagens longas.'
    );
  } else if (distanciaMedia < 5.0) {
    recomendacoes.add(
      'Muitas viagens curtas (${distanciaMedia.toStringAsFixed(1)}km). '
      'Otimize para viagens urbanas rápidas.'
    );
  }

  return recomendacoes;
}

/// Monitora saúde do sistema em tempo real
Future<Map<String, dynamic>> monitorarSaudeSistema() async {
  try {
    final agora = DateTime.now();
    final ultimos5Min = agora.subtract(Duration(minutes: 5));
    final ultimos15Min = agora.subtract(Duration(minutes: 15));

    // Verificar motoristas ativos
    final motoristasAtivos = await DriversTable().queryRows(
      queryFn: (q) => q
          .eq('is_online', true)
          .gte('last_location_update', ultimos5Min.toIso8601String()),
    );

    // Verificar solicitações pendentes
    final solicitacoesPendentes = await TripRequestsTable().queryRows(
      queryFn: (q) => q.eq('status', 'searching'),
    );

    // Verificar viagens em andamento
    final viagensAndamento = await TripsTable().queryRows(
      queryFn: (q) => q.in_('status', ['driver_assigned', 'driver_arrived', 'in_progress']),
    );

    // Verificar erros recentes (baseado em timeouts)
    final errosRecentes = await TripRequestsTable().queryRows(
      queryFn: (q) => q
          .eq('status', 'timeout')
          .gte('created_at', ultimos15Min.toIso8601String()),
    );

    // Calcular status geral
    String statusGeral = 'Saudável';
    List<String> alertas = [];

    if (motoristasAtivos.length < 5) {
      statusGeral = 'Atenção';
      alertas.add('Poucos motoristas online (${motoristasAtivos.length})');
    }

    if (solicitacoesPendentes.length > 10) {
      statusGeral = 'Crítico';
      alertas.add('Muitas solicitações pendentes (${solicitacoesPendentes.length})');
    }

    if (errosRecentes.length > 5) {
      statusGeral = 'Crítico';
      alertas.add('Muitos timeouts recentes (${errosRecentes.length})');
    }

    return {
      'status_geral': statusGeral,
      'motoristas_ativos': motoristasAtivos.length,
      'solicitacoes_pendentes': solicitacoesPendentes.length,
      'viagens_andamento': viagensAndamento.length,
      'erros_recentes': errosRecentes.length,
      'alertas': alertas,
      'timestamp': agora.toIso8601String(),
      'saude_score': _calcularSaudeScore(
        motoristasAtivos.length,
        solicitacoesPendentes.length,
        errosRecentes.length,
      ),
    };

  } catch (e) {
    print('❌ Erro no monitoramento de saúde: $e');
    return {
      'status_geral': 'Erro',
      'erro': e.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

/// Calcula score de saúde (0-100)
int _calcularSaudeScore(
  int motoristasAtivos,
  int solicitacoesPendentes,
  int errosRecentes,
) {
  int score = 100;

  // Penalizar por poucos motoristas
  if (motoristasAtivos < 3) score -= 40;
  else if (motoristasAtivos < 5) score -= 20;
  else if (motoristasAtivos < 10) score -= 10;

  // Penalizar por muitas solicitações pendentes
  if (solicitacoesPendentes > 20) score -= 30;
  else if (solicitacoesPendentes > 10) score -= 15;
  else if (solicitacoesPendentes > 5) score -= 5;

  // Penalizar por erros recentes
  if (errosRecentes > 10) score -= 30;
  else if (errosRecentes > 5) score -= 15;
  else if (errosRecentes > 2) score -= 5;

  return score < 0 ? 0 : score;
}