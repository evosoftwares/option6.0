// DEPRECATED: Firebase Cloud Functions removido
// Substituído por Supabase Edge Functions ou lógica no backend
import 'package:flutter/foundation.dart';

@Deprecated('Use Supabase Edge Functions ou lógica no backend')
Future<Map<String, dynamic>> makeCloudCall(
  String callName,
  Map<String, dynamic> input, {
  bool suppressErrors = false,
  Duration? timeout,
}) async {
  if (!suppressErrors) {
    debugPrint('⚠️ DEPRECATED: makeCloudCall não é mais suportado. Use Supabase Edge Functions.');
  }
  return {};
}
