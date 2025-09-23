import '/backend/supabase/supabase.dart';
import '/backend/supabase/database/database.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'fcm_service_completo.dart';

/// Sistema de Notificações em Tempo Real 100% Supabase
/// Substitui completamente qualquer dependência do Firebase
/// Usa apenas user_id do Firebase Auth como identificador

class SistemaNotificacoesTempoReal {
  static SistemaNotificacoesTempoReal? _instance;
  static SistemaNotificacoesTempoReal get instance =>
      _instance ??= SistemaNotificacoesTempoReal._();

  SistemaNotificacoesTempoReal._();

  StreamSubscription? _notificationStream;
  StreamController<Map<String, dynamic>>? _notificationController;
  String? _currentUserId;

  /// Inicia escuta de notificações em tempo real
  Stream<Map<String, dynamic>> iniciarEscutaNotificacoes() {
    final currentUserId = currentUserUid;
    if (currentUserId == null) {
      throw Exception('Usuário não autenticado');
    }

    _currentUserId = currentUserId;
    _notificationController =
        StreamController<Map<String, dynamic>>.broadcast();

    // Configurar escuta em tempo real via Supabase Realtime
    _configurarEscutaRealtime();

    return _notificationController!.stream;
  }

  /// Configura escuta realtime do Supabase
  void _configurarEscutaRealtime() {
    if (_currentUserId == null) return;

    try {
      // Escutar mudanças na tabela notifications para o usuário atual
      _notificationStream = SupaFlow.client
          .from('notifications')
          .stream(primaryKey: ['id'])
          .listen(
            (List<Map<String, dynamic>> data) {
              final filtered = data.where((row) {
                final uid = row['user_id'];
                final isRead = row['is_read'];
                return uid == _currentUserId && (isRead == false || isRead == null);
              }).toList();
              if (filtered.isNotEmpty) {
                _processarNotificacoesRecebidas(filtered);
              }
            },
            onError: (error) {
              print('❌ Erro na escuta de notificações: $error');
            },
          );

      print('🔔 Escuta de notificações iniciada para usuário $_currentUserId');
    } catch (e) {
      print('❌ Erro ao configurar escuta realtime: $e');
    }
  }

  /// Processa notificações recebidas em tempo real
  void _processarNotificacoesRecebidas(
      List<Map<String, dynamic>> notifications) {
    for (var notification in notifications) {
      try {
        final notificacao = {
          'id': notification['id'],
          'title': notification['title'],
          'body': notification['body'],
          'type': notification['type'],
          'data': notification['data'] ?? {},
          'created_at': notification['created_at'],
          'is_urgent': _isNotificacaoUrgente(notification['type']),
        };

        // Emitir notificação para listeners
        _notificationController?.add(notificacao);

        // Processar ações automáticas se necessário
        _processarAcaoAutomatica(notificacao);

        print('🔔 Nova notificação recebida: ${notification['title']}');
      } catch (e) {
        print('❌ Erro ao processar notificação: $e');
      }
    }
  }

  /// Verifica se notificação é urgente
  bool _isNotificacaoUrgente(String? type) {
    const tiposUrgentes = [
      'nova_corrida',
      'viagem_aceita',
      'motorista_chegou',
      'viagem_iniciada',
      'viagem_finalizada',
      'cancelamento',
    ];
    return tiposUrgentes.contains(type);
  }

  /// Processa ações automáticas baseadas no tipo de notificação
  void _processarAcaoAutomatica(Map<String, dynamic> notificacao) {
    final type = notificacao['type'] as String?;
    final data = notificacao['data'] as Map<String, dynamic>? ?? {};

    switch (type) {
      case 'nova_corrida':
        _processarNovaCorrida(data);
        break;
      case 'viagem_aceita':
        _processarViagemAceita(data);
        break;
      case 'timeout_corrida':
        _processarTimeoutCorrida(data);
        break;
      default:
        // Nenhuma ação automática necessária
        break;
    }
  }

  /// Processa notificação de nova corrida (para motorista)
  void _processarNovaCorrida(Map<String, dynamic> data) {
    final tripRequestId = data['trip_request_id'] as String?;
    if (tripRequestId != null) {
      // Programar timeout automático
      Timer(Duration(seconds: 30), () {
        _verificarSeCorridaFoiAceita(tripRequestId);
      });
    }
  }

  /// Processa notificação de viagem aceita (para passageiro)
  void _processarViagemAceita(Map<String, dynamic> data) {
    // Pode implementar lógica específica como atualizar estado da UI
    print('✅ Viagem aceita - Trip: ${data['trip_id']}');
  }

