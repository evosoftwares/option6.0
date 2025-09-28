import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

/// Logger focado no código - logs diretos e técnicos
class ZonaExclusaoCodeLogger {
  static const String _tag = 'ZONA_EXCLUSAO_CODE';

  /// Log função chamada com parâmetros
  static void logFunction(String functionName, [Map<String, dynamic>? params]) {
    final message = 'CALL: $functionName';
    if (params != null && params.isNotEmpty) {
      developer.log('$message | PARAMS: $params', name: _tag);
      if (kDebugMode) print('🔧 $message | PARAMS: $params');
    } else {
      developer.log(message, name: _tag);
      if (kDebugMode) print('🔧 $message');
    }
  }

  /// Log resultado de função
  static void logResult(String functionName, dynamic result, [String? status]) {
    final statusInfo = status != null ? ' | STATUS: $status' : '';
    final message = 'RESULT: $functionName | VALUE: $result$statusInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('✅ $message');
  }

  /// Log erro de função
  static void logError(String functionName, dynamic error, [dynamic contextOrStack]) {
    String message;
    Map<String, dynamic>? context;
    StackTrace? stack;

    if (contextOrStack is StackTrace) {
      stack = contextOrStack;
      message = 'ERROR: $functionName | MSG: $error';
    } else if (contextOrStack is Map<String, dynamic>) {
      context = contextOrStack;
      message = 'ERROR: $functionName | MSG: $error | CONTEXT: $context';
    } else {
      message = 'ERROR: $functionName | MSG: $error';
    }

    developer.log(message, name: _tag, error: error, stackTrace: stack);
    if (kDebugMode) print('❌ $message');
    if (stack != null && kDebugMode) print('📍 STACK: ${stack.toString().split('\n').take(3).join('\n')}');
  }

  /// Log operação de banco
  static void logDatabase(String operation, String table, [Map<String, dynamic>? data]) {
    final dataInfo = data != null ? ' | DATA: $data' : '';
    final message = 'DB: $operation on $table$dataInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('💾 $message');
  }

  /// Log validação
  static void logValidation(String field, bool isValid, [String? reason]) {
    final reasonInfo = reason != null ? ' | REASON: $reason' : '';
    final status = isValid ? 'VALID' : 'INVALID';
    final message = 'VALIDATION: $field is $status$reasonInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('🔍 $message');
  }

  /// Log operação async
  static void logAsync(String operation, String status, [dynamic metadata]) {
    String message;
    if (metadata is int) {
      // Para compatibilidade com código existente
      message = 'ASYNC: $operation | STATUS: $status | TIME: ${metadata}ms';
    } else if (metadata is Map<String, dynamic>) {
      message = 'ASYNC: $operation | STATUS: $status | DETAILS: $metadata';
    } else if (metadata != null) {
      message = 'ASYNC: $operation | STATUS: $status | META: $metadata';
    } else {
      message = 'ASYNC: $operation | STATUS: $status';
    }
    developer.log(message, name: _tag);
    if (kDebugMode) print('⏱️ $message');
  }

  /// Log estado da UI
  static void logUI(String widget, String action, [Map<String, dynamic>? state]) {
    final stateInfo = state != null ? ' | STATE: $state' : '';
    final message = 'UI: $widget.$action$stateInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('🎨 $message');
  }

  /// Log condição/fluxo
  static void logFlow(String condition, bool result, [String? context]) {
    final contextInfo = context != null ? ' | CONTEXT: $context' : '';
    final message = 'FLOW: $condition = $result$contextInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('🔀 $message');
  }

  /// Log variável importante
  static void logVariable(String varName, dynamic value, [String? type]) {
    final typeInfo = type != null ? ' | TYPE: $type' : '';
    final message = 'VAR: $varName = $value$typeInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('📊 $message');
  }

  /// Log performance crítica
  static void logPerformance(String operation, int durationMs, [String? threshold]) {
    final thresholdInfo = threshold != null ? ' | THRESHOLD: $threshold' : '';
    final status = durationMs > 1000 ? 'SLOW' : durationMs > 500 ? 'OK' : 'FAST';
    final message = 'PERF: $operation | TIME: ${durationMs}ms | STATUS: $status$thresholdInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('⚡ $message');
  }

  /// Log entrada/saída de bloco
  static void logBlock(String blockName, String action) {
    final message = 'BLOCK: $blockName | ACTION: $action';
    developer.log(message, name: _tag);
    if (kDebugMode) print('📦 $message');
  }

