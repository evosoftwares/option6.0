import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '/backend/supabase/supabase.dart';
import '/auth/firebase_auth/auth_util.dart';

class ZonaExclusaoLoggingService {
  static const String _logTag = 'ZONA_EXCLUSAO';
  static const String _systemTag = 'SISTEMA';

  // Log levels
  static const String _info = 'INFO';
  static const String _warning = 'WARNING';
  static const String _error = 'ERROR';
  static const String _debug = 'DEBUG';
  static const String _success = 'SUCCESS';

  /// Registra log de início do processo de criação de zona
  static Future<void> logZoneCreationStart({
    required String driverId,
    required String zoneType,
    required String zoneName,
    Map<String, dynamic>? additionalData,
  }) async {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'ZONE_CREATION_START',
      'driver_id': driverId,
      'zone_type': zoneType,
      'zone_name': zoneName,
      'session_info': {
        'device_info': await _getDeviceInfo(),
        'app_version': await _getAppVersion(),
        'user_agent': _getUserAgent(),
      },
      'additional_data': additionalData ?? {},
    };

    await _logToConsole(_info, 'Iniciando criação de zona de exclusão', logData);
    await _logToDatabase('zone_creation_start', logData);
  }

  /// Registra validação de entrada de dados
  static Future<void> logInputValidation({
    required String driverId,
    required String zoneType,
    required String zoneName,
    required bool isValid,
    List<String>? validationErrors,
  }) async {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'INPUT_VALIDATION',
      'driver_id': driverId,
      'zone_type': zoneType,
      'zone_name': zoneName,
      'is_valid': isValid,
      'validation_errors': validationErrors ?? [],
      'input_length': zoneName.length,
      'has_special_chars': _hasSpecialCharacters(zoneName),
      'contains_numbers': _containsNumbers(zoneName),
    };

    final level = isValid ? _info : _warning;
    final message = isValid
        ? 'Validação de entrada passou com sucesso'
        : 'Falha na validação de entrada: ${validationErrors?.join(', ')}';

    await _logToConsole(level, message, logData);
    await _logToDatabase('input_validation', logData);
  }

  /// Registra tentativa de conexão com banco de dados
  static Future<void> logDatabaseConnectionAttempt({
    required String driverId,
    required String operation,
  }) async {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'DATABASE_CONNECTION_ATTEMPT',
      'driver_id': driverId,
      'operation': operation,
      'connection_info': {
        'supabase_url': await _getSupabaseUrl(),
        'connection_timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    };

    await _logToConsole(_debug, 'Tentando conectar ao banco de dados para $operation', logData);
    await _logToDatabase('database_connection_attempt', logData);
  }

  /// Registra sucesso na operação de banco de dados
  static Future<void> logDatabaseSuccess({
    required String driverId,
    required String operation,
    required Map<String, dynamic> insertedData,
    int? rowsAffected,
  }) async {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'DATABASE_SUCCESS',
      'driver_id': driverId,
      'operation': operation,
      'inserted_data': insertedData,
      'rows_affected': rowsAffected ?? 1,
      'execution_time': DateTime.now().millisecondsSinceEpoch,
      'data_size': jsonEncode(insertedData).length,
    };

    await _logToConsole(_success, 'Operação de banco de dados realizada com sucesso: $operation', logData);
    await _logToDatabase('database_success', logData);
  }

  /// Registra erro na operação de banco de dados
  static Future<void> logDatabaseError({
    required String driverId,
    required String operation,
    required dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? attemptedData,
  }) async {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'DATABASE_ERROR',
      'driver_id': driverId,
      'operation': operation,
      'error_message': error.toString(),
      'error_type': error.runtimeType.toString(),
      'stack_trace': stackTrace?.toString(),
      'attempted_data': attemptedData,
      'error_context': {
        'is_network_error': _isNetworkError(error),
        'is_permission_error': _isPermissionError(error),
        'is_timeout_error': _isTimeoutError(error),
      },
    };

    await _logToConsole(_error, 'Erro na operação de banco de dados: $operation - ${error.toString()}', logData);
    await _logToDatabase('database_error', logData);
  }

  /// Registra verificação de duplicatas
  static Future<void> logDuplicateCheck({
    required String driverId,
    required String zoneType,
    required String zoneName,
    required bool isDuplicate,
    List<Map<String, dynamic>>? existingZones,
  }) async {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'DUPLICATE_CHECK',
      'driver_id': driverId,
      'zone_type': zoneType,
      'zone_name': zoneName,
      'is_duplicate': isDuplicate,
      'existing_zones_count': existingZones?.length ?? 0,
      'existing_zones': existingZones ?? [],
      'similarity_analysis': {
        'exact_match': _checkExactMatch(zoneName, existingZones),
        'similar_names': _findSimilarNames(zoneName, existingZones),
      },
    };

    final level = isDuplicate ? _warning : _info;
    final message = isDuplicate
        ? 'Zona duplicada detectada: $zoneName'
        : 'Verificação de duplicata passou - zona é única';

    await _logToConsole(level, message, logData);
    await _logToDatabase('duplicate_check', logData);
  }

  /// Registra sucesso completo da criação de zona
  static Future<void> logZoneCreationSuccess({
    required String driverId,
    required String zoneType,
    required String zoneName,
    required String zoneId,
    int? totalZonesAfterCreation,
  }) async {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'ZONE_CREATION_SUCCESS',
      'driver_id': driverId,
      'zone_type': zoneType,
      'zone_name': zoneName,
      'zone_id': zoneId,
      'total_zones_after_creation': totalZonesAfterCreation,
      'performance_metrics': {
        'creation_completed_at': DateTime.now().millisecondsSinceEpoch,
        'process_duration': 'calculated_in_calling_function',
      },
      'zone_statistics': {
        'name_length': zoneName.length,
        'type_category': zoneType,
        'created_by_driver': driverId,
      },
    };

    await _logToConsole(_success, 'Zona de exclusão criada com sucesso: $zoneName ($zoneType)', logData);
    await _logToDatabase('zone_creation_success', logData);
  }

  /// Registra falha completa na criação de zona
  static Future<void> logZoneCreationFailure({
    required String driverId,
    required String zoneType,
    required String zoneName,
    required dynamic error,
    required String failureStage,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) async {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'ZONE_CREATION_FAILURE',
      'driver_id': driverId,
      'zone_type': zoneType,
      'zone_name': zoneName,
      'error_message': error.toString(),
      'error_type': error.runtimeType.toString(),
      'failure_stage': failureStage,
      'stack_trace': stackTrace?.toString(),
      'context': context ?? {},
      'failure_analysis': {
        'is_user_error': _isUserError(error),
        'is_system_error': _isSystemError(error),
        'requires_retry': _shouldRetry(error),
        'user_actionable': _isUserActionable(error),
      },
    };

    await _logToConsole(_error, 'Falha na criação de zona de exclusão: $zoneName - Estágio: $failureStage', logData);
    await _logToDatabase('zone_creation_failure', logData);
  }

  /// Registra ações do usuário na interface
  static Future<void> logUserAction({
    required String driverId,
    required String action,
    Map<String, dynamic>? actionData,
  }) async {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'USER_ACTION',
      'driver_id': driverId,
      'user_action': action,
      'action_data': actionData ?? {},
      'ui_context': {
        'screen': 'add_zona_exclusao',
        'action_timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    };

    await _logToConsole(_debug, 'Ação do usuário: $action', logData);
    await _logToDatabase('user_action', logData);
  }

  /// Registra métricas de performance
  static Future<void> logPerformanceMetrics({
    required String driverId,
    required String operation,
    required int durationMs,
    Map<String, dynamic>? additionalMetrics,
  }) async {
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'PERFORMANCE_METRICS',
      'driver_id': driverId,
      'operation': operation,
      'duration_ms': durationMs,
      'performance_rating': _ratePerformance(durationMs),
      'additional_metrics': additionalMetrics ?? {},
      'system_info': {
        'memory_usage': await _getMemoryUsage(),
        'device_performance': await _getDevicePerformance(),
      },
    };

    await _logToConsole(_info, 'Métricas de performance para $operation: ${durationMs}ms', logData);
    await _logToDatabase('performance_metrics', logData);
  }

  // Métodos auxiliares privados

  static void _logToConsole(String level, String message, Map<String, dynamic> data) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] [$_logTag] [$level] $message';

    if (kDebugMode) {
      developer.log(
        logMessage,
        name: _logTag,
        time: DateTime.now(),
        level: _getLogLevel(level),
      );

      // Log detalhado em debug
      developer.log(
        'Dados detalhados: ${jsonEncode(data)}',
        name: _logTag,
        time: DateTime.now(),
        level: _getLogLevel(_debug),
      );
    }

    // Print para console sempre
    print('🚀 $logMessage');
    print('📊 Dados: ${jsonEncode(data)}');
  }

  static Future<void> _logToDatabase(String actionType, Map<String, dynamic> logData) async {
    try {
      await SupabaseFlow.client
          .from('zona_exclusao_logs')
          .insert({
            'driver_id': logData['driver_id'],
            'action_type': actionType,
            'log_data': logData,
            'created_at': DateTime.now().toIso8601String(),
            'log_level': _extractLogLevel(logData),
            'session_id': await _getSessionId(),
          });
    } catch (e) {
      // Se falhar ao logar no banco, pelo menos loga no console
      developer.log(
        'Falha ao salvar log no banco: $e',
        name: _systemTag,
        level: 1000, // ERROR level
      );
      print('🚨 Erro ao salvar log no banco: $e');
    }
  }

  static String _extractLogLevel(Map<String, dynamic> logData) {
    final action = logData['action'] as String;
    if (action.contains('ERROR') || action.contains('FAILURE')) return _error;
    if (action.contains('SUCCESS')) return _success;
    if (action.contains('WARNING') || action.contains('DUPLICATE')) return _warning;
    return _info;
  }

  static int _getLogLevel(String level) {
    switch (level) {
      case _debug: return 500;
      case _info: return 800;
      case _warning: return 900;
      case _error: return 1000;
      case _success: return 800;
      default: return 800;
    }
  }

  // Métodos de análise e utilitários

  static bool _hasSpecialCharacters(String text) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text);
  }

  static bool _containsNumbers(String text) {
    return RegExp(r'\d').hasMatch(text);
  }

  static bool _isNetworkError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('network') ||
           errorStr.contains('connection') ||
           errorStr.contains('timeout') ||
           errorStr.contains('unreachable');
  }

  static bool _isPermissionError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('permission') ||
           errorStr.contains('unauthorized') ||
           errorStr.contains('forbidden') ||
           errorStr.contains('access denied');
  }

  static bool _isTimeoutError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('timeout') ||
           errorStr.contains('deadline exceeded') ||
           errorStr.contains('request timeout');
  }

  static bool _isUserError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('validation') ||
           errorStr.contains('invalid input') ||
           errorStr.contains('duplicate') ||
           errorStr.contains('required field');
  }

  static bool _isSystemError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('internal server') ||
           errorStr.contains('database') ||
           errorStr.contains('connection') ||
           errorStr.contains('service unavailable');
  }

  static bool _shouldRetry(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('timeout') ||
           errorStr.contains('connection') ||
           errorStr.contains('temporary') ||
           errorStr.contains('retry');
  }

  static bool _isUserActionable(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('validation') ||
           errorStr.contains('invalid') ||
           errorStr.contains('required') ||
           errorStr.contains('duplicate');
  }

  static bool _checkExactMatch(String zoneName, List<Map<String, dynamic>>? existingZones) {
    if (existingZones == null) return false;
    return existingZones.any((zone) =>
        zone['local_name']?.toString().toLowerCase() == zoneName.toLowerCase());
  }

  static List<String> _findSimilarNames(String zoneName, List<Map<String, dynamic>>? existingZones) {
    if (existingZones == null) return [];

    final similarNames = <String>[];
    final lowerZoneName = zoneName.toLowerCase();

    for (final zone in existingZones) {
      final existingName = zone['local_name']?.toString().toLowerCase() ?? '';
      if (existingName.contains(lowerZoneName) || lowerZoneName.contains(existingName)) {
        similarNames.add(zone['local_name']?.toString() ?? '');
      }
    }

    return similarNames;
  }

  static String _ratePerformance(int durationMs) {
    if (durationMs < 1000) return 'EXCELLENT';
    if (durationMs < 3000) return 'GOOD';
    if (durationMs < 5000) return 'ACCEPTABLE';
    if (durationMs < 10000) return 'SLOW';
    return 'VERY_SLOW';
  }

  // Métodos de informações do sistema (implementações básicas)

  static Future<Map<String, dynamic>> _getDeviceInfo() async {
    return {
      'platform': kIsWeb ? 'web' : 'mobile',
      'is_debug': kDebugMode,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  static Future<String> _getAppVersion() async {
    return '1.0.0+29'; // From CLAUDE.md
  }

  static String _getUserAgent() {
    return 'EvoApp/1.0.0 Flutter';
  }

  static Future<String> _getSupabaseUrl() async {
    return SupabaseFlow.client.supabaseUrl;
  }

  static Future<Map<String, dynamic>> _getMemoryUsage() async {
    return {
      'estimated_usage': 'not_available',
      'platform': kIsWeb ? 'web' : 'mobile',
    };
  }

  static Future<String> _getDevicePerformance() async {
    return 'unknown';
  }

  static Future<String> _getSessionId() async {
    return '${currentUserUid}_${DateTime.now().millisecondsSinceEpoch}';
  }
}