import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import '../../../auth/firebase_auth/auth_util.dart' as auth;
import '../cloud_functions/cloud_functions.dart';

import 'package:stream_transform/stream_transform.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'onesignal_service.dart';

export 'push_notifications_handler.dart';
export 'serialization_util.dart';

class UserTokenInfo {
  const UserTokenInfo(this.userPath, this.pushToken);
  final String userPath;
  final String pushToken;
}

Stream<UserTokenInfo> getFcmTokenStream(String userPath) =>
    Stream.value(!kIsWeb && (Platform.isIOS || Platform.isAndroid))
        .where((shouldGetToken) => shouldGetToken)
        .asyncMap<String?>((_) async {
          try {
            await OneSignalService.init();
            // Em OneSignal usamos o playerId como token
            return OneSignal.User.pushSubscription.id;
          } catch (e) {
            debugPrint('⚠️ [OneSignal] Falha ao obter playerId: $e');
          }
          return null;
        })
        .handleError((e) {
          debugPrint('⚠️ [OneSignal] Erro no stream de token: $e');
        })
        .where((playerId) => playerId != null && playerId.isNotEmpty)
        .map((playerId) => UserTokenInfo(userPath, playerId!));

final fcmTokenUserStream = auth.authenticatedUserStream
    .where((user) => user != null && (user!.uid ?? '').isNotEmpty)
    .map((user) => 'users/${user!.uid}')
    .distinct()
    .switchMap(getFcmTokenStream)
    .asyncMap((userTokenInfo) async {
      try {
        return await makeCloudCall(
          'addFcmToken',
          {
            'userDocPath': userTokenInfo.userPath,
            'fcmToken': userTokenInfo.pushToken,
            'deviceType': kIsWeb ? 'Web' : (Platform.isIOS ? 'iOS' : 'Android'),
          },
          suppressErrors: true,
          timeout: const Duration(seconds: 8),
        );
      } catch (_) {
        // Silencia erros aqui; já há tratamento silencioso em makeCloudCall
        return {};
      }
    });
