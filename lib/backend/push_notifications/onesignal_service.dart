import 'dart:async';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../flutter_flow/flutter_flow_util.dart';

/// Serviço OneSignal para gerenciar notificações push
/// Substitui o Firebase Cloud Messaging
class OneSignalService {
  static OneSignalService? _instance;
  static OneSignalService get instance => _instance ??= OneSignalService._();
  
  OneSignalService._();

  bool _initialized = false;
  String? _playerId;
  String? _pushToken;

  /// Inicializa o OneSignal
  /// [appId] - ID do app OneSignal (obter do dashboard)
  Future<void> initialize(String appId) async {
    if (_initialized) return;

    try {
      print('🔔 [OneSignal] Inicializando OneSignal...');
      
      // Remove this method to stop OneSignal Debugging
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      // OneSignal Initialization
      OneSignal.initialize(appId);

      // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. 
      // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
      OneSignal.Notifications.requestPermission(true);

      // Setup notification handlers
      _setupNotificationHandlers();

      // Get player ID
      final status = await OneSignal.User.getOnesignalId();
      _playerId = status;
      
      // Get push token
      final pushSubscription = OneSignal.User.pushSubscription;
      _pushToken = pushSubscription.token;

      _initialized = true;
      print('✅ [OneSignal] Inicializado com sucesso');
      print('📱 [OneSignal] Player ID: $_playerId');
      print('🔑 [OneSignal] Push Token: $_pushToken');

    } catch (e) {
      print('❌ [OneSignal] Erro na inicialização: $e');
      rethrow;
    }
  }

