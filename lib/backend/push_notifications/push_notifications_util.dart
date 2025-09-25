import 'dart:io' show Platform;


import '../../../auth/firebase_auth/auth_util.dart';
import '../cloud_functions/cloud_functions.dart';

import 'package:flutter/foundation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

export 'push_notifications_handler.dart';
export 'serialization_util.dart';

class UserTokenInfo {
  const UserTokenInfo(this.userPath, this.fcmToken);
  final String userPath;
  final String fcmToken;
}

Stream<UserTokenInfo> getFcmTokenStream(String userPath) =>
    Stream.value(!kIsWeb && (Platform.isIOS || Platform.isAndroid))
        .where((shouldGetToken) => shouldGetToken)
        .asyncMap<String?>((_) async {
          try {
            final settings = await FirebaseMessaging.instance.requestPermission();
            if (settings.authorizationStatus == AuthorizationStatus.authorized) {
              return await FirebaseMessaging.instance.getToken();
            }
          } catch (e) {
            debugPrint('⚠️ [FCM] Falha ao obter token: $e');
          }
          return null;
        })
        .switchMap((fcmToken) =>
            Stream.value(fcmToken).merge(FirebaseMessaging.instance.onTokenRefresh))
        .handleError((e) {
          // Evita que erros de rede derrubem o stream de FCM
          debugPrint('⚠️ [FCM] Erro no stream de token: $e');
        })
        .where((fcmToken) => fcmToken != null && fcmToken.isNotEmpty)
        .map((token) => UserTokenInfo(userPath, token!));

final fcmTokenUserStream = authenticatedUserStream
    .where((user) => user != null)
    .map((user) => user!.reference.path)
    .distinct()
    .switchMap(getFcmTokenStream)
    .asyncMap((userTokenInfo) async {
      try {
        return await makeCloudCall(
          'addFcmToken',
          {
            'userDocPath': userTokenInfo.userPath,
            'fcmToken': userTokenInfo.fcmToken,
            'deviceType': Platform.isIOS ? 'iOS' : 'Android',
          },
          suppressErrors: true,
          timeout: const Duration(seconds: 8),
        );
      } catch (_) {
        // Silencia erros aqui; já há tratamento silencioso em makeCloudCall
        return {};
      }
    });