  /// Log interação do usuário
  static void logInteraction(String element, String action, [Map<String, dynamic>? details]) {
    final detailsInfo = details != null ? ' | DETAILS: $details' : '';
    final message = 'INTERACTION: $element.$action$detailsInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('👆 $message');
  }

  /// Log mudança de estado
  static void logStateChange(String widget, String from, String to, [Map<String, dynamic>? context]) {
    final contextInfo = context != null ? ' | CONTEXT: $context' : '';
    final message = 'STATE: $widget | FROM: $from | TO: $to$contextInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('🔄 $message');
  }

  /// Log navegação
  static void logNavigation(String action, String route, [Map<String, dynamic>? params]) {
    final paramsInfo = params != null ? ' | PARAMS: $params' : '';
    final message = 'NAV: $action | ROUTE: $route$paramsInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('🧭 $message');
  }

  /// Log lifecycle de widget
  static void logLifecycle(String widget, String phase, [String? details]) {
    final detailsInfo = details != null ? ' | DETAILS: $details' : '';
    final message = 'LIFECYCLE: $widget.$phase$detailsInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('🔄 $message');
  }

  /// Log de sessão/timer
  static void logSession(String event, [int? durationMs]) {
    final timeInfo = durationMs != null ? ' | DURATION: ${durationMs}ms' : '';
    final message = 'SESSION: $event$timeInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('⏰ $message');
  }

  /// Log de campo de formulário
  static void logFormField(String fieldName, String event, dynamic value, [Map<String, dynamic>? metadata]) {
    final metaInfo = metadata != null ? ' | META: $metadata' : '';
    final message = 'FORM: $fieldName.$event | VALUE: $value$metaInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('📝 $message');
  }

  /// Log de conectividade/rede
  static void logNetwork(String operation, String status, [Map<String, dynamic>? details]) {
    final detailsInfo = details != null ? ' | DETAILS: $details' : '';
    final message = 'NETWORK: $operation | STATUS: $status$detailsInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('🌐 $message');
  }

  /// Log de cache/storage
  static void logStorage(String operation, String key, dynamic value, [String? status]) {
    final statusInfo = status != null ? ' | STATUS: $status' : '';
    final message = 'STORAGE: $operation | KEY: $key | VALUE: $value$statusInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('💾 $message');
  }

  /// Log de segurança/permissões
  static void logSecurity(String check, bool passed, [String? reason]) {
    final reasonInfo = reason != null ? ' | REASON: $reason' : '';
    final status = passed ? 'ALLOWED' : 'DENIED';
    final message = 'SECURITY: $check | STATUS: $status$reasonInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('🔒 $message');
  }

  /// Log de animação/transição
  static void logAnimation(String animation, String phase, [int? durationMs]) {
    final timeInfo = durationMs != null ? ' | DURATION: ${durationMs}ms' : '';
    final message = 'ANIMATION: $animation | PHASE: $phase$timeInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('🎬 $message');
  }

  /// Log de memória/recursos
  static void logResource(String resource, String operation, [dynamic amount]) {
    final amountInfo = amount != null ? ' | AMOUNT: $amount' : '';
    final message = 'RESOURCE: $resource | OP: $operation$amountInfo';
    developer.log(message, name: _tag);
    if (kDebugMode) print('💰 $message');
  }

  /// Wrapper para medir tempo de execução
  static Future<T> measureAsync<T>(String operation, Future<T> Function() fn) async {
    logAsync(operation, 'START');
    final stopwatch = Stopwatch()..start();
    try {
      final result = await fn();
      stopwatch.stop();
      logAsync(operation, 'COMPLETE', stopwatch.elapsedMilliseconds);
      return result;
    } catch (error, stack) {
      stopwatch.stop();
      logAsync(operation, 'FAILED', stopwatch.elapsedMilliseconds);
      logError(operation, error, stack);
      rethrow;
    }
  }

  /// Wrapper para medir tempo de execução síncrono
  static T measureSync<T>(String operation, T Function() fn) {
    logBlock(operation, 'START');
    final stopwatch = Stopwatch()..start();
    try {
      final result = fn();
      stopwatch.stop();
      logPerformance(operation, stopwatch.elapsedMilliseconds);
      logBlock(operation, 'COMPLETE');
      return result;
    } catch (error, stack) {
      stopwatch.stop();
      logPerformance(operation, stopwatch.elapsedMilliseconds, 'FAILED');
      logError(operation, error, stack);
      logBlock(operation, 'FAILED');
      rethrow;
    }
  }

