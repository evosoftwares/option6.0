import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/user_id_converter.dart';
import '/debug/supabase_test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'minhas_viagens_pax_model.dart';
export 'minhas_viagens_pax_model.dart';

class MinhasViagensPaxWidget extends StatefulWidget {
  const MinhasViagensPaxWidget({super.key});

  static String routeName = 'minhasViagensPax';
  static String routePath = '/minhasViagensPax';

  @override
  State<MinhasViagensPaxWidget> createState() => _MinhasViagensPaxWidgetState();
}

class _MinhasViagensPaxWidgetState extends State<MinhasViagensPaxWidget> {
  late MinhasViagensPaxModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MinhasViagensPaxModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// Carrega viagens do usuário atual usando Firebase UID diretamente
  /// FLUXO: Firebase Auth UID → app_users.currentUser_UID_Firebase → user_type → entity_id → trips
  Future<List<TripsRow>> _getUserTrips(String firebaseUserId) async {
    try {
      if (firebaseUserId.isEmpty) {
        _model.emptyMessage = 'Você não está logado. Faça login para ver suas viagens.';
        debugPrint('⚠️ [VIAGENS_PAX] Firebase UID vazio');
        return [];
      }

      // PASSO 1: Testar conectividade básica
      debugPrint('🔍 [VIAGENS_PAX] Testando conectividade Supabase...');
      final connectivityTest = await SupabaseConnectivityTest.testBasicConnectivity();
      if (!connectivityTest['success']) {
        _model.emptyMessage = 'Problema de conexão com o servidor. Verifique sua internet e tente novamente.';
        debugPrint('❌ [VIAGENS_PAX] Falha na conectividade: ${connectivityTest['error']}');
        return [];
      }
      debugPrint('✅ [VIAGENS_PAX] Conectividade OK');

      // PASSO 2: Buscar usuário em app_users usando currentUser_UID_Firebase
      debugPrint('🔍 [VIAGENS_PAX] Buscando app_users com currentUser_UID_Firebase: $firebaseUserId');
      final appUserQuery = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('currentUser_UID_Firebase', firebaseUserId).limit(1),
      );

      if (appUserQuery.isEmpty) {
        _model.emptyMessage = 'Usuário não encontrado no sistema. Faça login novamente ou verifique seu cadastro.';
        debugPrint('❌ [VIAGENS_PAX] Nenhum registro em app_users com currentUser_UID_Firebase: $firebaseUserId');
        return [];
      }

      final appUser = appUserQuery.first;
      final appUserId = appUser.id;
      final userType = appUser.userType?.toLowerCase();

      debugPrint('✅ [VIAGENS_PAX] Usuário encontrado:');
      debugPrint('   - app_users.id: $appUserId');
      debugPrint('   - currentUser_UID_Firebase: $firebaseUserId (from currentUserUid getter)');
      debugPrint('   - user_type: $userType');

      if (userType == null || userType.isEmpty) {
        _model.emptyMessage = 'Tipo de usuário não definido. Ajuste seu perfil nas configurações.';
        debugPrint('⚠️ [VIAGENS_PAX] user_type nulo ou vazio');
        return [];
      }

      // PASSO 3: Buscar entity_id (passengers.id ou drivers.id) usando app_users.id
      String? entityId;
      String entityType = '';

      if (userType == 'passenger' || userType == 'passageiro') {
        debugPrint('🔍 [VIAGENS_PAX] Buscando passenger com user_id: $appUserId');
        final passengerQuery = await PassengersTable().queryRows(
          queryFn: (q) => q.eq('user_id', appUserId).limit(1),
        );

        if (passengerQuery.isEmpty) {
          _model.emptyMessage = 'Perfil de passageiro não encontrado. Complete seu cadastro para ver viagens.';
          debugPrint('❌ [VIAGENS_PAX] Nenhum registro em passengers com user_id: $appUserId');
          return [];
        }

        entityId = passengerQuery.first.id;
        entityType = 'passenger';
        debugPrint('✅ [VIAGENS_PAX] Passageiro encontrado - passenger_id: $entityId');

      } else if (userType == 'driver' || userType == 'motorista') {
        debugPrint('🔍 [VIAGENS_PAX] Buscando driver com user_id: $appUserId');
        final driverQuery = await DriversTable().queryRows(
          queryFn: (q) => q.eq('user_id', appUserId).limit(1),
        );

        if (driverQuery.isEmpty) {
          _model.emptyMessage = 'Perfil de motorista não encontrado. Complete seu cadastro para ver viagens.';
          debugPrint('❌ [VIAGENS_PAX] Nenhum registro em drivers com user_id: $appUserId');
          return [];
        }

        entityId = driverQuery.first.id;
        entityType = 'driver';
        debugPrint('✅ [VIAGENS_PAX] Motorista encontrado - driver_id: $entityId');

      } else {
        _model.emptyMessage = 'Tipo de usuário inválido: "$userType". Verifique seu cadastro.';
        debugPrint('❌ [VIAGENS_PAX] Tipo de usuário não reconhecido: $userType');
        return [];
      }

      // PASSO 4: Buscar viagens na tabela trips usando entity_id
      List<TripsRow> trips = [];

      if (entityType == 'passenger') {
        debugPrint('🔍 [VIAGENS_PAX] Buscando trips com passenger_id: $entityId');
        if (entityId != null) {
          final nonNullEntityId = entityId;
          trips = await TripsTable().queryRows(
            queryFn: (q) => q
                .eq('passenger_id', nonNullEntityId)
                .order('created_at', ascending: false),
          );
        }
        debugPrint('✅ [VIAGENS_PAX] ${trips.length} viagens de passageiro encontradas');

      } else if (entityType == 'driver') {
        debugPrint('🔍 [VIAGENS_PAX] Buscando trips com driver_id: $entityId');
        if (entityId != null) {
          final nonNullEntityId = entityId;
          trips = await TripsTable().queryRows(
            queryFn: (q) => q
                .eq('driver_id', nonNullEntityId)
                .order('created_at', ascending: false),
          );
        }
        debugPrint('✅ [VIAGENS_PAX] ${trips.length} viagens de motorista encontradas');
      }

      // PASSO 5: Mensagem se não encontrar viagens
      if (trips.isEmpty) {
        _model.emptyMessage = entityType == 'passenger'
            ? 'Nenhuma viagem encontrada. Suas viagens como passageiro aparecerão aqui.'
            : 'Nenhuma viagem encontrada. Suas viagens como motorista aparecerão aqui.';
        debugPrint('ℹ️ [VIAGENS_PAX] Nenhuma viagem para $entityType (entity_id: $entityId)');
      } else {
        debugPrint('📊 [VIAGENS_PAX] RESUMO:');
        debugPrint('   - Firebase UID: $firebaseUserId');
        debugPrint('   - app_users.id: $appUserId');
        debugPrint('   - Tipo: $entityType');
        debugPrint('   - Entity ID: $entityId');
        debugPrint('   - Total viagens: ${trips.length}');
      }

      return trips;

    } catch (e, stackTrace) {
      _model.emptyMessage = 'Erro temporário ao carregar viagens. Tente novamente em alguns segundos.';
      debugPrint('💥 [VIAGENS_PAX] Erro capturado: $e');
      debugPrint('📍 Stack trace: $stackTrace');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
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
          'Suas Viagens',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.roboto(
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
              ),
        ),
        centerTitle: false,
        elevation: 1.0,
      ),
      body: SafeArea(
        top: true,
        child: FutureBuilder<List<TripsRow>>(
          future: _getUserTrips(currentUserUid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).primary,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar viagens. Tente novamente.',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(),
                        letterSpacing: 0.0,
                      ),
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
                        _model.emptyMessage ?? 'Suas viagens aparecerão aqui conforme seu perfil (passageiro/motorista).',
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

            return ListView.separated(
              padding: EdgeInsets.all(16.0),
              itemCount: trips.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.0),
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
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
                            if (trip.totalFare != null)
                              Text(
                                'R\$ ${trip.totalFare!.toStringAsFixed(2)}',
                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 20.0,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                trip.originAddress ?? 'Endereço não informado',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.inter(),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(
                              Icons.flag,
                              color: FlutterFlowTheme.of(context).error,
                              size: 20.0,
                            ),
                            SizedBox(width: 8.0),
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
                          ],
                        ),
                        SizedBox(height: 12.0),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 16.0,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              _formatDate(trip.createdAt),
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.inter(),
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            if (trip.estimatedDistanceKm != null) ...[
                              SizedBox(width: 16.0),
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
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

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

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return 'Concluída';
      case 'cancelled':
        return 'Cancelada';
      case 'in_progress':
        return 'Em Andamento';
      case 'assigned':
        return 'Motorista Designado';
      case 'arrived':
        return 'Motorista Chegou';
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

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      final weekdays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
      return '${weekdays[date.weekday % 7]} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}