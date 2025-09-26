import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/custom_code/actions/index.dart' as actions;
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
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/location_service.dart';
// import '/flutter_flow/user_id_converter.dart';

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
  String? _appUserId;

  // Helper para formatar moeda no padrão BRL: R$X,XX (sem espaço, vírgula decimal)
  String formatBRL(num? value, {String placeholder = 'R\$0,00'}) {
    if (value == null) return placeholder;
    final formatted = formatNumber(
      value,
      formatType: FormatType.decimal,
      decimalType: DecimalType.commaDecimal,
      currency: 'BRL',
    );
    // Garantir ausência de espaços entre símbolo e valor
    return 'R\$' + formatted.replaceAll(' ', '');
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainMotoristaModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
      if (appUserId != null) {
        _model.checkpassageiro = await AppUsersTable().queryRows(
          queryFn: (q) => q.eqOrNull('id', appUserId),
        );
        final ut0 = _model.checkpassageiro?.firstOrNull?.userType?.toLowerCase();
        if (ut0 == 'passenger' || ut0 == 'passageiro') {
          context.goNamed(MainPassageiroWidget.routeName);
          return;
        }
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

      // Compute appUserId for streams and queries (com fallback por email)
      var appUserIdInit = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
      if (appUserIdInit == null && currentUserEmail.trim().isNotEmpty) {
        try {
          final byEmail = await AppUsersTable().queryRows(
            queryFn: (q) => q.eq('email', currentUserEmail.trim()).limit(1),
          );
          if (byEmail.isNotEmpty) {
            appUserIdInit = byEmail.first.id;
          }
        } catch (_) {}
      }
      _appUserId = appUserIdInit;
      debugPrint('MAIN_MOTORISTA: appUserId resolved -> $_appUserId (from currentUserUid=$currentUserUid)');

      WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
    });
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

  // Helper: verifica se um ponto (lat, lng) está dentro dos bounds (com suporte ao antimeridiano)
  bool _boundsContainsLatLng(LatLngBounds bounds, double lat, double lng) {
    final sw = bounds.southwest;
    final ne = bounds.northeast;
    final withinLat = lat >= sw.latitude && lat <= ne.latitude;
    final crossesAntimeridian = sw.longitude > ne.longitude;
    final withinLng = crossesAntimeridian
        ? (lng >= sw.longitude || lng <= ne.longitude)
        : (lng >= sw.longitude && lng <= ne.longitude);
    return withinLat && withinLng;
  }

  // Aguarda o GoogleMap estar realmente pronto no Android antes de enviar comandos pela channel
  Future<bool> _ensureMapReady(GoogleMapController controller, {int retries = 10}) async {
    for (var i = 0; i < retries; i++) {
      try {
        // Se a chamada não lançar exceção, consideramos o mapa pronto.
        await controller.getVisibleRegion();
        return true;
      } catch (e) {
        debugPrint('[MAP_READY] getVisibleRegion failed (attempt ${i + 1}/$retries): $e');
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
    return false;
  }

  Future<void> _centerMapOnUserLocation({bool showFeedback = true}) async {
    try {
      final userLocation = await LocationService.instance.getCurrentLocation();
      if (userLocation == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível obter sua localização. Verifique as permissões.')),
        );
        return;
      }

      final controller = await _model.googleMapsController.future;

      // Garante que o mapa esteja realmente inicializado (evita: Unable to establish connection on channel)
      final isReady = await _ensureMapReady(controller);
      if (!isReady) {
        debugPrint('[AUTO_CENTER] Map not ready yet, aborting camera animation for now.');
        if (mounted && showFeedback) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mapa ainda inicializando. Tente novamente em alguns segundos.')),
          );
        }
        return;
      }

      final target = userLocation.toGoogleMaps();

      bool centered = false;

      try {
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: 16),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 350));
        final visibleRegion = await controller.getVisibleRegion();
        centered = _boundsContainsLatLng(
          visibleRegion,
          target.latitude,
          target.longitude,
        );
      } catch (e) {
        debugPrint('[AUTO_CENTER] animateCamera failed: $e');
      }

      if (!centered) {
        try {
          await Future.delayed(const Duration(milliseconds: 250));
          await controller.moveCamera(CameraUpdate.newLatLng(target));
          await Future.delayed(const Duration(milliseconds: 300));
          final visibleRegion2 = await controller.getVisibleRegion();
          centered = _boundsContainsLatLng(
            visibleRegion2,
            target.latitude,
            target.longitude,
          );
        } catch (e) {
          debugPrint('[AUTO_CENTER] moveCamera fallback failed: $e');
        }
      }

      if (centered) {
        if (showFeedback && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mapa centralizado na sua localização.')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Não foi possível centralizar o mapa agora.')),
          );
        }
      }
    } catch (e) {
      debugPrint('[AUTO_CENTER] Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao centralizar o mapa.')),
      );
    }
  }

  List<Widget> _buildStackChildren(DriversRow? stackDriversRow) {
    List<Widget> children = [];

    // Background map
    children.add(
      Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: FlutterFlowGoogleMap(
            controller: _model.googleMapsController,
            onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
            initialLocation: _model.googleMapsCenter ??= LatLng(13.106061, -59.613158),
            markers: _model.mapMarkers,
            markerColor: GoogleMarkerColor.violet,
            mapType: MapType.normal,
            style: GoogleMapStyle.standard,
            initialZoom: 14.0,
            allowInteraction: true,
            allowZoom: true,
            showZoomControls: true,
            showLocation: false, // Desabilita o botão nativo do Google Maps
            showCompass: false,
            showMapToolbar: false,
            showTraffic: false,
            centerMapOnMarkerTap: true,
            mapTakesGesturePreference: false,
          ),
        ),
      ),
    );

    // Botão "minha localização" customizado - reposicionado para canto inferior esquerdo
    children.add(
      Align(
        alignment: AlignmentDirectional(-1.0, 1.0), // Canto inferior esquerdo
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 100.0), // Margem esquerda
          child: FlutterFlowIconButton(
            borderColor: Color(0x1F000000),
            borderRadius: 100.0,
            borderWidth: 1.0,
            buttonSize: 50.0,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            icon: Icon(
              Icons.my_location,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              await _centerMapOnUserLocation(showFeedback: true);
            },
          ),
        ),
      ),
    );

    // Online button (Sair)
    if (stackDriversRow?.isOnline == true) {
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
                  final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
                  final appUsers = await AppUsersTable().queryRows(
                    queryFn: (q) => q.eqOrNull('id', appUserId),
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
                  final appUserId2 = appUserId;
                  if (appUserId2 == null) {
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
                    matchingRows: (rows) => rows.eq('user_id', appUserId2),
                    returnRows: true,
                  );
                  if (updated.isEmpty) {
                    // Apenas drivers podem criar row em drivers
                    if (appUsers.firstOrNull?.userType == 'driver') {
                      await DriversTable().insert({
                        'user_id': appUserId2,
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
              child: Material(
                color: Colors.transparent,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Container(
                  width: 220.0,
                  height: 47.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                      color: Color(0xFF2AAD22),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new_rounded,
                        color: Color(0xFF2AAD22),
                        size: 24.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Sair',
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                              font: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                              ),
                              color: Color(0xFF2AAD22),
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
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
                  final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
                  final appUsers = await AppUsersTable().queryRows(
                    queryFn: (q) => q.eqOrNull('id', appUserId),
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
                  final appUserId2 = appUserId;
                  if (appUserId2 == null) {
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
                    matchingRows: (rows) => rows.eq('user_id', appUserId2),
                    returnRows: true,
                  );
                  if (updated.isEmpty) {
                    // Apenas drivers podem criar row em drivers
                    if (appUsers.firstOrNull?.userType == 'driver') {
                      await DriversTable().insert({
                        'user_id': appUserId2,
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
                      matchingRows: (rows) => rows.eq('user_id', appUserId2),
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
                                      fontSize: 14.0,
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
                                  fontSize: 18.0,
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
                                              fontWeight: FontWeight.bold,
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
                                    ? formatBRL(_estimatedFare)
                                    : 'R\$0,00',
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
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 41.0, 0.0, 0.0),
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
                        stream: _appUserId == null
                            ? Stream.value(<DriverWalletsRow>[]) // offline/sem usuário resolvido
                            : (_model.containerSupabaseStream ??=
                                SupaFlow.client
                                    .from("driver_wallets")
                                    .stream(primaryKey: ['id'])
                                    .eq('driver_id', _appUserId!)
                                    .map((list) => list
                                        .map((item) => DriverWalletsRow(item))
                                        .toList())),
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
                          if (snapshot.data!.isEmpty) {
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
                                        _appUserId == null
                                            ? 'Offline ou usuário não resolvido'
                                            : 'R\$0,00',
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
                                      'R\$123,45',
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
                    print('🔍 [MAIN_MOTORISTA] Navegando para menu do motorista');
                    context.pushNamed('menuMotorista');
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
          future: (() async {
            try {
              // Implementar timeout de 10 segundos para evitar carregamento infinito
              final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid)
                  .timeout(Duration(seconds: 10));
              
              debugPrint('MAIN_MOTORISTA: appUserId for query -> $appUserId');
              
              if (appUserId == null) {
                debugPrint('MAIN_MOTORISTA: appUserId not found, trying fallback by email');
                
                // Fallback: tentar buscar por email se disponível
                if (currentUserEmail.trim().isNotEmpty) {
                  try {
                    final byEmail = await AppUsersTable().queryRows(
                      queryFn: (q) => q.eq('email', currentUserEmail.trim()).limit(1),
                    ).timeout(Duration(seconds: 5));
                    
                    if (byEmail.isNotEmpty) {
                      final fallbackAppUserId = byEmail.first.id;
                      debugPrint('MAIN_MOTORISTA: Found user by email fallback: $fallbackAppUserId');
                      
                      final result = await DriversTable().querySingleRow(
                        queryFn: (q) => q.eq('user_id', fallbackAppUserId),
                      ).timeout(Duration(seconds: 5));
                      return result ?? <DriversRow>[];
                    }
                  } catch (e) {
                    debugPrint('MAIN_MOTORISTA: Email fallback failed: $e');
                  }
                }
                
                debugPrint('MAIN_MOTORISTA: No user found, showing empty state');
                return <DriversRow>[];
              }
              
              final result = await DriversTable().querySingleRow(
                queryFn: (q) => q.eq('user_id', appUserId),
              ).timeout(Duration(seconds: 5));
              return result ?? <DriversRow>[];
            } catch (e) {
              debugPrint('MAIN_MOTORISTA: Error loading driver: $e');
              return <DriversRow>[];
            }
          })(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Carregando dados do motorista...'),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48),
                    SizedBox(height: 12),
                    Text('Erro ao carregar dados do motorista'),
                  ],
                ),
              );
            }

            final driversRow = snapshot.data?.firstOrNull;

            final children = _buildStackChildren(driversRow);

            // Overlay de solicitação de corrida
            if (_showTripRequest) {
              children.add(_buildTripRequestOverlay());
            }

            return Stack(children: children);
          },
        ),
      ),
    );
  }

  Widget _buildTripRequestOverlay() {
    // Mover o overlay existente para um método para permitir adicionar lógica de limpeza
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xB2000000),
          ),
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 100.0, 16.0, 60.0),
              child: Material(
                color: Colors.transparent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Nova Solicitação de Corrida',
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    font: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
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
                              updateStateInterval: Duration(milliseconds: 1000),
                              onChanged: (value, displayTime, shouldUpdate) {
                                _model.timerMilliseconds = value;
                                _model.timerValue = displayTime;
                                if (shouldUpdate) safeSetState(() {});
                              },
                              onEnded: () async {
                                // Timer expirou: marcar notificação como lida e ocultar overlay
                                if (_currentNotificationId != null) {
                                  await actions.SistemaNotificacoesTempoReal
                                      .instance
                                      .marcarComoLida(_currentNotificationId!);
                                }
                                _model.timerController.onStopTimer();
                                // Limpar marcadores
                                _model.mapMarkers = [];
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'Origem',
                          style: FlutterFlowTheme.of(context)
                              .labelLarge
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .fontStyle,
                              ),
                        ),
                        Text(
                          _originAddress ?? '-',
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
                                color:
                                    FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                              ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'Destino',
                          style: FlutterFlowTheme.of(context)
                              .labelLarge
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .fontStyle,
                              ),
                        ),
                        Text(
                          _destinationAddress ?? '-',
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
                                color:
                                    FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                              ),
                        ),
                        SizedBox(height: 12.0),
                        Row(
                          children: [
                            Text(
                              'Valor estimado:',
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
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              _estimatedFare != null
                                  ? formatBRL(_estimatedFare)
                                  : '—',
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
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
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
                                // Limpar marcadores
                                _model.mapMarkers = [];
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
                                  // Limpar marcadores
                                  _model.mapMarkers = [];
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
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