  // NOVOS MÉTODOS PARA INVESTIGAÇÃO AVANÇADA

  /// Log específico para erros de rede com análise detalhada
  static void logNetworkError(String operation, dynamic error, [Map<String, dynamic>? context]) {
    final errorType = error.runtimeType.toString();
    final errorMessage = error.toString();

    final networkErrorData = {
      'operation': operation,
      'error_type': errorType,
      'error_message': errorMessage,
      'is_timeout': errorMessage.contains('timeout') || errorMessage.contains('TIMEOUT'),
      'is_connection_error': errorMessage.contains('connection') || errorMessage.contains('Connection'),
      'is_socket_error': errorMessage.contains('socket') || errorMessage.contains('Socket'),
      'is_http_error': errorMessage.contains('http') || errorMessage.contains('HTTP'),
      'is_supabase_error': errorMessage.contains('supabase') || errorMessage.contains('Supabase'),
      'timestamp': DateTime.now().toIso8601String(),
      if (context != null) ...context,
    };

    developer.log('NETWORK_ERROR: $operation | $errorMessage', name: _tag);
    if (kDebugMode) print('❌ NETWORK_ERROR: $operation | MSG: $errorMessage | TYPE: $errorType');
    if (kDebugMode) print('🌐 NETWORK: $operation | STATUS: failed | DETAILS: $networkErrorData');
  }

  /// Log para tentativas de retry com backoff exponencial
  static void logRetryAttempt(String operation, int attemptNumber, int maxAttempts, [Map<String, dynamic>? context]) {
    final retryData = {
      'operation': operation,
      'attempt': attemptNumber,
      'max_attempts': maxAttempts,
      'is_final_attempt': attemptNumber >= maxAttempts,
      'backoff_delay_ms': _calculateBackoffDelay(attemptNumber),
      'timestamp': DateTime.now().toIso8601String(),
      if (context != null) ...context,
    };

    developer.log('RETRY: $operation | Attempt $attemptNumber/$maxAttempts', name: _tag);
    if (kDebugMode) print('🔄 RETRY: $operation | ATTEMPT: $attemptNumber/$maxAttempts | DETAILS: $retryData');
  }

  /// Calcula delay de backoff exponencial
  static int _calculateBackoffDelay(int attemptNumber) {
    return (1000 * (attemptNumber * attemptNumber)).clamp(1000, 10000); // 1s, 4s, 9s, max 10s
  }

