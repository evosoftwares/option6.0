import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/route_validator.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_passageiro_model.dart';
import 'package:option/flutter_flow/trip_suggestions_service.dart';
import '/backend/supabase/supabase.dart';
export 'main_passageiro_model.dart';

class MainPassageiroWidget extends StatefulWidget {
  const MainPassageiroWidget({super.key});

  static String routeName = 'mainPassageiro';
  static String routePath = '/mainPassageiro';

  @override
  State<MainPassageiroWidget> createState() => _MainPassageiroWidgetState();
}

class _MainPassageiroWidgetState extends State<MainPassageiroWidget> {
  late MainPassageiroModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainPassageiroModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  /// Gets passenger trips by first converting Firebase UID to app_users.id, then querying trips
  Future<List<TripsRow>> _getPassengerTrips(String firebaseUserId) async {
    try {
      // Convert Firebase UID to app_users.id (UUID)
      final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(firebaseUserId);
      
      if (appUserId == null) {
        debugPrint('Usuário não encontrado para Firebase UID: $firebaseUserId');
        return [];
      }
      
      // Get the passenger record using the correct app_users.id
      final passengerQuery = await PassengersTable().queryRows(
        queryFn: (q) => q.eq('user_id', appUserId),
      );

      if (passengerQuery.isEmpty) {
        debugPrint('Perfil de passageiro não encontrado para app_users.id: $appUserId');
        return [];
      }

      final passenger = passengerQuery.first;
      final passengerId = passenger.id; // This is the passenger UUID

      // Now query trips using the correct passenger_id (UUID)
      final trips = await TripsTable().queryRows(
        queryFn: (q) => q.eq('passenger_id', passengerId)
            .order('created_at', ascending: false)
            .limit(10), // Limit to recent trips for performance
      );

      return trips;
    } catch (e) {
      debugPrint('Erro ao buscar viagens do passageiro: $e');
      throw e; // Re-throw to be handled by FutureBuilder
    }
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            'Para onde vamos',
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
              buttonSize: 53.2,
              icon: Icon(
                Icons.menu_sharp,
                color: FlutterFlowTheme.of(context).primary,
                size: 24.0,
              ),
              onPressed: () async {
                context.pushNamed(MenuPassageiroWidget.routeName);
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
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 10.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final result = await context.pushNamed(
                                  SearchScreenWidget.routeName,
                                  queryParameters: {
                                    'origemDestinoParada': serializeParam(
                                      'origem',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                                if (!mounted) return;
                                if (result is FFPlace) {
                                  setState(() {
                                    _model.origemPlace = result;
                                  });
                                }
                              },
                              child: Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 20.0,
                                      ),
                                      Expanded(
                                        child: Text(
                                          (_model.origemPlace != null && _model.origemPlace!.name.isNotEmpty)
                                              ? _model.origemPlace!.name
                                              : 'Partida',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 5.0)),
                                  ),
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                final paradasPlace = _model.paradasPlace;

                                if (paradasPlace.isEmpty) {
                                  return SizedBox.shrink();
                                }

                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: paradasPlace.length,
                                  itemBuilder: (context, paradasListIndex) {
                                    final parada = paradasPlace[paradasListIndex];
                                    return Container(
                                       height: 50.0,
                                       decoration: BoxDecoration(
                                         borderRadius:
                                             BorderRadius.circular(8.0),
                                       ),
                                       child: Padding(
                                         padding: EdgeInsetsDirectional.fromSTEB(
                                             16.0, 0.0, 0.0, 0.0),
                                         child: Row(
                                           mainAxisSize: MainAxisSize.max,
                                           crossAxisAlignment:
                                               CrossAxisAlignment.center,
                                           children: [
                                             Icon(
                                               Icons.more_vert,
                                               color:
                                                   FlutterFlowTheme.of(context)
                                                       .secondaryText,
                                               size: 20.0,
                                             ),
                                             Expanded(
                                               child: Text(
                                                 parada.name.isNotEmpty ? parada.name : 'Parada',
                                                 style: FlutterFlowTheme.of(
                                                         context)
                                                     .bodyLarge
                                                     .override(
                                                       font: GoogleFonts.inter(
                                                         fontWeight:
                                                             FontWeight.w500,
                                                         fontStyle:
                                                             FlutterFlowTheme.of(
                                                                     context)
                                                                 .bodyLarge
                                                                 .fontStyle,
                                                       ),
                                                       color:
                                                           FlutterFlowTheme.of(
                                                                   context)
                                                               .primaryText,
                                                       fontSize: 12.0,
                                                       letterSpacing: 0.0,
                                                       fontWeight:
                                                           FontWeight.w500,
                                                       fontStyle:
                                                           FlutterFlowTheme.of(
                                                                   context)
                                                               .bodyLarge
                                                               .fontStyle,
                                                     ),
                                               ),
                                             ),
                                             Expanded(
                                               child: Align(
                                                 alignment: AlignmentDirectional(
                                                     1.0, 0.0),
                                                 child: FlutterFlowIconButton(
                                                   borderRadius: 8.0,
                                                   buttonSize: 40.0,
                                                   icon: Icon(
                                                     Icons.close_rounded,
                                                     color: Colors.black,
                                                     size: 24.0,
                                                   ),
                                                   onPressed: () async {
                                                    final removed = _model.paradasPlace[paradasListIndex];
                                                    _model.removeAtIndexFromParadasPlace(paradasListIndex);
                                                    safeSetState(() {});
                                                    try {
                                                      await TripSuggestionsService.instance.removeTemporaryStop(removed);
                                                    } catch (e) {
                                                      debugPrint('Erro ao remover parada temporária no Supabase: $e');
                                                    }
                                                   },
                                                 ),
                                               ),
                                             ),
                                           ].divide(SizedBox(width: 0.0)),
                                         ),
                                       ),
                                     );
                                   },
                                );
                              },
                            ),
                            SizedBox(height: 11.0),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final result = await context.pushNamed(
                                  SearchScreenWidget.routeName,
                                  queryParameters: {
                                    'origemDestinoParada': serializeParam(
                                      'destino',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                                if (!mounted) return;
                                if (result is FFPlace) {
                                  setState(() {
                                    _model.destinoPlace = result;
                                  });
                                }
                              },
                              child: Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.flag_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 20.0,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              5.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            (_model.destinoPlace != null && _model.destinoPlace!.name.isNotEmpty)
                                                ? _model.destinoPlace!.name
                                                : 'Destino',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 5.0)),
                                  ),
                                ),
                              ),
                            ),
                            // Botão para solicitar viagem com validação
                            if (_model.origemPlace != null && _model.destinoPlace != null)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    // Validar rota antes de solicitar
                                    final validation = await RouteValidator.instance.validateRoute(
                                      origin: _model.origemPlace,
                                      destination: _model.destinoPlace,
                                      stops: _model.paradasPlace,
                                    );

                                    if (!validation.isValid) {
                                      // Mostrar problemas encontrados
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(validation.issues.first.message),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    if (validation.hasWarnings) {
                                      // Mostrar avisos mas permitir continuar
                                      for (final warning in validation.warnings) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(warning.message),
                                            backgroundColor: Colors.orange,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    }

                                    // Navegar para tela de preferências
                                    context.pushNamed(
                                      'preferenciasPassageiro',
                                      queryParameters: {
                                        'origem': serializeParam(_model.origemPlace, ParamType.FFPlace),
                                        'destino': serializeParam(_model.destinoPlace, ParamType.FFPlace),
                                        'paradas': serializeParam(_model.paradasPlace, ParamType.FFPlace, isList: true),
                                        'distancia': serializeParam(validation.estimatedDistance, ParamType.double),
                                        'duracao': serializeParam(validation.estimatedDuration, ParamType.int),
                                        'preco': serializeParam(validation.estimatedCost, ParamType.double),
                                      }.withoutNulls,
                                    );
                                  },
                                  text: 'Solicitar Viagem',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    elevation: 0.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (_model.paradasPlace.length < 4)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              11.0, 0.0, 0.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderRadius: 80.0,
                            buttonSize: 40.0,
                            fillColor: FlutterFlowTheme.of(context).primary,
                            icon: Icon(
                              Icons.add_rounded,
                              color: FlutterFlowTheme.of(context).info,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              final result = await context.pushNamed(
                                SearchScreenWidget.routeName,
                                queryParameters: {
                                  'origemDestinoParada': serializeParam(
                                    'parada',
                                    ParamType.String,
                                  ),
                                }.withoutNulls,
                              );
                              if (!mounted) return;
                              if (result is FFPlace) {
                                setState(() {
                                  _model.addToParadasPlace(result);
                                });
                                try {
                                  await TripSuggestionsService.instance.saveTemporaryStop(result);
                                } catch (e) {
                                  debugPrint('Erro ao salvar parada temporária no Supabase: $e');
                                }
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 22.0, 0.0, 0.0),
                    child: currentUserUid.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.history_toggle_off,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 48.0,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Nenhuma viagem recente',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Suas viagens aparecerão aqui.',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      : FutureBuilder<List<TripsRow>>(
                      future: _getPassengerTrips(currentUserUid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          debugPrint('Erro ao carregar histórico de viagens: ${snapshot.error}');
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.history_toggle_off,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  size: 48.0,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Nenhuma viagem recente',
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Suas viagens aparecerão aqui.',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

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
                        List<TripsRow> listViewTripsRowList = snapshot.data!;
                        if (listViewTripsRowList.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.history_toggle_off,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  size: 48.0,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Nenhuma viagem recente',
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Suas viagens aparecerão aqui.',
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: listViewTripsRowList.length,
                          itemBuilder: (context, listViewIndex) {
                            // Removido: variável local não utilizada
                            return Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(99.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.pin_drop_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rua , número',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
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
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Bairro, cidade, estado',
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
                                ].divide(SizedBox(width: 12.0)),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
