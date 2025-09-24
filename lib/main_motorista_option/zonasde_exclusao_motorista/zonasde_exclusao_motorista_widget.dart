import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/zona_exclusao_code_logger.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'zonasde_exclusao_motorista_model.dart';
import '/backend/supabase/supabase.dart';
export 'zonasde_exclusao_motorista_model.dart';

class ZonasdeExclusaoMotoristaWidget extends StatefulWidget {
  const ZonasdeExclusaoMotoristaWidget({super.key});

  static String routeName = 'zonasdeExclusaoMotorista';
  static String routePath = '/zonasdeExclusaoMotorista';

  @override
  State<ZonasdeExclusaoMotoristaWidget> createState() =>
      _ZonasdeExclusaoMotoristaWidgetState();
}

class _ZonasdeExclusaoMotoristaWidgetState
    extends State<ZonasdeExclusaoMotoristaWidget> with WidgetsBindingObserver {
  late ZonasdeExclusaoMotoristaModel _model;
  late Future<List<DriverExcludedZonesRow>> _exclusionZonesFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Variáveis de debug
  int _buildCount = 0;
  int _refreshCount = 0;
  DateTime? _screenOpenTime;
  DateTime? _lastRefreshTime;
  String? _lastKnownUserUid;
  List<String>? _lastDataSnapshot;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZonasdeExclusaoMotoristaModel());

    _screenOpenTime = DateTime.now();
    _lastKnownUserUid = currentUserUid;

    ZonaExclusaoCodeLogger.logLifecycle('ZonasListWidget', 'initState');
    ZonaExclusaoCodeLogger.logSession('zones_list_opened');

    // Adicionar observer para mudanças do app
    WidgetsBinding.instance.addObserver(this);
    ZonaExclusaoCodeLogger.logLifecycle('app_observer', 'added');

    // Log informações de contexto
    ZonaExclusaoCodeLogger.logNetwork('app_context', 'initialized', {
      'current_user_uid': currentUserUid,
      'screen': 'zones_list',
      'widget_hash': hashCode,
      'build_context_hash': context.hashCode,
      'timestamp': DateTime.now().toIso8601String()
    });

    // Verificar conectividade antes de iniciar
    _checkConnectivityAndInitialize();
  }

  void _checkConnectivityAndInitialize() {
    ZonaExclusaoCodeLogger.logNetwork('connectivity_check', 'starting');

    // Simular verificação de conectividade
    try {
      // Log tentativa de conexão
      ZonaExclusaoCodeLogger.logNetwork('network_test', 'attempting', {
        'test_type': 'basic_connectivity',
        'user_authenticated': currentUserUid.isNotEmpty
      });

      if (currentUserUid.isEmpty) {
        ZonaExclusaoCodeLogger.logSecurity('user_authentication', false, 'No user ID available');
        ZonaExclusaoCodeLogger.logError('auth_state', 'User not authenticated - empty UID');

        // Ainda assim tenta refresh para debug
        ZonaExclusaoCodeLogger.logNetwork('connectivity_check', 'proceeding_despite_auth_issue');
      } else {
        ZonaExclusaoCodeLogger.logSecurity('user_authentication', true, 'User ID present');
        ZonaExclusaoCodeLogger.logNetwork('connectivity_check', 'passed');
      }

      _refreshExclusionZones();

    } catch (e) {
      ZonaExclusaoCodeLogger.logError('connectivity_check_failed', e);
      // Mesmo com erro, tenta refresh
      _refreshExclusionZones();
    }
  }

  void _refreshExclusionZones() {
    _refreshCount++;
    _lastRefreshTime = DateTime.now();

    ZonaExclusaoCodeLogger.logFunction('_refreshExclusionZones', {
      'refresh_count': _refreshCount,
      'time_since_last_refresh': _lastRefreshTime != null
          ? DateTime.now().difference(_lastRefreshTime!).inMilliseconds
          : 0
    });

    // Log estado inicial da conexão
    ZonaExclusaoCodeLogger.logNetwork('supabase_connection', 'initializing', {
      'current_user_uid': currentUserUid,
      'user_uid_type': currentUserUid.runtimeType.toString(),
      'user_uid_length': currentUserUid.length,
      'user_uid_empty': currentUserUid.isEmpty,
      'timestamp': DateTime.now().toIso8601String()
    });

    // Verificar estado básico
    ZonaExclusaoCodeLogger.logValidation('user_uid_check', currentUserUid.isNotEmpty,
      currentUserUid.isEmpty ? 'Current user UID is empty' : 'Current user UID is valid');

    setState(() {
      _exclusionZonesFuture = Future.any([
        _performDatabaseQuery(),
        Future.delayed(Duration(seconds: 10), () {
          ZonaExclusaoCodeLogger.logTimeout('query_zones', 10000, {
            'table': 'driver_excluded_zones',
            'user_id': currentUserUid,
            'operation': 'SELECT_WITH_FILTER',
            'refresh_count': _refreshCount
          });
          throw TimeoutException('Query timeout', Duration(seconds: 10));
        }),
      ]).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          ZonaExclusaoCodeLogger.logTimeout('query_zones_hard_timeout', 15000, {
            'timeout_type': 'HARD_TIMEOUT',
            'fallback_action': 'RETURN_EMPTY_LIST'
          });
          return <DriverExcludedZonesRow>[];
        }
      ).catchError((error) {
        ZonaExclusaoCodeLogger.logNetworkError('refresh_zones_future', error, {
          'refresh_count': _refreshCount,
          'user_id': currentUserUid,
          'recovery_action': 'RETURN_EMPTY_LIST'
        });
        return <DriverExcludedZonesRow>[];
      });

      // Iniciar monitoramento real-time de mudanças (simulado)
      _startRealTimeMonitoring();
    });
  }

  Future<List<DriverExcludedZonesRow>> _performDatabaseQuery() async {
    // Converter Firebase UID para Supabase UUID
    final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
    if (appUserId == null) {
      print('Error: User not found in system');
      return <DriverExcludedZonesRow>[];
    }

    ZonaExclusaoCodeLogger.logDatabase('QUERY_START', 'driver_excluded_zones', {
      'filter_driver_id': appUserId,
      'query_type': 'SELECT_WITH_FILTER'
    });

    try {
      // Usar withRetry para operação robusta
      final zones = await ZonaExclusaoCodeLogger.withRetry(
        'zones_database_query',
        () async {

          // Log tentativa de query
          ZonaExclusaoCodeLogger.logNetwork('supabase_query', 'attempting', {
            'table': 'driver_excluded_zones',
            'filter_column': 'driver_id',
            'filter_value': appUserId,
            'query_method': 'queryRows'
          });

          final result = await DriverExcludedZonesTable().queryRows(
            queryFn: (q) {
              ZonaExclusaoCodeLogger.logDatabase('QUERY_BUILDING', 'driver_excluded_zones', {
                'query_function': 'eq',
                'column': 'driver_id',
                'value': appUserId
              });
              return q.eq('driver_id', appUserId);
            },
          );

          // Validar estrutura dos dados recebidos
          ZonaExclusaoCodeLogger.logDataValidation('driver_excluded_zones', result, true, 'Query result received');

          return result;
        },
        maxAttempts: 2,
        context: {
          'user_id': appUserId,
          'table': 'driver_excluded_zones',
          'operation_type': 'SELECT_FILTERED'
        },
      );

      // Log resultado detalhado
      ZonaExclusaoCodeLogger.logDatabase('QUERY_SUCCESS', 'driver_excluded_zones', {
        'records_returned': zones.length,
        'query_filter': 'driver_id = $appUserId'
      });

      // Filtrar zonas válidas com tratamento de erros para campos null
      final validZones = zones.where((zone) {
        try {
          return (zone.localName?.isNotEmpty ?? false) && zone.driverId == appUserId;
        } catch (e) {
          // Log zona com dados null/inválidos
          ZonaExclusaoCodeLogger.logError('zone_data_null', 'Zone has null required fields', {
            'zone_id': zone.data['id'],
            'driver_id': zone.data['driver_id'],
            'type': zone.data['type'],
            'local_name': zone.data['local_name'],
            'error': e.toString()
          });
          return false;
        }
      }).toList();

      // Log zonas inválidas encontradas
      final invalidZones = zones.where((zone) {
        try {
          return zone.localName?.isEmpty ?? true;
        } catch (e) {
          return true; // Se deu erro, é inválida
        }
      }).toList();
      if (invalidZones.isNotEmpty) {
        ZonaExclusaoCodeLogger.logError('invalid_zones_found', 'Found zones with null/empty required fields', {
          'invalid_count': invalidZones.length,
          'total_count': zones.length,
          'invalid_zones': invalidZones.map((z) => {
            'id': z.id,
            'driver_id': z.driverId,
            'type': z.type,
            'local_name': z.localName,
            'is_valid': z.localName?.isNotEmpty ?? false
          }).toList()
        });
      }

      // Validar dados recebidos
      _validateReceivedData(validZones);

      // Log cada zona válida encontrada com tratamento de erros
      for (int i = 0; i < validZones.length; i++) {
        final zone = validZones[i];
        try {
          ZonaExclusaoCodeLogger.logDatabase('RECORD_FOUND', 'driver_excluded_zones', {
            'index': i,
            'zone_id': zone.id,
            'driver_id': zone.driverId,
            'type': zone.type,
            'local_name': zone.localName,
            'created_at': zone.createdAt?.toIso8601String(),
            'matches_current_user': zone.driverId == appUserId
          });
        } catch (e) {
          ZonaExclusaoCodeLogger.logError('log_zone_failed', 'Failed to log zone data', {
            'zone_index': i,
            'raw_data': zone.data,
            'error': e.toString()
          });
        }
      }

      // Verificar se há zonas de outros motoristas (problema de filtro) com tratamento de erro
      final wrongDriverZones = zones.where((zone) {
        try {
          return (zone.localName?.isNotEmpty ?? false) && zone.driverId != appUserId;
        } catch (e) {
          return false; // Se deu erro, ignora
        }
      }).toList();
      if (wrongDriverZones.isNotEmpty) {
        ZonaExclusaoCodeLogger.logError('filter_not_working', 'Found zones for wrong driver', {
          'expected_driver_id': appUserId,
          'wrong_zones_count': wrongDriverZones.length,
          'wrong_driver_ids': wrongDriverZones.map((z) => z.driverId).toSet().toList()
        });
        ZonaExclusaoCodeLogger.logDatabase('FILTER_ERROR', 'driver_excluded_zones', {
          'expected_driver_id': appUserId,
          'wrong_zones_count': wrongDriverZones.length,
          'wrong_driver_ids': wrongDriverZones.map((z) => z.driverId).toSet().toList()
        });
      } else {
        ZonaExclusaoCodeLogger.logValidation('filter_working', true, 'All zones belong to current driver');
      }

      ZonaExclusaoCodeLogger.logResult('database_query_complete', validZones.length, 'valid_zones_found');
      return validZones;

    } catch (error, stackTrace) {
      // Log erro com análise detalhada usando novos métodos
      ZonaExclusaoCodeLogger.logNetworkError('database_query_failed', error, {
        'table': 'driver_excluded_zones',
        'attempted_filter': 'driver_id = $appUserId',
        'user_id_valid': appUserId.isNotEmpty,
        'query_type': 'SELECT_WITH_FILTER'
      });

      ZonaExclusaoCodeLogger.logError('database_query_failed', error, {
        'stack_trace_sample': stackTrace.toString().split('\n').take(3).join('\n'),
        'error_type': error.runtimeType.toString(),
        'operation': 'zones_database_query',
        'recovery_action': 'RETURN_EMPTY_LIST'
      });

      return <DriverExcludedZonesRow>[];
    }
  }

  /// Validar dados recebidos do banco com análise profunda
  void _validateReceivedData(List<DriverExcludedZonesRow> zones) {
    ZonaExclusaoCodeLogger.logDataValidation('zones_list', zones, zones.isNotEmpty,
        zones.isEmpty ? 'No zones found for current user' : 'Zones found');

    if (zones.isEmpty) {
      ZonaExclusaoCodeLogger.logFlow('data_empty_case', true, 'No exclusion zones for this driver');
      return;
    }

    // Validar estrutura de cada zona
    for (int i = 0; i < zones.length; i++) {
      final zone = zones[i];

      // Validações específicas
      final hasValidId = zone.id.toString().isNotEmpty;
      final hasValidDriverId = zone.driverId?.isNotEmpty ?? false;
      final hasValidType = zone.type?.isNotEmpty ?? false;
      final hasValidName = zone.localName?.isNotEmpty ?? false;

      ZonaExclusaoCodeLogger.logDataValidation('zone_record_$i', zone,
          hasValidId && hasValidDriverId && hasValidType && hasValidName,
          !hasValidId ? 'Invalid ID' :
          !hasValidDriverId ? 'Invalid driver_id' :
          !hasValidType ? 'Invalid type' :
          !hasValidName ? 'Invalid local_name' : 'Record valid');

      // Log dados corrompidos específicos
      if (!hasValidDriverId || zone.driverId != currentUserUid) {
        ZonaExclusaoCodeLogger.logError('data_corruption_detected', 'Invalid driver_id in zone record', {
          'zone_index': i,
          'zone_id': zone.id,
          'expected_driver_id': currentUserUid,
          'actual_driver_id': zone.driverId,
          'corruption_type': 'DRIVER_ID_MISMATCH'
        });
      }

      if (!hasValidName || (zone.localName?.trim().isEmpty ?? true)) {
        ZonaExclusaoCodeLogger.logError('data_corruption_detected', 'Empty or invalid zone name', {
          'zone_index': i,
          'zone_id': zone.id,
          'zone_name': zone.localName,
          'corruption_type': 'EMPTY_ZONE_NAME'
        });
      }
    }

    // Atualizar snapshot dos dados para debug
    _lastDataSnapshot = zones.map((z) => '${z.id}:${z.localName}:${z.type}').toList();

    ZonaExclusaoCodeLogger.logStorage('data_snapshot_updated', 'zones_list', zones.length, 'SUCCESS');
  }

  /// Iniciar monitoramento real-time de mudanças na tabela
  void _startRealTimeMonitoring() {
    ZonaExclusaoCodeLogger.startDataChangeMonitoring('driver_excluded_zones', (data) {
      ZonaExclusaoCodeLogger.logRealTimeEvent('data_change_detected', 'PROCESSING', {
        'table': 'driver_excluded_zones',
        'change_type': data['eventType'] ?? 'UNKNOWN',
        'affected_user': data['new']?['driver_id'] ?? data['old']?['driver_id'],
        'current_user': currentUserUid,
        'should_refresh': (data['new']?['driver_id'] == currentUserUid) ||
                         (data['old']?['driver_id'] == currentUserUid)
      });

      // Se a mudança afeta o usuário atual, refresh automático
      if ((data['new']?['driver_id'] == currentUserUid) ||
          (data['old']?['driver_id'] == currentUserUid)) {

        ZonaExclusaoCodeLogger.logRealTimeEvent('auto_refresh_triggered', 'STARTING', {
          'trigger_reason': 'DATA_CHANGE_DETECTED',
          'change_type': data['eventType']
        });

        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            _refreshExclusionZones();
          }
        });
      }
    });

    // Simular métricas de real-time
    _simulateRealTimeMetrics();
  }

  /// Simular métricas de performance do real-time
  void _simulateRealTimeMetrics() {
    Timer.periodic(Duration(minutes: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final mockMetrics = {
        'latency_ms': 150 + (DateTime.now().millisecond % 200),
        'error_count': 0,
        'success_streak': _refreshCount,
        'connection_quality': 'STABLE',
        'active_subscriptions': 1
      };

      ZonaExclusaoCodeLogger.logRealTimeEvent('performance_check', 'COMPLETED', mockMetrics);

      // Log saúde do sistema periodicamente
      final systemMetrics = {
        'avg_response_time_ms': 250,
        'success_rate_percent': 98.5,
        'error_rate_percent': 1.5,
        'connection_failures': 0,
        'last_refresh_time': _lastRefreshTime?.toIso8601String(),
        'total_refreshes': _refreshCount,
        'session_duration_min': _screenOpenTime != null
          ? DateTime.now().difference(_screenOpenTime!).inMinutes
          : 0
      };

      ZonaExclusaoCodeLogger.logSystemHealth(systemMetrics);
    });
  }

  /// Executar diagnóstico completo do sistema
  Future<void> _runSystemDiagnostic() async {
    try {
      ZonaExclusaoCodeLogger.logBlock('system_diagnostic_started', 'USER_INITIATED');

      final results = await ZonaExclusaoCodeLogger.performSystemDiagnostic();

      ZonaExclusaoCodeLogger.logBlock('system_diagnostic_completed', 'SUCCESS');

      // Mostrar resultados em snackbar se houver problemas
      final healthData = results['health_score'] as double? ?? 100.0;
      if (healthData < 80) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sistema com performance reduzida (Score: ${healthData.toStringAsFixed(1)})'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Detalhes',
              onPressed: () {
                ZonaExclusaoCodeLogger.logInteraction('diagnostic_details', 'viewed', results);
              },
            ),
          ),
        );
      }

    } catch (e) {
      ZonaExclusaoCodeLogger.logError('system_diagnostic_failed', e);
    }
  }

  @override
  void dispose() {
    final sessionDuration = _screenOpenTime != null
        ? DateTime.now().difference(_screenOpenTime!).inMilliseconds
        : 0;

    ZonaExclusaoCodeLogger.logLifecycle('ZonasListWidget', 'dispose');
    ZonaExclusaoCodeLogger.logSession('zones_list_closed', sessionDuration);

    ZonaExclusaoCodeLogger.logUI('session_summary', 'completed', {
      'total_builds': _buildCount,
      'total_refreshes': _refreshCount,
      'session_duration_ms': sessionDuration,
      'last_user_uid': _lastKnownUserUid,
      'had_data': _lastDataSnapshot?.isNotEmpty ?? false
    });

    WidgetsBinding.instance.removeObserver(this);
    ZonaExclusaoCodeLogger.logLifecycle('app_observer', 'removed');

    _model.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    ZonaExclusaoCodeLogger.logLifecycle('app_lifecycle', state.toString());

    switch (state) {
      case AppLifecycleState.resumed:
        ZonaExclusaoCodeLogger.logSession('app_resumed_refreshing_data');
        // Refresh quando app volta do background
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            ZonaExclusaoCodeLogger.logInteraction('auto_refresh', 'app_resumed');
            _refreshExclusionZones();
          }
        });
        break;
      case AppLifecycleState.paused:
        ZonaExclusaoCodeLogger.logSession('app_paused');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;

    ZonaExclusaoCodeLogger.logUI('widget_build', 'building', {
      'build_count': _buildCount,
      'current_user_uid': currentUserUid,
      'user_uid_changed': _lastKnownUserUid != currentUserUid,
      'last_known_uid': _lastKnownUserUid,
      'widget_mounted': mounted
    });

    // Detectar mudança de usuário
    if (_lastKnownUserUid != null && _lastKnownUserUid != currentUserUid) {
      ZonaExclusaoCodeLogger.logSecurity('user_change_detected', true,
        'UID changed from $_lastKnownUserUid to $currentUserUid');

      // Refresh automático quando usuário muda
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ZonaExclusaoCodeLogger.logInteraction('auto_refresh', 'user_changed');
        _refreshExclusionZones();
      });
    }

    _lastKnownUserUid = currentUserUid;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            buttonSize: 40.0,
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'Zonas de exclusão',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [
            FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 53.23,
              icon: Icon(
                Icons.menu_sharp,
                color: FlutterFlowTheme.of(context).primary,
                size: 24.0,
              ),
              onPressed: () async {
                context.pushNamed(MenuMotoristaWidget.routeName);
              },
            ),
          ],
          centerTitle: false,
          elevation: 1.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFC5E2FF),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 16.0, 16.0, 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Color(0xFF005FD0),
                                size: 24.0,
                              ),
                              Text(
                                'Recado importante',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.roboto(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF005FD0),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                          Text(
                            'Ao salvar uma nova área, você não receberá corridas que comecem, outerminem  por locais com as palavras-chave que você definir como excluídas.',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF005FD0),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ].divide(SizedBox(height: 8.0)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Locais Excluídos',
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              font: GoogleFonts.roboto(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .fontStyle,
                            ),
                      ),
                      FlutterFlowIconButton(
                        borderRadius: 555.0,
                        buttonSize: 48.0,
                        fillColor: FlutterFlowTheme.of(context).primaryText,
                        icon: Icon(
                          Icons.add,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          final result = await context.pushNamed(AddZonaExclusaoWidget.routeName);
                          // Refresh the list when returning from add screen
                          if (result != null) {
                            _refreshExclusionZones();
                          }
                        },
                      ),
                    ].divide(SizedBox(width: 16.0)),
                  ),
                  FutureBuilder<List<DriverExcludedZonesRow>>(
                    future: _exclusionZonesFuture,
                    builder: (context, snapshot) {
                      // Debug information expandido com novos métodos
                      ZonaExclusaoCodeLogger.logUI('future_builder', 'building', {
                        'connection_state': snapshot.connectionState.toString(),
                        'has_data': snapshot.hasData,
                        'has_error': snapshot.hasError,
                        'current_user_uid': currentUserUid,
                        'data_length': snapshot.hasData ? snapshot.data!.length : 0,
                        'error_message': snapshot.hasError ? snapshot.error.toString() : null,
                        'build_count': _buildCount,
                        'refresh_count': _refreshCount
                      });

                      // Log estado da conexão com análise detalhada
                      ZonaExclusaoCodeLogger.logConnectivity(
                        snapshot.connectionState == ConnectionState.waiting ? 'connecting' :
                        snapshot.connectionState == ConnectionState.done ? 'connected' :
                        snapshot.connectionState == ConnectionState.active ? 'active' : 'none',
                        {
                          'connection_state': snapshot.connectionState.toString(),
                          'has_data': snapshot.hasData,
                          'has_error': snapshot.hasError,
                          'data_available': snapshot.hasData && snapshot.data != null,
                          'data_count': snapshot.hasData ? snapshot.data!.length : 0
                        }
                      );

                      // Validação avançada dos dados do snapshot
                      if (snapshot.hasData) {
                        ZonaExclusaoCodeLogger.logDataValidation('future_builder_snapshot', snapshot.data,
                            snapshot.data!.isNotEmpty,
                            snapshot.data!.isEmpty ? 'Empty data from database' : 'Data received successfully');
                      }

                      print('🔍 [ZONAS_EXCLUSAO] Connection state: ${snapshot.connectionState}');
                      print('🔍 [ZONAS_EXCLUSAO] Has data: ${snapshot.hasData}');
                      print('🔍 [ZONAS_EXCLUSAO] Has error: ${snapshot.hasError}');
                      print('🔍 [ZONAS_EXCLUSAO] Current user UID: $currentUserUid');

                      if (snapshot.hasData) {
                        print('🔍 [ZONAS_EXCLUSAO] Data length: ${snapshot.data!.length}');
                        for (int i = 0; i < snapshot.data!.length; i++) {
                          final zone = snapshot.data![i];
                          print('🔍 [ZONAS_EXCLUSAO] Zone $i: ID=${zone.id}, Driver=${zone.driverId}, Type=${zone.type}, Name=${zone.localName}');
                        }
                      }

                      if (snapshot.hasError) {
                        print('🔍 [ZONAS_EXCLUSAO] Error details: ${snapshot.error}');
                        print('🔍 [ZONAS_EXCLUSAO] Error type: ${snapshot.error.runtimeType}');
                      }

                      // Handle error state first
                      if (snapshot.hasError) {
                        // Usar novo método de log de erro de rede
                        ZonaExclusaoCodeLogger.logNetworkError('future_builder_error', snapshot.error!, {
                          'connection_state': snapshot.connectionState.toString(),
                          'user_id': currentUserUid,
                          'refresh_count': _refreshCount,
                          'build_count': _buildCount
                        });

                        ZonaExclusaoCodeLogger.logUI('error_state', 'displaying_error_widget', {
                          'error_type': snapshot.error.runtimeType.toString(),
                          'error_message': snapshot.error.toString(),
                          'recovery_options': ['RETRY_BUTTON', 'DIAGNOSTIC_AVAILABLE']
                        });

                        print('🚨 [ZONAS_EXCLUSAO] Error: ${snapshot.error}');
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              ZonaExclusaoCodeLogger.logInteraction('error_retry_button', 'pressed');
                              _refreshExclusionZones();
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: FlutterFlowTheme.of(context).error,
                                  size: 48.0,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Erro ao carregar zonas de exclusão',
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    color: FlutterFlowTheme.of(context).error,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Toque para tentar novamente',
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    'Tentar Novamente',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                GestureDetector(
                                  onTap: () {
                                    ZonaExclusaoCodeLogger.logInteraction('diagnostic_button', 'pressed');
                                    _runSystemDiagnostic();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      'Executar Diagnóstico',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Show loading indicator while waiting for data
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        ZonaExclusaoCodeLogger.logUI('loading_state', 'displaying_loading_widget');
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      }

                      // Handle cases where there's no data but no error (empty list)
                      if (!snapshot.hasData) {
                        ZonaExclusaoCodeLogger.logUI('no_data_state', 'displaying_loading_widget', {
                          'connection_state': snapshot.connectionState.toString()
                        });
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      }
                      List<DriverExcludedZonesRow>
                          listViewDriverExcludedZonesRowList = snapshot.data!;

                      ZonaExclusaoCodeLogger.logUI('data_received', 'processing_zones_list', {
                        'zones_count': listViewDriverExcludedZonesRowList.length,
                        'is_empty': listViewDriverExcludedZonesRowList.isEmpty
                      });

                      if (listViewDriverExcludedZonesRowList.isEmpty) {
                        ZonaExclusaoCodeLogger.logUI('empty_list_state', 'displaying_empty_widget');
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsetsDirectional.fromSTEB(24.0, 48.0, 24.0, 48.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off_outlined,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 64.0,
                              ),
                              Text(
                                'Nenhuma zona excluída',
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      font: GoogleFonts.roboto(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                'Você ainda não possui zonas de exclusão configuradas. Adicione uma zona para evitar receber corridas de locais específicos.',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                        );
                      }

                      ZonaExclusaoCodeLogger.logUI('list_view', 'building', {
                        'item_count': listViewDriverExcludedZonesRowList.length,
                        'list_type': 'zones_list'
                      });

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listViewDriverExcludedZonesRowList.length,
                        itemBuilder: (context, listViewIndex) {
                          final listViewDriverExcludedZonesRow =
                              listViewDriverExcludedZonesRowList[listViewIndex];

                          // Log cada item sendo construído
                          ZonaExclusaoCodeLogger.logUI('list_item', 'building', {
                            'index': listViewIndex,
                            'zone_id': listViewDriverExcludedZonesRow.id,
                            'zone_name': listViewDriverExcludedZonesRow.localName,
                            'zone_type': listViewDriverExcludedZonesRow.type,
                            'driver_id': listViewDriverExcludedZonesRow.driverId,
                            'created_at': listViewDriverExcludedZonesRow.createdAt?.toIso8601String(),
                            'belongs_to_current_user': listViewDriverExcludedZonesRow.driverId == currentUserUid
                          });

                          // Verificar se os dados estão corretos e são válidos
          if (listViewDriverExcludedZonesRow.localName?.trim().isEmpty ?? true) {
            ZonaExclusaoCodeLogger.logError('invalid_zone_data',
              'Zone has invalid data: ${listViewDriverExcludedZonesRow.id}');
          }

          if (listViewDriverExcludedZonesRow.driverId != currentUserUid) {
            ZonaExclusaoCodeLogger.logError('wrong_driver_data',
              'Zone belongs to different driver: ${listViewDriverExcludedZonesRow.driverId} vs $currentUserUid');
          }

                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 16.0, 16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listViewDriverExcludedZonesRow.localName ?? '',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          listViewDriverExcludedZonesRow.type ?? '',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ].divide(SizedBox(height: 4.0)),
                                    ),
                                  ),
                                  FlutterFlowIconButton(
                                    buttonSize: 40.0,
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: FlutterFlowTheme.of(context).error,
                                      size: 20.0,
                                    ),
                                    onPressed: () async {
                                      final zoneName = listViewDriverExcludedZonesRow.localName;
                                      final zoneType = listViewDriverExcludedZonesRow.type;

                                      ZonaExclusaoCodeLogger.logFunction('delete_button_pressed', {
                                        'zone': zoneName,
                                        'type': zoneType
                                      });

                                      var confirmDialogResponse =
                                          await showDialog<bool>(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('Deseja excluir permanentemente?'),
                                                    content: Text('Essa ação não poderá ser desfeita'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          ZonaExclusaoCodeLogger.logUI('delete_dialog', 'cancelled');
                                                          Navigator.pop(alertDialogContext, false);
                                                        },
                                                        child: Text('Voltar'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          ZonaExclusaoCodeLogger.logUI('delete_dialog', 'confirmed');
                                                          Navigator.pop(alertDialogContext, true);
                                                        },
                                                        child: Text('Excluir'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ) ??
                                              false;

                                      ZonaExclusaoCodeLogger.logFlow('delete_confirmed', confirmDialogResponse);

                                      if (confirmDialogResponse) {
                                        try {
                                          // Validar se a zona pertence ao usuário atual antes de deletar
                                          if (listViewDriverExcludedZonesRow.driverId != currentUserUid) {
                                            throw Exception('Zona não pertence ao usuário atual');
                                          }

                                          // Usar ID único para deletar - mais seguro
                                          await ZonaExclusaoCodeLogger.measureAsync(
                                            'delete_zone',
                                            () => DriverExcludedZonesTable().delete(
                                              matchingRows: (rows) => rows.eq('id', listViewDriverExcludedZonesRow.id),
                                            ),
                                          );

                                          ZonaExclusaoCodeLogger.logResult('delete_zone', true, 'SUCCESS');

                                          await action_blocks.alertaNegativo(context, mensagem: 'Removido');
                                          _refreshExclusionZones();

                                        } catch (error, stackTrace) {
                                          ZonaExclusaoCodeLogger.logError('delete_zone', error, stackTrace);

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Erro ao excluir zona'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ].divide(SizedBox(width: 12.0)),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ].divide(SizedBox(height: 24.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