  /// Log para validação de dados recebidos com análise profunda
  static void logDataValidation(String dataType, dynamic data, bool isValid, [String? reason]) {
    final validationData = {
      'data_type': dataType,
      'is_valid': isValid,
      'data_length': data is List ? data.length : (data is String ? data.length : 1),
      'data_type_runtime': data.runtimeType.toString(),
      'is_null': data == null,
      'is_empty': (data is List && data.isEmpty) || (data is String && data.isEmpty),
      'has_expected_structure': _validateDataStructure(data, dataType),
      if (reason != null) 'reason': reason,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (data is List && data.isNotEmpty) {
      validationData['first_item_type'] = data.first.runtimeType.toString();
      if (data.first is Map) {
        validationData['sample_keys'] = (data.first as Map).keys.take(5).toList();
      }
    }

    final status = isValid ? 'VALID' : 'INVALID';
    final message = reason ?? 'Data validation check';

    developer.log('DATA_VALIDATION: $dataType is $status | $message', name: _tag);
    if (kDebugMode) print('✅ DATA_VALIDATION: $dataType is $status | REASON: $message | DETAILS: $validationData');
  }

  /// Valida estrutura dos dados baseado no tipo esperado
  static bool _validateDataStructure(dynamic data, String dataType) {
    switch (dataType.toLowerCase()) {
      case 'driver_excluded_zones':
        return data is List && (data.isEmpty || (data.first is Map &&
               (data.first as Map).containsKey('id') &&
               (data.first as Map).containsKey('driver_id')));
      case 'zone_record':
        return data is Map &&
               data.containsKey('id') &&
               data.containsKey('driver_id') &&
               data.containsKey('type') &&
               data.containsKey('local_name');
      default:
        return true; // Para tipos não específicos, considera válido
    }
  }

  /// Log para monitoramento de conectividade com detalhes de rede
  static void logConnectivity(String status, [Map<String, dynamic>? details]) {
    final connectivityData = {
      'status': status,
      'timestamp': DateTime.now().toIso8601String(),
      'connection_quality': _assessConnectionQuality(status),
      if (details != null) ...details,
    };

    developer.log('CONNECTIVITY: $status', name: _tag);
    if (kDebugMode) print('📡 CONNECTIVITY: $status | DETAILS: $connectivityData');
  }

  /// Avalia qualidade da conexão baseado no status
  static String _assessConnectionQuality(String status) {
    if (status.contains('connected') && !status.contains('slow')) return 'GOOD';
    if (status.contains('connected') && status.contains('slow')) return 'POOR';
    if (status.contains('connecting') || status.contains('retrying')) return 'UNSTABLE';
    return 'OFFLINE';
  }

  /// Log para timeout de operações com análise de performance
  static void logTimeout(String operation, int timeoutMs, [Map<String, dynamic>? context]) {
    final timeoutData = {
      'operation': operation,
      'timeout_ms': timeoutMs,
      'timeout_seconds': timeoutMs / 1000,
      'severity': _getTimeoutSeverity(timeoutMs),
      'recommended_action': _getTimeoutRecommendation(timeoutMs),
      'timestamp': DateTime.now().toIso8601String(),
      if (context != null) ...context,
    };

    developer.log('TIMEOUT: $operation | ${timeoutMs}ms', name: _tag);
    if (kDebugMode) print('⏰ TIMEOUT: $operation | TIME: ${timeoutMs}ms | DETAILS: $timeoutData');
  }

  /// Determina severidade do timeout
  static String _getTimeoutSeverity(int timeoutMs) {
    if (timeoutMs < 5000) return 'LOW';
    if (timeoutMs < 15000) return 'MEDIUM';
    return 'HIGH';
  }

  /// Recomendação baseada no timeout
  static String _getTimeoutRecommendation(int timeoutMs) {
    if (timeoutMs < 5000) return 'RETRY_IMMEDIATELY';
    if (timeoutMs < 15000) return 'RETRY_WITH_BACKOFF';
    return 'CHECK_CONNECTIVITY';
  }

  /// Log para monitoramento de real-time com métricas de performance
  static void logRealTimeEvent(String event, String status, [Map<String, dynamic>? metrics]) {
    final eventData = {
      'event': event,
      'status': status,
      'timestamp': DateTime.now().toIso8601String(),
      'performance_score': _calculatePerformanceScore(metrics),
      if (metrics != null) ...metrics,
    };

    developer.log('REALTIME: $event | $status', name: _tag);
    if (kDebugMode) print('🔄 REALTIME: $event | STATUS: $status | METRICS: $eventData');
  }

  /// Calcula score de performance baseado em métricas
  static double _calculatePerformanceScore(Map<String, dynamic>? metrics) {
    if (metrics == null) return 0.0;

    double score = 100.0;

    // Penaliza por latência alta
    if (metrics.containsKey('latency_ms')) {
      final latency = metrics['latency_ms'] as int? ?? 0;
      if (latency > 1000) score -= 30;
      else if (latency > 500) score -= 15;
    }

    // Penaliza por erros
    if (metrics.containsKey('error_count')) {
      final errors = metrics['error_count'] as int? ?? 0;
      score -= (errors * 10);
    }

    // Bonifica por sucessos consecutivos
    if (metrics.containsKey('success_streak')) {
      final streak = metrics['success_streak'] as int? ?? 0;
      score += (streak * 2).clamp(0, 20);
    }

    return score.clamp(0.0, 100.0);
  }

  /// Wrapper para operações com retry automático
  static Future<T> withRetry<T>(
    String operation,
    Future<T> Function() action, {
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    Map<String, dynamic>? context,
  }) async {
    int attempts = 0;
    Exception? lastException;

    while (attempts < maxAttempts) {
      attempts++;

      try {
        logRetryAttempt(operation, attempts, maxAttempts, context);

        final result = await measureAsync('${operation}_attempt_$attempts', action);

        if (attempts > 1) {
          logAsync(operation, 'RETRY_SUCCESS', {
            'successful_attempt': attempts,
            'total_attempts': attempts,
            'final_result': 'SUCCESS_AFTER_RETRY'
          });
        }

        return result;
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());

        logNetworkError('${operation}_attempt_$attempts', e, {
          'attempt_number': attempts,
          'remaining_attempts': maxAttempts - attempts,
          ...?context,
        });

        if (attempts >= maxAttempts) {
          logError(operation, 'MAX_RETRIES_EXCEEDED', {
            'total_attempts': maxAttempts,
            'final_error': e.toString(),
            'operation_failed': true,
            ...?context,
          });
          break;
        }

        // Backoff exponencial
        final delay = Duration(milliseconds: _calculateBackoffDelay(attempts));
        logSession('retry_backoff_delay', delay.inMilliseconds);
        await Future.delayed(delay);
      }
    }

    throw lastException ?? Exception('Operation failed after $maxAttempts attempts');
  }

