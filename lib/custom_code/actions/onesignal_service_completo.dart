import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';

/// Serviço OneSignal Completo para Push Notifications
/// Substitui o FCMServiceCompleto removendo dependências Firebase
/// Integra OneSignal com sistema Supabase

class OneSignalServiceCompleto {
  static OneSignalServiceCompleto? _instance;
  static OneSignalServiceCompleto get instance => _instance ??= OneSignalServiceCompleto._();

  OneSignalServiceCompleto._();

  String? _playerId;
  String? _pushToken;
  bool _isInitialized = false;

  /// Inicializa o serviço OneSignal completo
  Future<Map<String, dynamic>> inicializarOneSignal(String appId) async {
    try {
      if (_isInitialized) {
        return {
          'sucesso': true,
          'mensagem': 'OneSignal já estava inicializado',
          'playerId': _playerId,
          'token': _pushToken,
        };
      }

      print('🔔 [OneSignal] Inicializando OneSignal Service Completo...');

      // 1. INICIALIZAR ONESIGNAL
      OneSignal.initialize(appId);

      // 2. SOLICITAR PERMISSÕES
      final permissionGranted = await OneSignal.Notifications.requestPermission(true);
      if (!permissionGranted) {
        return {
          'sucesso': false,
          'erro': 'Permissões de notificação negadas',
        };
      }

      // 3. CONFIGURAR HANDLERS
      await _configurarHandlers();

      // 4. OBTER PLAYER ID E TOKEN
      await _obterIdentificadores();

      // 5. SALVAR NO SUPABASE
      await _salvarTokenNoSupabase();

      _isInitialized = true;

      print('✅ [OneSignal] Service Completo inicializado com sucesso');
      return {
        'sucesso': true,
        'mensagem': 'OneSignal inicializado com sucesso',
        'playerId': _playerId,
        'token': _pushToken,
      };

    } catch (e) {
      print('❌ [OneSignal] Erro na inicialização: $e');
      return {
        'sucesso': false,
        'erro': 'Erro na inicialização do OneSignal',
        'detalhes': e.toString(),
      };
    }
  }