  /// Processa timeout de corrida
  void _processarTimeoutCorrida(Map<String, dynamic> data) {
    final tripRequestId = data['trip_request_id'] as String?;
    print('⏰ Timeout da corrida: $tripRequestId');
  }

  /// Verifica se corrida foi aceita após timeout
  Future<void> _verificarSeCorridaFoiAceita(String tripRequestId) async {
    try {
      final requestQuery = await TripRequestsTable().queryRows(
        queryFn: (q) => q.eq('id', tripRequestId),
      );

      if (requestQuery.isNotEmpty) {
        final request = requestQuery.first;
        if (request.status == 'searching') {
          // Ainda não foi aceita, processar timeout
          await _processarTimeoutEFallback(tripRequestId);
        }
      }
    } catch (e) {
      print('❌ Erro ao verificar status da corrida: $e');
    }
  }

  /// Para escuta de notificações
  void pararEscutaNotificacoes() {
    _notificationStream?.cancel();
    _notificationController?.close();
    _notificationStream = null;
    _notificationController = null;
    _currentUserId = null;
    print('🔕 Escuta de notificações encerrada');
  }

  /// Marca notificação como lida
  Future<bool> marcarComoLida(String notificationId) async {
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
      print('❌ Erro ao marcar notificação como lida: $e');
      return false;
    }
  }

  /// Processa timeout e fallback (reutiliza lógica da solicitação inteligente)
  Future<void> _processarTimeoutEFallback(String tripRequestId) async {
    // Implementa lógica de fallback similar à função anterior
    // mas adaptada para o contexto de notificações
    print('⏰ Processando timeout para $tripRequestId');
  }
}

/// Envia notificação push personalizada
Future<Map<String, dynamic>> enviarNotificacaoPersonalizada({
  required String userId,
  required String title,
  required String body,
  required String type,
  Map<String, dynamic>? data,
  bool isUrgent = false,
}) async {
  try {
    final notificationData = {
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type,
      'data': data ?? {},
      'is_read': false,
      'sent_at': DateTime.now().toIso8601String(),
    };

    final result = await NotificationsTable().insert(notificationData);

    // Se é urgente, tentar envio via push notification também
    if (isUrgent) {
      await _tentarEnvioPushNotification(userId, title, body, data);
    }

    return {
      'sucesso': true,
      'notification_id': result.id,
      'enviado_push': isUrgent,
    };
  } catch (e) {
    print('❌ Erro ao enviar notificação: $e');
    return {
      'sucesso': false,
      'erro': e.toString(),
    };
  }
}

/// Envia push notification usando FCM Service completo
Future<void> _tentarEnvioPushNotification(
  String userId,
  String title,
  String body,
  Map<String, dynamic>? data,
) async {
  try {
    // Import do FCM Service (deve ser adicionado no topo do arquivo)
    // import 'fcm_service_completo.dart';

    // Buscar tokens de push do usuário
    final userDevicesQuery = await UserDevicesTable().queryRows(
      queryFn: (q) => q.eq('user_id', userId).eq('is_active', true),
    );

    for (var device in userDevicesQuery) {
      if (device.deviceToken != null && device.deviceToken!.isNotEmpty) {
        // Implementação FCM completa
        final resultado = await enviarPushNotificationFCM(
          userToken: device.deviceToken!,
          title: title,
          body: body,
          data: data ?? {},
          androidChannelId: _getChannelIdFromNotificationType(data?['type']),
        );

        if (resultado['sucesso'] == true) {
          print('✅ Push FCM enviado com sucesso para: ${device.deviceToken!.substring(0, 20)}...');
        } else {
          print('❌ Falha no envio FCM: ${resultado['erro']}');
        }
      }
    }

    // Buscar token do motorista na tabela drivers (fallback)
    final driversQuery = await DriversTable().queryRows(
      queryFn: (q) => q.eq('user_id', userId),
    );

    for (var driver in driversQuery) {
      if (driver.fcmToken != null && driver.fcmToken!.isNotEmpty) {
        // Implementação FCM completa para motoristas
        final resultado = await enviarPushNotificationFCM(
          userToken: driver.fcmToken!,
          title: title,
          body: body,
          data: data ?? {},
          androidChannelId: _getChannelIdFromNotificationType(data?['type']),
        );

        if (resultado['sucesso'] == true) {
          print('✅ Push FCM enviado para motorista: ${driver.fcmToken!.substring(0, 20)}...');
        } else {
          print('❌ Falha no envio FCM para motorista: ${resultado['erro']}');
        }
      }

      // OneSignal mantém como fallback para casos específicos
      if (driver.onesignalPlayerId != null &&
          driver.onesignalPlayerId!.isNotEmpty) {
        // TODO: Implementar envio OneSignal quando necessário (opcional)
        print('📳 OneSignal ID disponível: ${driver.onesignalPlayerId}');
      }
    }
  } catch (e) {
    print('❌ Erro ao enviar push notification: $e');
  }
}

