import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OneSignalService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    // Plugin não suporta Web no Flutter; apenas inicializa em Android/iOS
    if (kIsWeb) {
      _initialized = true;
      return;
    }

    final appId = dotenv.env['ONESIGNAL_APP_ID'];
    if (appId == null || appId.isEmpty) {
      // Evita crash se variável não estiver configurada
      debugPrint('⚠️ OneSignal: ONESIGNAL_APP_ID não configurado no .env');
      _initialized = true;
      return;
    }

    // Inicialização básica do OneSignal
    OneSignal.initialize(appId);

    // Solicita permissão para enviar notificações (iOS)
    try {
      await OneSignal.Notifications.requestPermission(true);
    } catch (_) {}

    _initialized = true;
  }

  static String? get currentPlayerId =>
      OneSignal.User.pushSubscription.id;
}