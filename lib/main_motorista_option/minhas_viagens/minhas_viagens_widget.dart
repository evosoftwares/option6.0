import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'minhas_viagens_model.dart';
import '/backend/supabase/supabase.dart';
export 'minhas_viagens_model.dart';

class MinhasViagensWidget extends StatefulWidget {
  const MinhasViagensWidget({super.key});

  static String routeName = 'minhasViagens';
  static String routePath = '/minhasViagens';

  @override
  State<MinhasViagensWidget> createState() => _MinhasViagensWidgetState();
}

class _MinhasViagensWidgetState extends State<MinhasViagensWidget> {
  late MinhasViagensModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Cache para otimização de performance
  Future<List<TripsRow>>? _tripsFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MinhasViagensModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Verificar se os dados do veículo estão completos primeiro
      await actions.redirecionarParaVeiculoSeIncompleto(context);

      _model.checkpassageiro = await AppUsersTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'fcm_token',
          currentUserUid,
        ),
      );
      if (_model.checkpassageiro?.firstOrNull?.userType == 'passenger') {
        context.pushNamed(MainPassageiroWidget.routeName);
      } else {
        // Inicializar dados das viagens
        _initializeTripsData();
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            buttonSize: 40.0,
            icon: Icon(
              Icons.chevron_left,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'Minhas viagens',
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
              buttonSize: 40.0,
              icon: Icon(
                Icons.menu,
                color: FlutterFlowTheme.of(context).primary,
                size: 24.0,
              ),
              onPressed: () async {
                context.pushNamed('menuMotorista');
              },
            ),
          ],
          centerTitle: false,
          elevation: 1.0,
        ),
        body: Container(
          decoration: BoxDecoration(),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Viagens Anteriores',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontStyle,
                            ),
                      ),
                    ].divide(SizedBox(width: 16.0)),
                  ),
                  // ListView otimizado com dados do Supabase
                  _tripsFuture == null
                    ? Center(
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      )
                    : FutureBuilder<List<TripsRow>>(
                        future: _tripsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            // Mostra empty state ao invés de erro para melhor UX
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_off_outlined,
                                    size: 64.0,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Suas viagens aparecerão aqui',
                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                      font: GoogleFonts.inter(),
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Puxe para baixo para atualizar',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.0),
                                  ElevatedButton.icon(
                                    onPressed: () => _initializeTripsData(),
                                    icon: Icon(Icons.refresh, size: 18),
                                    label: Text('Atualizar'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: FlutterFlowTheme.of(context).primary,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final trips = snapshot.data ?? [];

                          if (trips.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.directions_car_outlined,
                                    size: 64.0,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Nenhuma viagem encontrada',
                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                      font: GoogleFonts.inter(),
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Suas viagens aparecerão aqui quando você começar a dirigir',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.inter(),
                                      letterSpacing: 0.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () async {
                              await _initializeTripsData();
                            },
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: trips.length,
                              separatorBuilder: (context, index) => SizedBox(height: 20.0),
                              itemBuilder: (context, index) {
                                final trip = trips[index];
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatDate(trip.createdAt),
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                font: GoogleFonts.inter(),
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                            ),
                                            if (trip.totalFare != null)
                                              Text(
                                                'R\$ ${trip.totalFare!.toStringAsFixed(2)}',
                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                  font: GoogleFonts.roboto(fontWeight: FontWeight.w600),
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 8.0,
                                                  height: 8.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(context).primary,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    trip.originAddress ?? 'Origem não informada',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.inter(),
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 12.0)),
                                            ),
                                            Container(
                                              width: 2.0,
                                              height: 20.0,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 8.0,
                                                  height: 8.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(context).error,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    trip.destinationAddress ?? 'Destino não informado',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.inter(),
                                                      letterSpacing: 0.0,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 12.0)),
                                            ),
                                          ].divide(SizedBox(height: 8.0)),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                if (trip.estimatedDistanceKm != null) ...[
                                                  Icon(
                                                    Icons.straighten,
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    size: 16.0,
                                                  ),
                                                  SizedBox(width: 4.0),
                                                  Text(
                                                    '${trip.estimatedDistanceKm!.toStringAsFixed(1)} km',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      font: GoogleFonts.inter(),
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      letterSpacing: 0.0,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(trip.status),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: Text(
                                                _getStatusText(trip.status),
                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                  font: GoogleFonts.inter(),
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ].divide(SizedBox(height: 12.0)),
                                    ),
                                  ),
                                );
                              },
                            ),
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

  /// Inicializa os dados das viagens de forma otimizada
  Future<void> _initializeTripsData() async {
    try {
      final driverId = await _getDriverIdForCurrentUser();
      if (driverId != null) {
        setState(() {
          _tripsFuture = TripsTable().queryRows(
            queryFn: (q) => q
                .eq('driver_id', driverId)
                .order('created_at', ascending: false)
                .limit(50), // Limite para performance
          ).timeout(
            Duration(seconds: 10), // Timeout de 10 segundos
            onTimeout: () {
              print('⏰ [MINHAS_VIAGENS] Timeout na consulta de viagens');
              return <TripsRow>[]; // Retorna lista vazia em caso de timeout
            },
          );
        });
      }
    } catch (e) {
      print('💥 [MINHAS_VIAGENS] Erro ao inicializar dados: $e');
    }
  }

  /// Busca o driver_id do usuário atual
  Future<String?> _getDriverIdForCurrentUser() async {
    try {
      // Primeiro tenta buscar o app_user pelo e-mail do Firebase Auth
      final String? email = currentUserEmail;
      final String? fcm = currentUserUid;

      List<AppUsersRow> appUsers = [];

      // Tentativa 1: Buscar por email
      if (email != null && email.isNotEmpty) {
        appUsers = await AppUsersTable().queryRows(
          queryFn: (q) => q.eq('email', email).limit(1),
        );
        print('🔍 [MINHAS_VIAGENS] Buscando por email: $email - Encontrados: ${appUsers.length}');
      }

      // Tentativa 2: Fallback para FCM token se não encontrou por email
      if (appUsers.isEmpty && fcm != null && fcm.isNotEmpty) {
        appUsers = await AppUsersTable().queryRows(
          queryFn: (q) => q.eq('fcm_token', fcm).limit(1),
        );
        print('🔍 [MINHAS_VIAGENS] Fallback FCM: $fcm - Encontrados: ${appUsers.length}');
      }

      if (appUsers.isEmpty) {
        print('❌ [MINHAS_VIAGENS] App user não encontrado. Email: $email, FCM: $fcm');
        return null;
      }

      final appUserId = appUsers.first.id;
      print('✅ [MINHAS_VIAGENS] App user encontrado: $appUserId');

      // Agora busca o driver pelo app_user_id
      final drivers = await DriversTable().queryRows(
        queryFn: (q) => q.eq('user_id', appUserId),
      );

      if (drivers.isEmpty) {
        print('❌ [MINHAS_VIAGENS] Driver não encontrado para user_id: $appUserId');
        return null;
      }

      final driverId = drivers.first.id;
      print('✅ [MINHAS_VIAGENS] Driver encontrado: $driverId');
      return driverId;

    } catch (e) {
      print('💥 [MINHAS_VIAGENS] Erro ao buscar driver: $e');
      return null;
    }
  }

  /// Formata a data da viagem
  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoje, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      final weekdays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
      return '${weekdays[date.weekday % 7]} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  /// Retorna a cor do status da viagem
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return FlutterFlowTheme.of(context).success;
      case 'cancelled':
        return FlutterFlowTheme.of(context).error;
      case 'in_progress':
      case 'assigned':
      case 'arrived':
      case 'started':
        return FlutterFlowTheme.of(context).warning;
      case 'requested':
      case 'pending':
        return FlutterFlowTheme.of(context).primary;
      default:
        return FlutterFlowTheme.of(context).secondaryText;
    }
  }

  /// Retorna o texto do status da viagem
  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return 'Concluída';
      case 'cancelled':
        return 'Cancelada';
      case 'in_progress':
        return 'Em Andamento';
      case 'assigned':
        return 'Aceita';
      case 'arrived':
        return 'Chegou ao Local';
      case 'started':
        return 'Viagem Iniciada';
      case 'requested':
        return 'Solicitada';
      case 'pending':
        return 'Pendente';
      default:
        return status ?? 'Desconhecido';
    }
  }
}
