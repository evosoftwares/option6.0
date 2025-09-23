import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_static_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/user_id_converter.dart';
import '/index.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:mapbox_search/mapbox_search.dart' as mapbox;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import '/actions/actions.dart' as action_blocks;
import 'main_motorista_model.dart';
export 'main_motorista_model.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

 class MainMotoristaWidget extends StatefulWidget {
  const MainMotoristaWidget({super.key});

  static String routeName = 'mainMotorista';
  static String routePath = '/mainMotorista';

  @override
  State<MainMotoristaWidget> createState() => _MainMotoristaWidgetState();
}

class _MainMotoristaWidgetState extends State<MainMotoristaWidget> {
  late MainMotoristaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  // Notificações e overlay de solicitação de corrida
  StreamSubscription<Map<String, dynamic>>? _notifSubscription;
  bool _showTripRequest = false;
  String? _currentNotificationId;
  String? _pendingTripRequestId;
  String? _originAddress;
  String? _destinationAddress;
  double? _estimatedFare;
  bool _isAccepting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainMotoristaModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.checkpassageiro = await AppUsersTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'fcm_token',
          currentUserUid,
        ),
      );
      if (_model.checkpassageiro?.firstOrNull?.userType == 'passenger') {
        context.pushNamed(MainPassageiroWidget.routeName);
        return;
      }

      // Verificar se os dados do veículo estão completos
      await actions.redirecionarParaVeiculoSeIncompleto(context);

      // Iniciar escuta de notificações em tempo real (Supabase)
      try {
        final stream = actions.SistemaNotificacoesTempoReal.instance
            .iniciarEscutaNotificacoes();
        _notifSubscription = stream.listen((notificacao) async {
          if (!mounted) return;
          final type = notificacao['type'] as String?;
          final data = (notificacao['data'] as Map<String, dynamic>?) ?? {};

          if (type == 'nova_corrida') {
            // Popular dados da solicitação
            _currentNotificationId = notificacao['id'] as String?;
            _pendingTripRequestId = data['trip_request_id'] as String?;
            _originAddress = data['origin_address'] as String?;
            _destinationAddress = data['destination_address'] as String?;
            final fare = data['estimated_fare'];
            if (fare is int) {
              _estimatedFare = fare.toDouble();
            } else if (fare is double) {
              _estimatedFare = fare;
            } else {
              _estimatedFare = null;
            }

            // Ajustar timer para o timeout fornecido (padrão 30s)
            final timeoutSeconds = (data['timeout_seconds'] is int)
                ? data['timeout_seconds'] as int
                : 30;
            _model.timerController.timer
                .setPresetTime(mSec: timeoutSeconds * 1000, add: false);
            _model.timerController.onResetTimer();
            _model.timerController.onStartTimer();

            safeSetState(() {
              _showTripRequest = true;
            });
          } else if (type == 'timeout_corrida') {
            // Ocultar overlay se for o mesmo pedido
            final trId = data['trip_request_id'] as String?;
            if (trId != null && trId == _pendingTripRequestId) {
              _model.timerController.onStopTimer();
              safeSetState(() {
                _showTripRequest = false;
              });
            }
          }
        });
      } catch (e) {
        // falha silenciosa para não quebrar UI
        debugPrint('Falha ao iniciar escuta de notificações: $e');
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    try {
      _notifSubscription?.cancel();
      actions.SistemaNotificacoesTempoReal.instance.pararEscutaNotificacoes();
    } catch (_) {}

    super.dispose();
  }

  List<Widget> _buildStackChildren(DriversRow? stackDriversRow) {
    List<Widget> children = [];

    // Background map
    children.add(
      Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: FlutterFlowStaticMap(
          location: LatLng(9.341465, -79.891704),
          apiKey: 'pk.eyJ1IjoiYWJyYW1zaHZpbGxpIiwiYSI6ImNrd2N6OGN1d2d3bGQyb3BnbzZnajV0MzMifQ.K8Oqewp1e0CZ6viw6T2yUA',
          style: mapbox.MapBoxStyle.Streets,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
          ),
          zoom: 12,
          tilt: 0,
          rotation: 0,
        ),
      ),
    );

    // Online button (Sair)
    if (stackDriversRow?.isOnline == true) {
      children.add(
        Align(
          alignment: AlignmentDirectional(-0.02, 0.72),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 22.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (_model.isTogglingOnline) return;
                _model.isTogglingOnline = true;
                safeSetState(() {});
                try {
                  // Guarda: impedir ações se for passageiro
                  final appUsers = await AppUsersTable().queryRows(
                    queryFn: (q) => q.eqOrNull('fcm_token', currentUserUid),
                  );
                  if (appUsers.firstOrNull?.userType == 'passenger') {
                    await action_blocks.alertaNegativo(
                      context,
                      mensagem:
                          'Ops! Este é o modo de motorista. Vamos te levar para a tela de passageiro.',
                    );
                    context.pushNamed(MainPassageiroWidget.routeName);
                    _model.isTogglingOnline = false;
                    safeSetState(() {});
                    return;
                  }

                  // Converter Firebase UID para Supabase UUID
                  final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
                  if (appUserId == null) {
                    await action_blocks.alertaNegativo(
                      context,
                      mensagem: 'Erro: Usuário não encontrado no sistema',
                    );
                    _model.isTogglingOnline = false;
                    safeSetState(() {});
                    return;
                  }

                  final updated = await DriversTable().update(
                    data: {'is_online': false},
                    matchingRows: (rows) => rows.eq('user_id', appUserId),
                    returnRows: true,
                  );
                  if (updated.isEmpty) {
                    // Apenas drivers podem criar row em drivers
                    if (appUsers.firstOrNull?.userType == 'driver') {
                      await DriversTable().insert({
                        'user_id': appUserId,
                        'email': currentUserEmail,
                        'is_online': false,
                        'created_at': DateTime.now().toUtc(),
                      });
                    }
                  }
                  await actions.pararRastreamentoOtimizado();
                  await action_blocks.alertaNegativo(
                    context,
                    mensagem: 'Você ficou offline',
                  );
                } catch (e) {
                  await action_blocks.alertaNegativo(
                    context,
                    mensagem: 'Erro ao sair: $e',
                  );
                } finally {
                  _model.isTogglingOnline = false;
                  safeSetState(() {});
                }
              },
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: Color(0xFFC00000),
                  shape: BoxShape.circle,
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Sair',
                      style: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .override(
                            font: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context)
                                .primaryBackground,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Offline button (Iniciar)
    if (stackDriversRow?.isOnline == false) {
      children.add(
        Align(
          alignment: AlignmentDirectional(0.0, 1.0),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 22.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (_model.isTogglingOnline) return;
                _model.isTogglingOnline = true;
                safeSetState(() {});
                try {
                  // Guarda: impedir ações se for passageiro
                  final appUsers = await AppUsersTable().queryRows(
                    queryFn: (q) => q.eqOrNull('fcm_token', currentUserUid),
                  );
                  if (appUsers.firstOrNull?.userType == 'passenger') {
                    await action_blocks.alertaNegativo(
                      context,
                      mensagem:
                          'Ops! Este é o modo de motorista. Vamos te levar para a tela de passageiro.',
                    );
                    context.pushNamed(MainPassageiroWidget.routeName);
                    _model.isTogglingOnline = false;
                    safeSetState(() {});
                    return;
                  }

                  // Converter Firebase UID para Supabase UUID
                  final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
                  if (appUserId == null) {
                    await action_blocks.alertaNegativo(
                      context,
                      mensagem: 'Erro: Usuário não encontrado no sistema',
                    );
                    _model.isTogglingOnline = false;
                    safeSetState(() {});
                    return;
                  }

                  final updated = await DriversTable().update(
                    data: {'is_online': true},
                    matchingRows: (rows) => rows.eq('user_id', appUserId),
                    returnRows: true,
                  );
                  if (updated.isEmpty) {
                    // Apenas drivers podem criar row em drivers
                    if (appUsers.firstOrNull?.userType == 'driver') {
                      await DriversTable().insert({
                        'user_id': appUserId,
                        'email': currentUserEmail,
                        'is_online': true,
                        'created_at': DateTime.now().toUtc(),
                      });
                    }
                  }
                  // Rastreamento em segundo plano é OBRIGATÓRIO para motoristas online
                  final backgroundTrackingStarted = await actions.locEmTempoReal(context);
                  if (backgroundTrackingStarted != true) {
                    // Forçar driver offline se não conseguir rastreamento em segundo plano
                    await DriversTable().update(
                      data: {'is_online': false},
                      matchingRows: (rows) => rows.eq('user_id', appUserId),
                    );

                    // Mostrar diálogo explicativo com orientações claras
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Permissão de Localização Necessária',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Para garantir a segurança dos passageiros e o funcionamento do aplicativo, é necessário:',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 12),
                                Text('1. Habilitar localização "Permitir o tempo todo"'),
                                Text('2. Conceder permissão para rastreamento em segundo plano'),
                                SizedBox(height: 12),
                                Text(
                                  'Sem essas permissões, você não pode ficar online como motorista.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: FlutterFlowTheme.of(context).error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Entendi'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Abrir configurações do sistema
                                openAppSettings();
                              },
                              child: Text('Abrir Configurações'),
                            ),
                          ],
                        );
                      },
                    );
                    safeSetState(() {});
                    return;
                  }

                  print('✅ Rastreamento em segundo plano iniciado com sucesso');
                  await action_blocks.snackSalvo(
                    context,
                    mensagem:
                        'Você ficará online e começará a receber corridas em breve',
                  );
                } catch (e) {
                  // Usar o appUserId já obtido anteriormente
                  final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
                  if (appUserId != null) {
                    await DriversTable().update(
                      data: {'is_online': false},
                      matchingRows: (rows) => rows.eq('user_id', appUserId),
                    );
                  }
                  // Parar qualquer rastreamento ativo em caso de erro
                  await actions.pararRastreamentoOtimizado();
                  await action_blocks.alertaNegativo(
                    context,
                    mensagem: 'Erro ao ficar online: $e',
                  );
                } finally {
                  _model.isTogglingOnline = false;
                  safeSetState(() {});
                }
              },
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: _model.isTogglingOnline ? const Color(0xFF6AA7FF) : const Color(0xFF006DFF),
                  shape: BoxShape.circle,
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _model.isTogglingOnline
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18.0,
                                height: 18.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Aguarde',
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      font: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          )
                        : Text(
                            'Iniciar',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  font: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Trip request overlay (temporarily disabled)
    // Exibir overlay quando houver nova solicitação de corrida
    if (_showTripRequest) {
      children.add(
        Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Material(
              color: Colors.transparent,
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 700),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nova Solicitação ',
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
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                          ),
                          Material(
                            color: Colors.transparent,
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FlutterFlowTimer(
                                      initialTime: _model.timerInitialTimeMs,
                                      getDisplayTime: (value) =>
                                          StopWatchTimer.getDisplayTime(
                                        value,
                                        hours: false,
                                        minute: false,
                                        milliSecond: false,
                                      ),
                                      controller: _model.timerController,
                                      updateStateInterval:
                                          Duration(milliseconds: 1000),
                                      onChanged: (value, displayTime, shouldUpdate) {
                                        _model.timerMilliseconds = value;
                                        _model.timerValue = displayTime;
                                        if (shouldUpdate) safeSetState(() {});
                                      },
                                      onEnded: () async {
                                        // Tempo esgotado: ocultar overlay
                                        if (_currentNotificationId != null) {
                                          await actions.SistemaNotificacoesTempoReal
                                              .instance
                                              .marcarComoLida(
                                                  _currentNotificationId!);
                                        }
                                        _model.timerController.onStopTimer();
                                        if (mounted) {
                                          safeSetState(() {
                                            _showTripRequest = false;
                                          });
                                        }
                                      },
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .override(
                                            font: GoogleFonts.roboto(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontStyle,
                                          ),
                                    ),
                                    Container(
                                      width: 60.0,
                                      height: 10.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFB2B2B2),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                      SizedBox(height: 14.0),
                      // Origem
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Color(0x2BEFF1F5),
                            size: 20.0,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Origem',
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        color: Color(0x6BFFFFFF),
                                        fontSize: 14.0,
                                        letterSpacing: 1.0,
                                        fontWeight:
                                            FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  _originAddress ?? '-',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        letterSpacing: 0.0,
                                        fontWeight:
                                            FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                      SizedBox(height: 12.0),
                      // Destino
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.flag_circle_sharp,
                            color: Color(0x2BEFF1F5),
                            size: 20.0,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Destino',
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        color: Color(0x6BFFFFFF),
                                        fontSize: 14.0,
                                        letterSpacing: 1.0,
                                        fontWeight:
                                            FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  _destinationAddress ?? '-',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        letterSpacing: 0.0,
                                        fontWeight:
                                            FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                      SizedBox(height: 14.0),
                      // Preço e ações
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Seu preço',
                                style: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight:
                                            FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .fontWeight,
                                        fontStyle:
                                            FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .fontStyle,
                                      ),
                                      color: Color(0x6BFFFFFF),
                                      fontSize: 14.0,
                                      letterSpacing: 1.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                _estimatedFare != null
                                    ? 'R\$ ${_estimatedFare!.toStringAsFixed(2)}'
                                    : 'R\$ --',
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      font: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontStyle:
                                            FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(height: 4.0)),
                          ),
                          // Action buttons
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FlutterFlowIconButton(
                                borderRadius: 24.0,
                                buttonSize: 48.0,
                                fillColor: Colors.black,
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  // Recusar/fechar
                                  if (_currentNotificationId != null) {
                                    await actions.SistemaNotificacoesTempoReal
                                        .instance
                                        .marcarComoLida(
                                            _currentNotificationId!);
                                  }
                                  _model.timerController.onStopTimer();
                                  if (mounted) {
                                    safeSetState(() {
                                      _showTripRequest = false;
                                    });
                                  }
                                },
                              ),
                              SizedBox(width: 12.0),
                              FFButtonWidget(
                                onPressed: () async {
                                  if (_isAccepting ||
                                      _pendingTripRequestId == null) return;
                                  setState(() => _isAccepting = true);
                                  final result = await actions
                                      .aceitarViagemSupabase(
                                    tripRequestId: _pendingTripRequestId!,
                                    context: context,
                                  );
                                  if (result['sucesso'] == true) {
                                    if (_currentNotificationId != null) {
                                      await actions
                                          .SistemaNotificacoesTempoReal
                                          .instance
                                          .marcarComoLida(
                                              _currentNotificationId!);
                                    }
                                    _model.timerController.onStopTimer();
                                    if (mounted) {
                                      safeSetState(() {
                                        _showTripRequest = false;
                                      });
                                    }
                                    // Navegar para tela de rota
                                    context.pushNamed(
                                        ACaminhoDoPassageiroWidget.routeName);
                                  } else {
                                    await action_blocks.alertaNegativo(
                                      context,
                                      mensagem: (result['erro'] as String?) ??
                                          'Não foi possível aceitar a corrida.',
                                    );
                                  }
                                  if (mounted) {
                                    setState(() => _isAccepting = false);
                                  }
                                },
                                text: _isAccepting
                                    ? 'Aceitando...'
                                    : 'Aceitar Corrida',
                                options: FFButtonOptions(
                                  height: 48.0,
                                  padding: EdgeInsets.all(0.0),
                                  iconPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFF2AAD22),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        letterSpacing: 0.0,
                                      ),
                                  borderSide: BorderSide(width: 0.0),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ].divide(SizedBox(height: 16.0)),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Top header with earnings and menu
    children.add(
      Align(
        alignment: AlignmentDirectional(0.0, -1.0),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 11.0, 0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(11.0, 9.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<List<DriverWalletsRow>>(
                        stream: _model.containerSupabaseStream ??=
                            SupaFlow.client
                                .from("driver_wallets")
                                .stream(primaryKey: ['id'])
                                .eqOrNull('driver_id', currentUserUid)
                                .map((list) => list
                                    .map((item) => DriverWalletsRow(item))
                                    .toList()),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
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
                          return Material(
                            color: Colors.transparent,
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ganhos de hoje',
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
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .fontStyle,
                                          ),
                                    ),
                                    Text(
                                      'R\$ 123,45',
                                      style: FlutterFlowTheme.of(context)
                                          .displaySmall
                                          .override(
                                            font: GoogleFonts.roboto(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FlutterFlowTheme.of(context)
                                                  .displaySmall
                                                  .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FlutterFlowTheme.of(context)
                                                .displaySmall
                                                .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 11.0, 0.0),
                child: FlutterFlowIconButton(
                  borderColor: Color(0x1F000000),
                  borderRadius: 100.0,
                  borderWidth: 1.0,
                  buttonSize: 50.78,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  icon: Icon(
                    Icons.menu,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(MenuMotoristaWidget.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: FutureBuilder<List<DriversRow>>(
          future: DriversTable().querySingleRow(
            queryFn: (q) => q.eqOrNull(
              'user_id',
              currentUserUid,
            ),
          ),
          builder: (context, snapshot) {
            // Customize what your widget looks like when it's loading.
            if (!snapshot.hasData) {
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
            List<DriversRow> stackDriversRowList = snapshot.data!;

            final stackDriversRow = stackDriversRowList.isNotEmpty
                ? stackDriversRowList.first
                : null;

            return Stack(
              children: _buildStackChildren(stackDriversRow),
            );
          },
        ),
      ),
    );
  }
}