  /// Configura os handlers de notificação
  Future<void> _configurarHandlers() async {
    // Handler para quando app está em foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('🔔 [OneSignal] Notificação recebida em foreground: ${event.notification.title}');
      // Permitir que a notificação seja exibida
      event.preventDefault();
      event.notification.display();
    });

    // Handler para quando usuário clica na notificação
    OneSignal.Notifications.addClickListener((event) {
      print('🔔 [OneSignal] Notificação clicada: ${event.notification.title}');
      _processarClique(event.notification);
    });

    // Handler para mudanças de permissão
    OneSignal.Notifications.addPermissionObserver((state) {
      print('🔔 [OneSignal] Permissão alterada: $state');
    });

    // Handler para mudanças de subscription
    OneSignal.User.pushSubscription.addObserver((state) {
      print('🔔 [OneSignal] Subscription alterada: ${state.current.id}');
      _playerId = state.current.id;
      _pushToken = state.current.token;
      _salvarTokenNoSupabase();
    });
  }

  /// Obtém identificadores do OneSignal
  Future<void> _obterIdentificadores() async {
    try {
      // Obter Player ID
      _playerId = await OneSignal.User.getOnesignalId();
      
      // Obter Push Token
      final subscription = OneSignal.User.pushSubscription;
      _pushToken = subscription.token;

      print('🔔 [OneSignal] Player ID: $_playerId');
      print('🔔 [OneSignal] Push Token: $_pushToken');
    } catch (e) {
      print('❌ [OneSignal] Erro ao obter identificadores: $e');
    }
  }

  /// Salva o token no Supabase
  Future<void> _salvarTokenNoSupabase() async {
    try {
      final userId = currentUserUid;
      if (userId == null || _playerId == null) {
        print('⚠️ [OneSignal] Usuário não logado ou Player ID não disponível');
        return;
      }

      // Atualizar tabela app_users com o player_id do OneSignal
      await SupaFlow.client.from('app_users').update({
        'onesignal_player_id': _playerId,
        'push_token': _pushToken,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId);

      print('✅ [OneSignal] Token salvo no Supabase para usuário: $userId');

    } catch (e) {
      print('❌ [OneSignal] Erro ao salvar token no Supabase: $e');
    }
  }

  /// Processa clique na notificação
  void _processarClique(OSNotification notification) {
    try {
      final additionalData = notification.additionalData;
      if (additionalData != null) {
        // Processar dados adicionais da notificação
        final tipo = additionalData['tipo'] as String?;
        final dados = additionalData['dados'] as Map<String, dynamic>?;

        print('🔔 [OneSignal] Processando clique - Tipo: $tipo, Dados: $dados');

        // Navegar baseado no tipo de notificação
        switch (tipo) {
          case 'nova_viagem':
            _navegarParaViagem(dados);
            break;
          case 'viagem_aceita':
            _navegarParaViagemAceita(dados);
            break;
          case 'viagem_cancelada':
            _navegarParaHistorico();
            break;
          default:
            print('⚠️ [OneSignal] Tipo de notificação não reconhecido: $tipo');
        }
      }
    } catch (e) {
      print('❌ [OneSignal] Erro ao processar clique: $e');
    }
  }

  /// Navega para tela de viagem
  void _navegarParaViagem(Map<String, dynamic>? dados) {
    // TODO: Implementar navegação para tela de viagem
    print('🔔 [OneSignal] Navegando para viagem: $dados');
  }

  /// Navega para tela de viagem aceita
  void _navegarParaViagemAceita(Map<String, dynamic>? dados) {
    // TODO: Implementar navegação para viagem aceita
    print('🔔 [OneSignal] Navegando para viagem aceita: $dados');
  }

  /// Navega para histórico
  void _navegarParaHistorico() {
    // TODO: Implementar navegação para histórico
    print('🔔 [OneSignal] Navegando para histórico');
  }

  /// Envia notificação para usuário específico
  Future<Map<String, dynamic>> enviarNotificacao({
    required String playerId,
    required String titulo,
    required String mensagem,
    Map<String, dynamic>? dadosAdicionais,
  }) async {
    try {
      // OneSignal não permite envio direto do app
      // Deve ser feito via API REST ou dashboard
      print('⚠️ [OneSignal] Envio de notificação deve ser feito via API REST');
      
      return {
        'sucesso': false,
        'erro': 'Envio deve ser feito via API REST do OneSignal',
        'playerId': playerId,
      };

    } catch (e) {
      print('❌ [OneSignal] Erro ao enviar notificação: $e');
      return {
        'sucesso': false,
        'erro': 'Erro ao enviar notificação',
        'detalhes': e.toString(),
      };
    }
  }

  /// Define tags do usuário
  Future<void> definirTags(Map<String, String> tags) async {
    try {
      OneSignal.User.addTags(tags);
      print('✅ [OneSignal] Tags definidas: $tags');
    } catch (e) {
      print('❌ [OneSignal] Erro ao definir tags: $e');
    }
  }

  /// Define external user ID
  Future<void> definirExternalUserId(String externalUserId) async {
    try {
      OneSignal.User.addAlias('external_id', externalUserId);
      print('✅ [OneSignal] External User ID definido: $externalUserId');
    } catch (e) {
      print('❌ [OneSignal] Erro ao definir External User ID: $e');
    }
  }

  /// Remove external user ID
  Future<void> removerExternalUserId() async {
    try {
      OneSignal.User.removeAlias('external_id');
      print('✅ [OneSignal] External User ID removido');
    } catch (e) {
      print('❌ [OneSignal] Erro ao remover External User ID: $e');
    }
  }

  /// Obtém status de permissão
  Future<bool> obterStatusPermissao() async {
    try {
      final permission = await OneSignal.Notifications.permission;
      return permission;
    } catch (e) {
      print('❌ [OneSignal] Erro ao obter status de permissão: $e');
      return false;
    }
  }

  /// Getters
  String? get playerId => _playerId;
  String? get pushToken => _pushToken;
  bool get isInitialized => _isInitialized;
}

/// Função global para compatibilidade com código existente
Future<Map<String, dynamic>> inicializarOneSignalCompleto(String appId) async {
  return await OneSignalServiceCompleto.instance.inicializarOneSignal(appId);
}