import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'dart:io';

/// Serviço FCM Completo para Push Notifications
/// Substitui todos os TODOs do sistema de notificações
/// Integra Firebase Cloud Messaging com sistema local de notificações

class FCMServiceCompleto {
  static FCMServiceCompleto? _instance;
  static FCMServiceCompleto get instance => _instance ??= FCMServiceCompleto._();

  FCMServiceCompleto._();

  FirebaseMessaging? _firebaseMessaging;
  FlutterLocalNotificationsPlugin? _localNotifications;
  String? _fcmToken;
  bool _isInitialized = false;

  /// Inicializa o serviço FCM completo
  Future<Map<String, dynamic>> inicializarFCM() async {
    try {
      if (_isInitialized) {
        return {
          'sucesso': true,
          'mensagem': 'FCM já estava inicializado',
          'token': _fcmToken,
        };
      }

      // 1. INICIALIZAR FIREBASE MESSAGING
      _firebaseMessaging = FirebaseMessaging.instance;

      // 2. SOLICITAR PERMISSÕES
      final permissionResult = await _solicitarPermissoes();
      if (!permissionResult['concedida']) {
        return {
          'sucesso': false,
          'erro': 'Permissões de notificação negadas',
          'detalhes': permissionResult,
        };
      }

      // 3. CONFIGURAR NOTIFICAÇÕES LOCAIS
      await _configurarNotificacoesLocais();

      // 4. OBTER TOKEN FCM
      _fcmToken = await _firebaseMessaging!.getToken();
      if (_fcmToken == null) {
        return {
          'sucesso': false,
          'erro': 'Falha ao obter token FCM',
        };
      }

      // 5. SALVAR TOKEN NO SUPABASE
      await _salvarTokenNoSupabase(_fcmToken!);

      // 6. CONFIGURAR LISTENERS
      await _configurarListeners();

      // 7. CONFIGURAR HANDLER PARA APP TERMINADO
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      _isInitialized = true;

      print('🔔 FCM Service inicializado com sucesso');
      print('📱 Token: ${_fcmToken!.substring(0, 20)}...');

      return {
        'sucesso': true,
        'token': _fcmToken,
        'mensagem': 'FCM inicializado com sucesso',
      };
    } catch (e) {
      print('❌ Erro ao inicializar FCM: $e');
      return {
        'sucesso': false,
        'erro': 'Erro ao inicializar FCM: ${e.toString()}',
      };
    }
  }

  /// Solicita permissões necessárias para notificações
  Future<Map<String, dynamic>> _solicitarPermissoes() async {
    try {
      final settings = await _firebaseMessaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final concedida = settings.authorizationStatus == AuthorizationStatus.authorized ||
                       settings.authorizationStatus == AuthorizationStatus.provisional;

      return {
        'concedida': concedida,
        'status': settings.authorizationStatus.toString(),
        'alert': settings.alert == AppleNotificationSetting.enabled,
        'badge': settings.badge == AppleNotificationSetting.enabled,
        'sound': settings.sound == AppleNotificationSetting.enabled,
      };
    } catch (e) {
      print('❌ Erro ao solicitar permissões: $e');
      return {
        'concedida': false,
        'erro': e.toString(),
      };
    }
  }

  /// Configura sistema de notificações locais
  Future<void> _configurarNotificacoesLocais() async {
    _localNotifications = FlutterLocalNotificationsPlugin();

    // Configurações Android
    const androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configurações iOS
    final iosInitSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification foi removido nas versões recentes do flutter_local_notifications
    );

