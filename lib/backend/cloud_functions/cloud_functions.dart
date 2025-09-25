import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>> makeCloudCall(
  String callName,
  Map<String, dynamic> input, {
  bool suppressErrors = false,
  Duration? timeout,
}) async {
  try {
    Future<HttpsCallableResult<dynamic>> future = FirebaseFunctions.instance
        .httpsCallable(callName, options: HttpsCallableOptions())
        .call(input);

    if (timeout != null) {
      future = future.timeout(timeout);
    }

    final response = await future;
    return response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : {};
  } on FirebaseFunctionsException catch (e) {
    if (!suppressErrors) {
      debugPrint(
        'Cloud call error!\n ${callName}'
        'Code: ${e.code}\n'
        'Details: ${e.details}\n'
        'Message: ${e.message}',
      );
    }
  } catch (e) {
    if (!suppressErrors) {
      debugPrint('Cloud call error:${callName} $e');
    }
  }
  return {};
}