  /// Configura os handlers de notificação
  void _setupNotificationHandlers() {
    // Handle notification opened
    OneSignal.Notifications.addClickListener((event) {
      print('🔔 [OneSignal] Notificação clicada: ${event.notification.notificationId}');
      _handleNotificationOpened(event.notification);
    });

    // Handle notification received while app is in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('🔔 [OneSignal] Notificação recebida em foreground: ${event.notification.notificationId}');
      // Display the notification
      event.preventDefault();
      event.notification.display();
    });

    // Handle permission changes
    OneSignal.Notifications.addPermissionObserver((state) {
      print('🔔 [OneSignal] Permissão alterada: $state');
    });

    // Handle subscription changes
    OneSignal.User.pushSubscription.addObserver((state) {
      print('🔔 [OneSignal] Subscription alterada: ${state.current.id}');
      _pushToken = state.current.token;
    });
  }

  /// Manipula notificação aberta
  void _handleNotificationOpened(OSNotification notification) {
    try {
      final additionalData = notification.additionalData;
      
      if (additionalData != null) {
        final initialPageName = additionalData['initialPageName'] as String?;
        final parameterData = additionalData['parameterData'] as String?;
        
        if (initialPageName != null) {
          print('🔔 [OneSignal] Navegando para: $initialPageName');
          
          // Parse parameter data if available
          Map<String, dynamic> params = {};
          if (parameterData != null && parameterData.isNotEmpty) {
            try {
              params = jsonDecode(parameterData) as Map<String, dynamic>;
            } catch (e) {
              print('⚠️ [OneSignal] Erro ao parsear parâmetros: $e');
            }
          }
          
          // Navigate to the specified page
          _navigateToPage(initialPageName, params);
        }
      }
    } catch (e) {
      print('❌ [OneSignal] Erro ao processar notificação: $e');
    }
  }

  /// Navega para uma página específica
  void _navigateToPage(String pageName, Map<String, dynamic> params) {
    try {
      final context = appNavigatorKey.currentContext;
      if (context != null) {
        // Use GoRouter para navegação
        context.pushNamed(pageName, extra: params);
      } else {
        print('⚠️ [OneSignal] Contexto de navegação não disponível');
      }
    } catch (e) {
      print('❌ [OneSignal] Erro na navegação: $e');
    }
  }

  /// Obtém o Player ID do OneSignal
  String? get playerId => _playerId;

  /// Obtém o Push Token
  String? get pushToken => _pushToken;

  /// Verifica se está inicializado
  bool get isInitialized => _initialized;

  /// Define tags do usuário
  Future<void> setUserTags(Map<String, String> tags) async {
    if (!_initialized) {
      print('⚠️ [OneSignal] Serviço não inicializado');
      return;
    }

    try {
      OneSignal.User.addTags(tags);
      print('✅ [OneSignal] Tags definidas: $tags');
    } catch (e) {
      print('❌ [OneSignal] Erro ao definir tags: $e');
    }
  }

  /// Remove tags do usuário
  Future<void> removeUserTags(List<String> tagKeys) async {
    if (!_initialized) {
      print('⚠️ [OneSignal] Serviço não inicializado');
      return;
    }

    try {
      OneSignal.User.removeTags(tagKeys);
      print('✅ [OneSignal] Tags removidas: $tagKeys');
    } catch (e) {
      print('❌ [OneSignal] Erro ao remover tags: $e');
    }
  }

  /// Define o ID externo do usuário (Supabase UID)
  Future<void> setExternalUserId(String externalId) async {
    if (!_initialized) {
      print('⚠️ [OneSignal] Serviço não inicializado');
      return;
    }

    try {
      OneSignal.login(externalId);
      print('✅ [OneSignal] External User ID definido: $externalId');
    } catch (e) {
      print('❌ [OneSignal] Erro ao definir External User ID: $e');
    }
  }

  /// Remove o ID externo do usuário (logout)
  Future<void> removeExternalUserId() async {
    if (!_initialized) {
      print('⚠️ [OneSignal] Serviço não inicializado');
      return;
    }

    try {
      OneSignal.logout();
      print('✅ [OneSignal] External User ID removido');
    } catch (e) {
      print('❌ [OneSignal] Erro ao remover External User ID: $e');
    }
  }

  /// Solicita permissão para notificações
  Future<bool> requestPermission() async {
    if (!_initialized) {
      print('⚠️ [OneSignal] Serviço não inicializado');
      return false;
    }

    try {
      final permission = await OneSignal.Notifications.requestPermission(true);
      print('✅ [OneSignal] Permissão solicitada: $permission');
      return permission;
    } catch (e) {
      print('❌ [OneSignal] Erro ao solicitar permissão: $e');
      return false;
    }
  }

  /// Verifica se as notificações estão habilitadas
  Future<bool> areNotificationsEnabled() async {
    if (!_initialized) {
      print('⚠️ [OneSignal] Serviço não inicializado');
      return false;
    }

    try {
      final permission = await OneSignal.Notifications.permission;
      return permission;
    } catch (e) {
      print('❌ [OneSignal] Erro ao verificar permissões: $e');
      return false;
    }
  }

  /// Envia dados do usuário para o Supabase
  Future<void> syncUserDataWithSupabase(String supabaseUserId) async {
    if (!_initialized || _playerId == null) {
      print('⚠️ [OneSignal] Serviço não inicializado ou Player ID não disponível');
      return;
    }

    try {
      // TODO: Implementar sincronização com Supabase
      // Salvar playerId e pushToken na tabela user_devices
      print('🔄 [OneSignal] Sincronizando dados com Supabase...');
      print('👤 [OneSignal] Supabase User ID: $supabaseUserId');
      print('📱 [OneSignal] Player ID: $_playerId');
      print('🔑 [OneSignal] Push Token: $_pushToken');
      
      // Aqui você pode implementar a lógica para salvar no Supabase
      // await SupabaseService.instance.updateUserDevice(
      //   userId: supabaseUserId,
      //   playerId: _playerId!,
      //   pushToken: _pushToken,
      // );
      
    } catch (e) {
      print('❌ [OneSignal] Erro na sincronização com Supabase: $e');
    }
  }
}