  /// Log conciso para banco com retry e validação
  static Future<void> logToDatabase(String action, Map<String, dynamic> data) async {
    if (!kDebugMode) return; // Só em debug por enquanto

    try {
      await withRetry(
        'log_to_database',
        () async {
          await SupaFlow.client.from('zona_exclusao_code_logs').insert({
            'driver_id': currentUserUid,
            'action': action,
            'data': data,
            'timestamp': DateTime.now().toIso8601String(),
            'session_id': _generateSessionId(),
          });
        },
        maxAttempts: 2,
        context: {'action': action, 'data_size': data.length},
      );

      logStorage('database_log', action, 'SUCCESS');
    } catch (e) {
      // Falha silenciosa no log de banco
      logStorage('database_log', action, 'FAILED');
      if (kDebugMode) print('🚨 LOG_DB_FAIL: $e');
    }
  }

  /// Gera ID único para a sessão
  static String _generateSessionId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${currentUserUid.isNotEmpty ? currentUserUid.substring(0, 8) : "unknown"}';
  }

  /// Monitor de saúde do sistema com métricas avançadas
  static void logSystemHealth(Map<String, dynamic> metrics) {
    final healthScore = _calculateSystemHealthScore(metrics);
    final healthStatus = _getHealthStatus(healthScore);

    final healthData = {
      'health_score': healthScore,
      'health_status': healthStatus,
      'timestamp': DateTime.now().toIso8601String(),
      'metrics': metrics,
      'recommendations': _getHealthRecommendations(healthScore, metrics),
    };

    developer.log('SYSTEM_HEALTH: $healthStatus | Score: $healthScore', name: _tag);
    if (kDebugMode) print('💊 SYSTEM_HEALTH: $healthStatus | SCORE: $healthScore | DATA: $healthData');
  }

  /// Calcula score de saúde do sistema (0-100)
  static double _calculateSystemHealthScore(Map<String, dynamic> metrics) {
    double score = 100.0;

    // Conectividade (peso: 30%)
    if (metrics.containsKey('connection_failures')) {
      final failures = metrics['connection_failures'] as int? ?? 0;
      score -= (failures * 10).clamp(0, 30);
    }

    // Performance (peso: 25%)
    if (metrics.containsKey('avg_response_time_ms')) {
      final avgTime = metrics['avg_response_time_ms'] as int? ?? 0;
      if (avgTime > 2000) score -= 25;
      else if (avgTime > 1000) score -= 15;
      else if (avgTime > 500) score -= 5;
    }

    // Taxa de erro (peso: 25%)
    if (metrics.containsKey('error_rate_percent')) {
      final errorRate = metrics['error_rate_percent'] as double? ?? 0;
      score -= (errorRate * 25 / 100);
    }

    // Operações bem-sucedidas (peso: 20%)
    if (metrics.containsKey('success_rate_percent')) {
      final successRate = metrics['success_rate_percent'] as double? ?? 100;
      if (successRate < 90) score -= ((100 - successRate) * 0.2);
    }

    return score.clamp(0.0, 100.0);
  }

  /// Determina status de saúde baseado no score
  static String _getHealthStatus(double score) {
    if (score >= 90) return 'EXCELLENT';
    if (score >= 75) return 'GOOD';
    if (score >= 60) return 'FAIR';
    if (score >= 40) return 'POOR';
    return 'CRITICAL';
  }

  /// Gera recomendações baseadas no score e métricas
  static List<String> _getHealthRecommendations(double score, Map<String, dynamic> metrics) {
    final recommendations = <String>[];

    if (score < 60) {
      recommendations.add('INVESTIGATE_CONNECTIVITY_ISSUES');
    }

    if (metrics.containsKey('avg_response_time_ms')) {
      final avgTime = metrics['avg_response_time_ms'] as int? ?? 0;
      if (avgTime > 1000) {
        recommendations.add('OPTIMIZE_DATABASE_QUERIES');
      }
    }

    if (metrics.containsKey('error_rate_percent')) {
      final errorRate = metrics['error_rate_percent'] as double? ?? 0;
      if (errorRate > 5) {
        recommendations.add('REVIEW_ERROR_HANDLING');
      }
    }

    if (recommendations.isEmpty) {
      recommendations.add('SYSTEM_OPERATING_NORMALLY');
    }

    return recommendations;
  }

  /// Monitor de real-time para mudanças de dados
  static void startDataChangeMonitoring(String tableName, Function(Map<String, dynamic>) onDataChange) {
    logRealTimeEvent('data_monitoring_start', 'INITIALIZING', {
      'table': tableName,
      'monitoring_type': 'REAL_TIME_SUBSCRIPTION'
    });

    // Este método seria implementado com Supabase Realtime
    // Por enquanto, apenas logamos a intenção
    logStorage('monitoring_setup', tableName, 'CONFIGURED');
  }

  /// Diagnóstico completo do sistema
  static Future<Map<String, dynamic>> performSystemDiagnostic() async {
    logBlock('system_diagnostic', 'START');

    final diagnosticResults = <String, dynamic>{};

    try {
      // Teste de conectividade
      diagnosticResults['connectivity'] = await _testConnectivity();

      // Teste de autenticação
      diagnosticResults['authentication'] = await _testAuthentication();

      // Teste de database
      diagnosticResults['database'] = await _testDatabaseAccess();

      // Análise de performance
      diagnosticResults['performance'] = await _analyzePerformance();

      logBlock('system_diagnostic', 'SUCCESS');
      logSystemHealth(diagnosticResults);

      return diagnosticResults;
    } catch (e) {
      logError('system_diagnostic', e);
      logBlock('system_diagnostic', 'FAILED');
      rethrow;
    }
  }

  /// Teste de conectividade com Supabase
  static Future<Map<String, dynamic>> _testConnectivity() async {
    try {
      final startTime = DateTime.now();

      // Teste simples de ping ao Supabase
      await SupaFlow.client.from('driver_excluded_zones').select('id').limit(1);

      final latency = DateTime.now().difference(startTime).inMilliseconds;

      return {
        'status': 'CONNECTED',
        'latency_ms': latency,
        'quality': latency < 500 ? 'EXCELLENT' : latency < 1000 ? 'GOOD' : 'POOR'
      };
    } catch (e) {
      return {
        'status': 'FAILED',
        'error': e.toString(),
        'quality': 'OFFLINE'
      };
    }
  }

  /// Teste de autenticação
  static Future<Map<String, dynamic>> _testAuthentication() async {
    try {
      final userId = currentUserUid;

      return {
        'status': userId != null && userId.isNotEmpty ? 'AUTHENTICATED' : 'NOT_AUTHENTICATED',
        'user_id_valid': userId != null && userId.isNotEmpty,
        'user_id_length': userId?.length ?? 0
      };
    } catch (e) {
      return {
        'status': 'ERROR',
        'error': e.toString()
      };
    }
  }

  /// Teste de acesso ao banco de dados
  static Future<Map<String, dynamic>> _testDatabaseAccess() async {
    try {
      final startTime = DateTime.now();

      final result = await SupaFlow.client
          .from('driver_excluded_zones')
          .select('id, driver_id')
          .eq('driver_id', currentUserUid);

      final queryTime = DateTime.now().difference(startTime).inMilliseconds;
      final recordCount = (result as List?)?.length ?? 0;

      return {
        'status': 'SUCCESS',
        'query_time_ms': queryTime,
        'record_count': recordCount,
        'table_accessible': true,
        'filter_working': true
      };
    } catch (e) {
      return {
        'status': 'FAILED',
        'error': e.toString(),
        'table_accessible': false,
        'filter_working': false
      };
    }
  }

  /// Análise de performance do sistema
  static Future<Map<String, dynamic>> _analyzePerformance() async {
    // Simulação de análise de performance
    // Em implementação real, coletaria métricas dos últimos N minutos

    return {
      'avg_response_time_ms': 250,
      'success_rate_percent': 95.5,
      'error_rate_percent': 4.5,
      'peak_memory_mb': 45,
      'database_connections': 2,
      'cache_hit_rate_percent': 85.0
    };
  }
}