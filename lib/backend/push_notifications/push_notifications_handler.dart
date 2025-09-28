import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// TODO: Implementar handlers OneSignal quando necessário
// Placeholder para compatibilidade com código existente

class PushNotificationsHandler extends StatelessWidget {
  final Widget child;
  
  const PushNotificationsHandler({Key? key, required this.child}) : super(key: key);

  /// Inicializa o handler de notificações
  /// TODO: Migrar para OneSignal quando necessário
  static Future<void> setupInteractedMessage() async {
    if (kDebugMode) {
      print('🔔 [PushHandler] Handler de notificações inicializado (placeholder)');
    }
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