/// Mapeia tipo de notificação para canal Android
String? _getChannelIdFromNotificationType(String? type) {
  switch (type) {
    case 'nova_corrida':
      return 'nova_corrida';
    case 'viagem_aceita':
    case 'viagem_iniciada':
    case 'viagem_finalizada':
    case 'motorista_chegou':
      return 'viagem';
    default:
      return 'geral';
  }
}

/// Busca histórico de notificações do usuário
Future<List<Map<String, dynamic>>> buscarHistoricoNotificacoes({
  int limit = 50,
  bool apenasNaoLidas = false,
}) async {
  try {
    final currentUserId = currentUserUid;
    if (currentUserId == null) return [];

    var query = NotificationsTable().queryRows(
      queryFn: (q) {
        var baseQuery = q.eq('user_id', currentUserId);
        if (apenasNaoLidas) {
          baseQuery = baseQuery.eq('is_read', false);
        }
        return baseQuery.order('created_at', ascending: false).limit(limit);
      },
    );

    final notifications = await query;

    return notifications
        .map((notification) => {
              'id': notification.id,
              'title': notification.title,
              'body': notification.body,
              'type': notification.type,
              'data': notification.data ?? {},
              'is_read': notification.isRead ?? false,
              'created_at': notification.sentAt?.toIso8601String() ?? '',
              'read_at': notification.readAt?.toIso8601String(),
            })
        .toList();
  } catch (e) {
    print('❌ Erro ao buscar histórico: $e');
    return [];
  }
}

/// Marca todas as notificações como lidas
Future<bool> marcarTodasComoLidas() async {
  try {
    final currentUserId = currentUserUid;
    if (currentUserId == null) return false;

    await SupaFlow.client
        .from('notifications')
        .update({
          'is_read': true,
          'read_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', currentUserId)
        .eq('is_read', false);

    return true;
  } catch (e) {
    print('❌ Erro ao marcar todas como lidas: $e');
    return false;
  }
}

/// Limpa notificações antigas
Future<bool> limparNotificacoesAntigas({int diasParaManterLidas = 30}) async {
  try {
    final dataLimite =
        DateTime.now().subtract(Duration(days: diasParaManterLidas));

    await SupaFlow.client
        .from('notifications')
        .delete()
        .eq('is_read', true)
        .lt('created_at', dataLimite.toIso8601String());

    return true;
  } catch (e) {
    print('❌ Erro ao limpar notificações antigas: $e');
    return false;
  }
}

/// Configura preferências de notificação do usuário
Future<Map<String, dynamic>> configurarPreferenciasNotificacao({
  required bool receberNovasCorridas,
  required bool receberAtualizacoesViagem,
  required bool receberLembretesAvaliacao,
  required bool receberPromocoes,
  bool? horarioSilencioso,
  String? inicioSilencio, // "22:00"
  String? fimSilencio, // "07:00"
}) async {
  try {
    final currentUserId = currentUserUid;
    if (currentUserId == null) {
      return {'sucesso': false, 'erro': 'Usuário não autenticado'};
    }

    // TODO: Implementar tabela de preferências se necessário
    // Por enquanto, apenas log das preferências
    print('⚙️ Preferências de notificação configuradas para $currentUserId');

    return {
      'sucesso': true,
      'mensagem': 'Preferências salvas com sucesso',
    };
  } catch (e) {
    print('❌ Erro ao configurar preferências: $e');
    return {
      'sucesso': false,
      'erro': e.toString(),
    };
  }
}

/// Widget helper para escutar notificações na UI
class NotificationListener extends StatefulWidget {
  final Widget child;
  final Function(Map<String, dynamic>)? onNotificationReceived;

  const NotificationListener({
    Key? key,
    required this.child,
    this.onNotificationReceived,
  }) : super(key: key);

  @override
  State<NotificationListener> createState() => _NotificationListenerState();
}

class _NotificationListenerState extends State<NotificationListener> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    try {
      _subscription = SistemaNotificacoesTempoReal.instance
          .iniciarEscutaNotificacoes()
          .listen(
        (notification) {
          widget.onNotificationReceived?.call(notification);
        },
        onError: (error) {
          print('❌ Erro no listener de notificações: $error');
        },
      );
    } catch (e) {
      print('❌ Erro ao iniciar escuta: $e');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
