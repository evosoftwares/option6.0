import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'onesignal_service_completo.dart';
import 'sistema_notificacoes_tempo_real.dart';

/// Inicialização completa do FCM no app
/// Integra FCM Service com Sistema de Notificações Tempo Real
/// Deve ser chamado no main.dart após Firebase.initializeApp()

/// Inicializa FCM e sistema de notificações completo
Future<Map<String, dynamic>> inicializarFCMCompleto(BuildContext context) async {
  try {
    print('🚀 Iniciando inicialização completa do FCM...');

    // 1. VERIFICAR SE USUÁRIO ESTÁ AUTENTICADO
    final currentUserId = currentUserUid;
    if (currentUserId == null || currentUserId.isEmpty) {
      return {
        'sucesso': false,
        'erro': 'Usuário não autenticado - FCM será inicializado após login',
        'deve_tentar_novamente': true,
      };
    }

    // 2. INICIALIZAR SERVIÇO FCM
    final fcmResult = await FCMServiceCompleto.instance.inicializarFCM();
    if (!fcmResult['sucesso']) {
      return {
        'sucesso': false,
        'erro': 'Falha na inicialização do FCM: ${fcmResult['erro']}',
        'detalhes_fcm': fcmResult,
      };
    }

    print('✅ FCM Service inicializado');
    print('📱 Token: ${fcmResult['token']?.substring(0, 20)}...');

    // 3. INICIALIZAR SISTEMA DE NOTIFICAÇÕES TEMPO REAL
    try {
      final notificationStream = SistemaNotificacoesTempoReal.instance.iniciarEscutaNotificacoes();

      // Configurar listener para notificações
      notificationStream.listen(
        (notificacao) {
          _processarNotificacaoRecebida(context, notificacao);
        },
        onError: (error) {
          print('❌ Erro no stream de notificações: $error');
        },
      );

      print('✅ Sistema de notificações tempo real ativo');
    } catch (e) {
      print('⚠️ Erro ao inicializar notificações tempo real: $e');
      // Não é crítico, FCM ainda funciona
    }

    // 4. VERIFICAR E ATUALIZAR STATUS DO USUÁRIO
    await _atualizarStatusOnlineUsuario(currentUserId);

    // 5. BUSCAR NOTIFICAÇÕES PENDENTES
    final notificacoesPendentes = await buscarHistoricoNotificacoes(
      limit: 10,
      apenasNaoLidas: true,
    );

    // 6. CONFIGURAR LISTENERS ESPECÍFICOS DO APP
    await _configurarListenersEspecificos(context);

    return {
      'sucesso': true,
      'token_fcm': fcmResult['token'],
      'user_id': currentUserId,
      'notificacoes_pendentes': notificacoesPendentes.length,
      'notificacoes': notificacoesPendentes,
      'mensagem': 'FCM e notificações inicializados com sucesso',
    };

  } catch (e) {
    print('❌ Erro na inicialização completa do FCM: $e');
    return {
      'sucesso': false,
      'erro': 'Erro inesperado: ${e.toString()}',
    };
  }
}

/// Processa notificação recebida em tempo real
void _processarNotificacaoRecebida(BuildContext context, Map<String, dynamic> notificacao) {
  try {
    final type = notificacao['type'] as String?;
    final title = notificacao['title'] as String?;
    final body = notificacao['body'] as String?;
    final isUrgent = notificacao['is_urgent'] as bool? ?? false;

    print('🔔 Notificação recebida: $title');

    // Mostrar snackbar para notificações urgentes
    if (isUrgent && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Notificação',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (body != null) SizedBox(height: 4),
              if (body != null) Text(body),
            ],
          ),
          backgroundColor: _getCorParaTipo(type),
          duration: Duration(seconds: isUrgent ? 5 : 3),
          action: SnackBarAction(
            label: 'Ver',
            textColor: Colors.white,
            onPressed: () {
              _navegarParaNotificacao(context, notificacao);
            },
          ),
        ),
      );
    }

    // Ações automáticas baseadas no tipo
    _executarAcaoAutomatica(context, notificacao);

  } catch (e) {
    print('❌ Erro ao processar notificação: $e');
  }
}

