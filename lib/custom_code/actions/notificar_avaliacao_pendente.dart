import '/backend/supabase/supabase.dart';
import 'package:flutter/material.dart';

/// Sistema de Notificação para Solicitação de Avaliações
/// Deve ser chamado quando uma viagem é finalizada (status = 'completed')

/// Verifica se há avaliações pendentes e programa notificações
Future<Map<String, dynamic>> verificarAvaliacoesPendentes(String tripId) async {
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

    // Verificar se a viagem está realmente finalizada
    if (trip.status != 'completed') {
      return {
        'sucesso': false,
        'erro': 'Viagem ainda não foi finalizada',
      };
    }

    // 2. Verificar avaliações existentes
    final existingRatings = await RatingsTable().queryRows(
      queryFn: (q) => q.eq('trip_id', tripId),
    );

    bool precisaAvaliacaoMotorista = true;
    bool precisaAvaliacaoPassageiro = true;

    if (existingRatings.isNotEmpty) {
      final rating = existingRatings.first;
      precisaAvaliacaoMotorista = rating.driverRating == null;
      precisaAvaliacaoPassageiro = rating.passengerRating == null;
    }

    // 3. Programar notificações se necessário
    List<String> notificacoesProgramadas = [];

    if (precisaAvaliacaoMotorista) {
      await _programarNotificacaoAvaliacao(
        tripId,
        'motorista',
        trip.passengerId ?? '',
        delay: Duration(minutes: 5),
      );
      notificacoesProgramadas
          .add('Notificação para avaliar motorista programada');
    }

    if (precisaAvaliacaoPassageiro) {
      await _programarNotificacaoAvaliacao(
        tripId,
        'passageiro',
        trip.driverId ?? '',
        delay: Duration(minutes: 5),
      );
      notificacoesProgramadas
          .add('Notificação para avaliar passageiro programada');
    }

    return {
      'sucesso': true,
      'avaliacoesPendentes': {
        'motorista': precisaAvaliacaoMotorista,
        'passageiro': precisaAvaliacaoPassageiro,
      },
      'notificacoes': notificacoesProgramadas,
    };
  } catch (e) {
    return {
      'sucesso': false,
      'erro': 'Erro ao verificar avaliações pendentes: ${e.toString()}',
    };
  }
}

/// Programa uma notificação para solicitar avaliação
Future<void> _programarNotificacaoAvaliacao(
    String tripId,
    String tipoAvaliacao, // 'motorista' ou 'passageiro'
    String userId,
    {Duration delay = const Duration(minutes: 5)}) async {
  try {
    // Aguardar o delay especificado
    await Future.delayed(delay);

    // Inserir notificação na tabela
    final titulo = tipoAvaliacao == 'motorista'
        ? 'Avalie seu motorista'
        : 'Avalie seu passageiro';

    final corpo = tipoAvaliacao == 'motorista'
        ? 'Como foi sua viagem? Avalie seu motorista e ajude outros usuários!'
        : 'Como foi o passageiro? Sua avaliação ajuda a melhorar o serviço!';

    await NotificationsTable().insert({
      'user_id': userId,
      'title': titulo,
      'body': corpo,
      'type': 'avaliacao_pendente',
      'data': {
        'trip_id': tripId,
        'tipo_avaliacao': tipoAvaliacao,
        'action': 'abrir_tela_avaliacao',
      },
      'is_read': false,
      'sent_at': DateTime.now().toIso8601String(),
    });

    print(
        'Notificação de avaliação programada para $tipoAvaliacao (Trip: $tripId)');
  } catch (e) {
    print('Erro ao programar notificação: $e');
  }
}

/// Envia lembrete para avaliações não respondidas após 24h
Future<void> enviarLembreteAvaliacao(String tripId) async {
  try {
    // Verificar se ainda há avaliações pendentes após 24h
    final resultado = await verificarAvaliacoesPendentes(tripId);

    if (resultado['sucesso'] != true) {
      return;
    }

    final avaliacoesPendentes =
        resultado['avaliacoesPendentes'] as Map<String, dynamic>;

    // Buscar informações da viagem para o lembrete
    final tripQuery = await TripsTable().queryRows(
      queryFn: (q) => q.eq('id', tripId),
    );

    if (tripQuery.isEmpty) {
      return;
    }

    final trip = tripQuery.first;

    // Enviar lembrete se ainda há avaliações pendentes
    if (avaliacoesPendentes['motorista'] == true) {
      await NotificationsTable().insert({
        'user_id': trip.passengerId,
        'title': '🌟 Lembrete: Avalie seu motorista',
        'body':
            'Você ainda não avaliou sua última viagem. Sua opinião é importante!',
        'type': 'lembrete_avaliacao',
        'data': {
          'trip_id': tripId,
          'tipo_avaliacao': 'motorista',
          'action': 'abrir_tela_avaliacao',
        },
        'is_read': false,
        'sent_at': DateTime.now().toIso8601String(),
      });
    }

    if (avaliacoesPendentes['passageiro'] == true) {
      await NotificationsTable().insert({
        'user_id': trip.driverId,
        'title': '🌟 Lembrete: Avalie seu passageiro',
        'body':
            'Você ainda não avaliou seu último passageiro. Ajude a melhorar o serviço!',
        'type': 'lembrete_avaliacao',
        'data': {
          'trip_id': tripId,
          'tipo_avaliacao': 'passageiro',
          'action': 'abrir_tela_avaliacao',
        },
        'is_read': false,
        'sent_at': DateTime.now().toIso8601String(),
      });
    }
  } catch (e) {
    print('Erro ao enviar lembrete de avaliação: $e');
  }
}

/// Marca uma notificação como lida
Future<bool> marcarNotificacaoComoLida(String notificationId) async {
  try {
    await NotificationsTable().update(
      data: {
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      },
      matchingRows: (rows) => rows.eq('id', notificationId),
    );
    return true;
  } catch (e) {
    print('Erro ao marcar notificação como lida: $e');
    return false;
  }
}

/// Busca notificações não lidas do usuário
Future<List<NotificationsRow>> buscarNotificacoesNaoLidas(String userId) async {
  try {
    final notificacoes = await NotificationsTable().queryRows(
      queryFn: (q) => q
          .eq('user_id', userId)
          .eq('is_read', false)
          .order('created_at', ascending: false),
    );
    return notificacoes;
  } catch (e) {
    print('Erro ao buscar notificações: $e');
    return [];
  }
}
