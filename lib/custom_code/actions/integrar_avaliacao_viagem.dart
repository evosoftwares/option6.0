import '/backend/supabase/supabase.dart';
import '/backend/supabase/database/database.dart';
import '/custom_code/actions/notificar_avaliacao_pendente.dart' as notifications;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/nav/nav.dart';

/// Integração do Sistema de Avaliação com Fluxo de Viagens
/// Funções para facilitar a integração com o processo existente de viagens

/// Deve ser chamado quando uma viagem é finalizada (status muda para 'completed')
Future<Map<String, dynamic>> finalizarViagemComAvaliacao(
  String tripId,
  BuildContext context,
) async {
  try {
    // 1. Atualizar status da viagem para completed (se ainda não estiver)
    await TripsTable().update(
      data: {
        'status': 'completed',
        'trip_completed_at': DateTime.now().toIso8601String(),
      },
      matchingRows: (rows) => rows.eq('id', tripId),
    );

    // 2. Aguardar 5 segundos antes de verificar avaliações
    await Future.delayed(Duration(seconds: 5));

    // 3. Verificar e programar notificações para avaliações pendentes
    final resultadoNotificacoes = await notifications.verificarAvaliacoesPendentes(tripId);

    // 4. Programar lembrete para 24h depois
    _programarLembreteApos24h(tripId);

    return {
      'sucesso': true,
      'viagem_finalizada': true,
      'notificacoes_programadas': resultadoNotificacoes['sucesso'] == true,
      'detalhes_notificacoes': resultadoNotificacoes,
    };

  } catch (e) {
    return {
      'sucesso': false,
      'erro': 'Erro ao finalizar viagem: ${e.toString()}',
    };
  }
}

/// Navega para a tela de avaliação apropriada
Future<void> navegarParaTelaAvaliacao(
  BuildContext context,
  String tripId,
  String tipoAvaliacao, // 'motorista' ou 'passageiro'
  {
    String? nomeUsuario,
    String? infoAdicional,
  }
) async {
  try {
    if (tipoAvaliacao == 'motorista') {
      // Navegar para avaliação do motorista (passageiro avalia)
      GoRouter.of(context).pushNamed(
        'avaliarMotorista',
        pathParameters: {'tripId': tripId},
        queryParameters: {
          if (nomeUsuario != null) 'motoristaNome': nomeUsuario,
          if (infoAdicional != null) 'veiculoInfo': infoAdicional,
        },
      );
    } else if (tipoAvaliacao == 'passageiro') {
      // Navegar para avaliação do passageiro (motorista avalia)
      GoRouter.of(context).pushNamed(
        'avaliarPassageiro',
        pathParameters: {'tripId': tripId},
        queryParameters: {
          if (nomeUsuario != null) 'passageiroNome': nomeUsuario,
          if (infoAdicional != null) 'origemDestino': infoAdicional,
        },
      );
    }
  } catch (e) {
    print('Erro ao navegar para tela de avaliação: $e');
  }
}

/// Verifica se o usuário atual pode avaliar uma viagem específica
Future<Map<String, dynamic>> verificarPermissaoAvaliacao(
  String tripId,
  String currentUserId,
  String tipoUsuario, // 'driver' ou 'passageiro'
) async {
  try {
    // 1. Buscar informações da viagem
    final tripQuery = await TripsTable().queryRows(
      queryFn: (q) => q.eq('id', tripId),
    );

    if (tripQuery.isEmpty) {
      return {
        'pode_avaliar': false,
        'motivo': 'Viagem não encontrada',
      };
    }

    final trip = tripQuery.first;

    // 2. Verificar se o usuário atual participou da viagem
    bool usuarioParticipou = false;
    String tipoAvaliacaoPermitida = '';

    if (tipoUsuario == 'driver' && trip.driverId == currentUserId) {
      usuarioParticipou = true;
      tipoAvaliacaoPermitida = 'passageiro'; // Driver avalia passageiro
    } else if (tipoUsuario == 'passenger' && trip.passengerId == currentUserId) {
      usuarioParticipou = true;
      tipoAvaliacaoPermitida = 'motorista'; // Passageiro avalia motorista
    }

    if (!usuarioParticipou) {
      return {
        'pode_avaliar': false,
        'motivo': 'Usuário não participou desta viagem',
      };
    }

    // 3. Verificar se a viagem foi completada
    if (trip.status != 'completed') {
      return {
        'pode_avaliar': false,
        'motivo': 'Viagem ainda não foi finalizada',
      };
    }

    // 4. Verificar se já foi avaliado
    final existingRatings = await RatingsTable().queryRows(
      queryFn: (q) => q.eq('trip_id', tripId),
    );

    bool jaAvaliou = false;
    if (existingRatings.isNotEmpty) {
      final rating = existingRatings.first;
      if (tipoAvaliacaoPermitida == 'motorista') {
        jaAvaliou = rating.driverRating != null;
      } else {
        jaAvaliou = rating.passengerRating != null;
      }
    }

    return {
      'pode_avaliar': !jaAvaliou,
      'motivo': jaAvaliou ? 'Já foi avaliado anteriormente' : null,
      'tipo_avaliacao': tipoAvaliacaoPermitida,
      'info_viagem': {
        'origem': trip.originAddress,
        'destino': trip.destinationAddress,
        'data_conclusao': trip.tripCompletedAt,
      },
    };

  } catch (e) {
    return {
      'pode_avaliar': false,
      'motivo': 'Erro ao verificar permissões: ${e.toString()}',
    };
  }
}

/// Busca estatísticas de avaliação do usuário
Future<Map<String, dynamic>> obterEstatisticasAvaliacao(
  String userId,
  String tipoUsuario, // 'driver' ou 'passageiro'
) async {
  try {
    if (tipoUsuario == 'driver') {
      // Estatísticas do motorista
      final driverQuery = await DriversTable().queryRows(
        queryFn: (q) => q.eq('user_id', userId),
      );

      if (driverQuery.isNotEmpty) {
        final driver = driverQuery.first;
        return {
          'rating_medio': driver.averageRating ?? 0.0,
          'total_viagens': driver.totalTrips ?? 0,
          'tipo_usuario': 'motorista',
        };
      }
    } else {
      // Estatísticas do passageiro
      final passengerQuery = await PassengersTable().queryRows(
        queryFn: (q) => q.eq('user_id', userId),
      );

      if (passengerQuery.isNotEmpty) {
        final passenger = passengerQuery.first;
        return {
          'rating_medio': passenger.averageRating ?? 0.0,
          'total_viagens': passenger.totalTrips ?? 0,
          'tipo_usuario': 'passageiro',
        };
      }
    }

    return {
      'rating_medio': 0.0,
      'total_viagens': 0,
      'tipo_usuario': tipoUsuario,
    };

  } catch (e) {
    return {
      'rating_medio': 0.0,
      'total_viagens': 0,
      'erro': e.toString(),
    };
  }
}

/// Programa lembrete de avaliação para 24h depois
void _programarLembreteApos24h(String tripId) {
  Future.delayed(Duration(hours: 24), () async {
    await notifications.enviarLembreteAvaliacao(tripId);
  });
}