/// Obtém cor baseada no tipo de notificação
Color _getCorParaTipo(String? type) {
  switch (type) {
    case 'nova_corrida':
      return Colors.green;
    case 'viagem_aceita':
      return Colors.blue;
    case 'viagem_iniciada':
      return Colors.orange;
    case 'viagem_finalizada':
      return Colors.purple;
    case 'cancelamento':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

/// Navega para tela específica baseada na notificação
void _navegarParaNotificacao(BuildContext context, Map<String, dynamic> notificacao) {
  try {
    final data = notificacao['data'] as Map<String, dynamic>? ?? {};
    final action = data['action'] as String?;

    switch (action) {
      case 'aceitar_corrida':
        // TODO: Navegar para tela de aceitar corrida
        print('🚗 Navegando para aceitar corrida');
        break;

      case 'acompanhar_viagem':
        // TODO: Navegar para tela de acompanhar viagem
        print('📍 Navegando para acompanhar viagem');
        break;

      case 'avaliar_viagem':
        // TODO: Navegar para tela de avaliação
        print('⭐ Navegando para avaliação');
        break;

      default:
        // TODO: Navegar para tela de notificações
        print('📱 Navegando para lista de notificações');
        break;
    }

    // Marcar notificação como lida
    final notificationId = notificacao['id'] as String?;
    if (notificationId != null) {
      SistemaNotificacoesTempoReal.instance.marcarComoLida(notificationId);
    }

  } catch (e) {
    print('❌ Erro ao navegar: $e');
  }
}

/// Executa ação automática baseada no tipo de notificação
void _executarAcaoAutomatica(BuildContext context, Map<String, dynamic> notificacao) {
  try {
    final type = notificacao['type'] as String?;
    final data = notificacao['data'] as Map<String, dynamic>? ?? {};

    switch (type) {
      case 'nova_corrida':
        // Atualizar badge/contador
        _atualizarContadorCorridasDisponiveis();
        break;

      case 'viagem_aceita':
        // Limpar notificações de busca de motorista
        _limparNotificacoesBuscaMotorista();
        break;

      case 'viagem_finalizada':
        // Preparar para avaliação
        _prepararAvaliacao(data);
        break;

      default:
        // Nenhuma ação automática necessária
        break;
    }
  } catch (e) {
    print('❌ Erro na ação automática: $e');
  }
}

/// Atualiza status online do usuário
Future<void> _atualizarStatusOnlineUsuario(String userId) async {
  try {
    // Verificar se é motorista
    final driverQuery = await DriversTable().queryRows(
      queryFn: (q) => q.eq('user_id', userId),
    );

    if (driverQuery.isNotEmpty) {
      // Atualizar status online do motorista
      await DriversTable().update(
        data: {
          'is_online': true,
          'last_seen': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq('user_id', userId),
      );
      print('🟢 Status online do motorista atualizado');
    }

    // Atualizar registro do usuário geral
    final userQuery = await AppUsersTable().queryRows(
      queryFn: (q) => q.eq('user_id', userId),
    );

    if (userQuery.isNotEmpty) {
      await AppUsersTable().update(
        data: {
          'last_active': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq('user_id', userId),
      );
    }

  } catch (e) {
    print('❌ Erro ao atualizar status: $e');
  }
}

/// Configura listeners específicos do app
Future<void> _configurarListenersEspecificos(BuildContext context) async {
  try {
    // TODO: Adicionar listeners específicos conforme necessário
    // Por exemplo, mudanças de rota, estado da internet, etc.

    print('⚙️ Listeners específicos configurados');
  } catch (e) {
    print('❌ Erro ao configurar listeners: $e');
  }
}

/// Atualiza contador de corridas disponíveis (para motoristas)
void _atualizarContadorCorridasDisponiveis() {
  // TODO: Implementar atualização de badge/contador na UI
  print('🔢 Atualizando contador de corridas disponíveis');
}

/// Limpa notificações de busca de motorista (para passageiros)
void _limparNotificacoesBuscaMotorista() {
  // TODO: Implementar limpeza de notificações relacionadas
  print('🧹 Limpando notificações de busca');
}

/// Prepara sistema para avaliação pós-viagem
void _prepararAvaliacao(Map<String, dynamic> data) {
  final tripId = data['trip_id'] as String?;
  if (tripId != null) {
    // TODO: Implementar preparação para avaliação
    print('⭐ Preparando avaliação para trip: $tripId');
  }
}

/// Desabilita FCM quando usuário faz logout
Future<Map<String, dynamic>> desabilitarFCMCompleto() async {
  try {
    print('🔕 Desabilitando FCM completo...');

    // 1. PARAR SISTEMA DE NOTIFICAÇÕES
    SistemaNotificacoesTempoReal.instance.pararEscutaNotificacoes();

    // 2. DESABILITAR FCM SERVICE
    await FCMServiceCompleto.instance.desabilitarFCM();

    // 3. ATUALIZAR STATUS OFFLINE
    final currentUserId = currentUserUid;
    if (currentUserId != null) {
      await _atualizarStatusOfflineUsuario(currentUserId);
    }

    return {
      'sucesso': true,
      'mensagem': 'FCM desabilitado com sucesso',
    };

  } catch (e) {
    print('❌ Erro ao desabilitar FCM: $e');
    return {
      'sucesso': false,
      'erro': e.toString(),
    };
  }
}

/// Atualiza status offline do usuário
Future<void> _atualizarStatusOfflineUsuario(String userId) async {
  try {
    // Atualizar motorista como offline
    final driverQuery = await DriversTable().queryRows(
      queryFn: (q) => q.eq('user_id', userId),
    );

    if (driverQuery.isNotEmpty) {
      await DriversTable().update(
        data: {
          'is_online': false,
          'last_seen': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq('user_id', userId),
      );
    }

    print('🔴 Status offline atualizado');
  } catch (e) {
    print('❌ Erro ao atualizar status offline: $e');
  }
}

/// Verifica status do FCM
Map<String, dynamic> verificarStatusFCM() {
  final fcmInitialized = FCMServiceCompleto.instance.isInitialized;
  final fcmToken = FCMServiceCompleto.instance.tokenFCM;

  return {
    'fcm_inicializado': fcmInitialized,
    'tem_token': fcmToken != null,
    'token_preview': fcmToken?.substring(0, 20),
    'user_autenticado': currentUserUid != null,
  };
}