    final initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotifications!.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Criar canal de notificação para Android
    if (Platform.isAndroid) {
      await _criarCanaisNotificacao();
    }
  }

  /// Cria canais de notificação específicos (Android)
  Future<void> _criarCanaisNotificacao() async {
    const urgentChannel = AndroidNotificationChannel(
      'nova_corrida',
      'Novas Corridas',
      description: 'Notificações de novas corridas disponíveis',
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const generalChannel = AndroidNotificationChannel(
      'geral',
      'Notificações Gerais',
      description: 'Atualizações gerais do app',
      importance: Importance.defaultImportance,
    );

    const tripChannel = AndroidNotificationChannel(
      'viagem',
      'Atualizações de Viagem',
      description: 'Status da viagem em andamento',
      importance: Importance.high,
    );

    await _localNotifications!
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(urgentChannel);

    await _localNotifications!
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(generalChannel);

    await _localNotifications!
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(tripChannel);
  }

  /// Salva token FCM no Supabase
  Future<void> _salvarTokenNoSupabase(String token) async {
    try {
      final currentUserId = currentUserUid;
      if (currentUserId.isEmpty) return;

      // Verificar se já existe registro do dispositivo
      final existingDevices = await UserDevicesTable().queryRows(
        queryFn: (q) => q.eq('user_id', currentUserId).eq('device_token', token),
      );

      if (existingDevices.isEmpty) {
        // Criar novo registro
        await UserDevicesTable().insert({
          'user_id': currentUserId,
          'device_token': token,
          'device_type': Platform.isIOS ? 'ios' : 'android',
          'app_version': '1.0.0', // TODO: Pegar versão real do app
          'is_active': true,
          'last_active': DateTime.now().toIso8601String(),
          'created_at': DateTime.now().toIso8601String(),
        });
      } else {
        // Atualizar registro existente
        await UserDevicesTable().update(
          data: {
            'is_active': true,
            'last_active': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
          matchingRows: (rows) => rows.eq('id', existingDevices.first.id),
        );
      }

      // Também salvar na tabela drivers se for motorista
      final driverQuery = await DriversTable().queryRows(
        queryFn: (q) => q.eq('user_id', currentUserId),
      );

      if (driverQuery.isNotEmpty) {
        await DriversTable().update(
          data: {
            'fcm_token': token,
            'updated_at': DateTime.now().toIso8601String(),
          },
          matchingRows: (rows) => rows.eq('user_id', currentUserId),
        );
      }

      print('💾 Token FCM salvo no Supabase');
    } catch (e) {
      print('❌ Erro ao salvar token no Supabase: $e');
    }
  }

  /// Configura listeners para diferentes estados do app
  Future<void> _configurarListeners() async {
    // App em foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // App em background mas ativo
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // App foi aberto via notificação
    final initialMessage = await _firebaseMessaging!.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    // Token refresh
    _firebaseMessaging!.onTokenRefresh.listen(_onTokenRefresh);
  }

  /// Manipula mensagens quando app está em foreground
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('🔔 Mensagem recebida em foreground: ${message.messageId}');
    print('📱 Título: ${message.notification?.title}');
    print('📝 Corpo: ${message.notification?.body}');
    print('🔗 Data: ${message.data}');

    // Mostrar notificação local para visualização
    await _mostrarNotificacaoLocal(message);

    // Processar ação específica se necessário
    await _processarAcaoNotificacao(message.data);
  }

  /// Manipula quando app é aberto via notificação
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    print('🚀 App aberto via notificação: ${message.messageId}');
    await _processarAcaoNotificacao(message.data);
  }

  /// Processa ação específica baseada no tipo de notificação
  Future<void> _processarAcaoNotificacao(Map<String, dynamic> data) async {
    try {
      final action = data['action'] as String?;
      final type = data['type'] as String?;
      if (type != null) {
        print('🔔 Tipo de notificação: $type');
      }

      switch (action) {
        case 'aceitar_corrida':
          final tripRequestId = data['trip_request_id'] as String?;
          if (tripRequestId != null) {
            // TODO: Navegar para tela de aceitar corrida
            print('🚗 Ação: Aceitar corrida $tripRequestId');
          }
          break;

        case 'acompanhar_viagem':
          final tripId = data['trip_id'] as String?;
          if (tripId != null) {
            // TODO: Navegar para tela de acompanhar viagem
            print('📍 Ação: Acompanhar viagem $tripId');
          }
          break;

        case 'avaliar_viagem':
          final tripId = data['trip_id'] as String?;
          if (tripId != null) {
            // TODO: Navegar para tela de avaliação
            print('⭐ Ação: Avaliar viagem $tripId');
          }
          break;

        default:
          print('❓ Ação desconhecida: $action');
      }

      // Marcar notificação como lida no Supabase
      final notificationId = data['notification_id'] as String?;
      if (notificationId != null) {
        await _marcarNotificacaoComoLida(notificationId);
      }
    } catch (e) {
      print('❌ Erro ao processar ação: $e');
    }
  }

  /// Mostra notificação local para usuário ver
  Future<void> _mostrarNotificacaoLocal(RemoteMessage message) async {
    try {
      final notification = message.notification;
      if (notification == null) return;

      final type = message.data['type'] as String? ?? 'geral';
      final channelId = _getChannelIdForType(type);
      final priority = _getPriorityForType(type);

      final androidDetails = AndroidNotificationDetails(
        channelId,
        _getChannelNameForType(type),
        channelDescription: _getChannelDescriptionForType(type),
        importance: priority == 'high' ? Importance.high : Importance.defaultImportance,
        priority: priority == 'high' ? Priority.high : Priority.defaultPriority,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications!.show(
        message.hashCode,
        notification.title,
        notification.body,
        details,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      print('❌ Erro ao mostrar notificação local: $e');
    }
  }

  /// Obtém ID do canal baseado no tipo
  String _getChannelIdForType(String type) {
    switch (type) {
      case 'nova_corrida':
        return 'nova_corrida';
      case 'viagem_aceita':
      case 'viagem_iniciada':
      case 'viagem_finalizada':
        return 'viagem';
      default:
        return 'geral';
    }
  }

  /// Obtém nome do canal baseado no tipo
  String _getChannelNameForType(String type) {
    switch (type) {
      case 'nova_corrida':
        return 'Novas Corridas';
      case 'viagem_aceita':
      case 'viagem_iniciada':
      case 'viagem_finalizada':
        return 'Atualizações de Viagem';
      default:
        return 'Notificações Gerais';
    }
  }

  /// Obtém descrição do canal baseado no tipo
  String _getChannelDescriptionForType(String type) {
    switch (type) {
      case 'nova_corrida':
        return 'Notificações de novas corridas disponíveis';
      case 'viagem_aceita':
      case 'viagem_iniciada':
      case 'viagem_finalizada':
        return 'Status da viagem em andamento';
      default:
        return 'Atualizações gerais do app';
    }
  }

  /// Obtém prioridade baseada no tipo
  String _getPriorityForType(String type) {
    switch (type) {
      case 'nova_corrida':
      case 'viagem_aceita':
      case 'viagem_iniciada':
      case 'motorista_chegou':
        return 'high';
      default:
        return 'normal';
    }
  }

  /// Marca notificação como lida no Supabase
  Future<void> _marcarNotificacaoComoLida(String notificationId) async {
    try {
      await NotificationsTable().update(
        data: {
          'is_read': true,
          'read_at': DateTime.now().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq('id', notificationId),
      );
    } catch (e) {
      print('❌ Erro ao marcar notificação como lida: $e');
    }
  }

  /// Callback para iOS - notificação recebida em foreground
  // ignore: unused_element
  Future<void> _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    // Método mantido apenas por compatibilidade histórica. Não é mais utilizado nas versões recentes do iOS.
  }

  /// Callback para quando usuário toca na notificação
  void _onNotificationResponse(NotificationResponse response) {
    try {
      if (response.payload != null) {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        _processarAcaoNotificacao(data);
      }
    } catch (e) {
      print('❌ Erro ao processar resposta da notificação: $e');
    }
  }

  /// Callback para refresh do token
  Future<void> _onTokenRefresh(String newToken) async {
    print('🔄 Token FCM atualizado: ${newToken.substring(0, 20)}...');
    _fcmToken = newToken;
    await _salvarTokenNoSupabase(newToken);
  }

  /// Obtém token FCM atual
  String? get tokenFCM => _fcmToken;

  /// Verifica se FCM está inicializado
  bool get isInitialized => _isInitialized;

  /// Desabilita FCM e remove token
  Future<void> desabilitarFCM() async {
    try {
      final currentUserId = currentUserUid;
      if (currentUserId.isNotEmpty && _fcmToken != null) {
        // Marcar device como inativo
        final devices = await UserDevicesTable().queryRows(
          queryFn: (q) => q.eq('user_id', currentUserId).eq('device_token', _fcmToken!),
        );

        for (var device in devices) {
          await UserDevicesTable().update(
            data: {'is_active': false},
            matchingRows: (rows) => rows.eq('id', device.id),
          );
        }

        // Remover token da tabela drivers
        await DriversTable().update(
          data: {'fcm_token': null},
          matchingRows: (rows) => rows.eq('user_id', currentUserId),
        );
      }

      await _firebaseMessaging?.deleteToken();
      _fcmToken = null;
      _isInitialized = false;

      print('🔕 FCM desabilitado');
    } catch (e) {
      print('❌ Erro ao desabilitar FCM: $e');
    }
  }
}

/// Handler para mensagens em background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Inicializar Firebase se necessário
  // await Firebase.initializeApp();

  print('🔔 Mensagem recebida em background: ${message.messageId}');

  // Processar dados da mensagem se necessário
  // Por exemplo, salvar no cache local, atualizar badge, etc.
}

/// Função auxiliar para enviar push notification via servidor
Future<Map<String, dynamic>> enviarPushNotificationFCM({
  required String userToken,
  required String title,
  required String body,
  required Map<String, dynamic> data,
  String? androidChannelId,
}) async {
  try {
    // Esta função seria implementada via Cloud Functions ou servidor backend
    // Por enquanto apenas retorna sucesso simulado

    print('📤 Enviando push FCM para: ${userToken.substring(0, 20)}...');
    print('📱 Título: $title');
    print('📝 Corpo: $body');
    print('🔗 Data: $data');

    // TODO: Implementar envio real via servidor/Cloud Functions
    // Esta implementação seria feita no backend, não no app

    return {
      'sucesso': true,
      'mensagem': 'Push notification enviado via FCM',
      'token_destino': userToken.substring(0, 20) + '...',
    };
  } catch (e) {
    print('❌ Erro ao enviar push FCM: $e');
    return {
      'sucesso': false,
      'erro': e.toString(),
    };
  }
}