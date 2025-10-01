import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'a_caminho_do_passageiro_model.dart';
export 'a_caminho_do_passageiro_model.dart';

class ACaminhoDoPassageiroWidget extends StatefulWidget {
  const ACaminhoDoPassageiroWidget({super.key, this.tripId});

  final String? tripId;

  static String routeName = 'aCaminhoDoPassageiro';
  static String routePath = '/aCaminhoDoPassageiro';

  @override
  State<ACaminhoDoPassageiroWidget> createState() =>
      _ACaminhoDoPassageiroWidgetState();
}

class _ACaminhoDoPassageiroWidgetState
    extends State<ACaminhoDoPassageiroWidget> {
  late ACaminhoDoPassageiroModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  // O Future agora armazena um Map com os objetos de Row já tipados.
  Future<Map<String, SupabaseDataRow?>>? _tripDetailsFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ACaminhoDoPassageiroModel());
    _tripDetailsFuture = _fetchTripAndPassengerDetails();
  }

  // Função refatorada para ser mais limpa e usar querySingleRow.
  Future<Map<String, SupabaseDataRow?>> _fetchTripAndPassengerDetails() async {
    if (widget.tripId == null) return {};

    // Busca a viagem. querySingleRow retorna uma lista com 0 ou 1 item.
    final tripList = await TripsTable().querySingleRow(queryFn: (q) => q.eq('id', widget.tripId!));
    if (tripList.isEmpty) return {};
    final trip = tripList.first;

    // Busca o passageiro.
    final passengerList = await PassengersTable().querySingleRow(queryFn: (q) => q.eq('id', trip.passengerId!));
    if (passengerList.isEmpty) return {'trip': trip, 'passenger': null, 'appUser': null};
    final passenger = passengerList.first;

    // Busca os dados do usuário do passageiro.
    final appUserList = await AppUsersTable().querySingleRow(queryFn: (q) => q.eq('id', passenger.userId));
    final appUser = appUserList.isNotEmpty ? appUserList.first : null;

    return {'trip': trip, 'passenger': passenger, 'appUser': appUser};
  }

  // Abre o aplicativo de mapas para navegar até as coordenadas.
  void _launchMaps(double lat, double lon) async {
    final uri = Uri.tryParse('google.navigation:q=$lat,$lon&mode=d');
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final webUri = Uri.tryParse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lon');
       if (webUri != null && await canLaunchUrl(webUri)) {
          await launchUrl(webUri);
       }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: FutureBuilder<Map<String, SupabaseDataRow?>>(
        future: _tripDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!['trip'] == null) {
            return Center(child: Text('Não foi possível carregar os dados da viagem.'));
          }

          // Faz o cast dos objetos para seus tipos corretos.
          final trip = snapshot.data!['trip'] as TripsRow;
          final appUser = snapshot.data!['appUser'] as AppUsersRow?;

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: FlutterFlowGoogleMap(
                  controller: _model.googleMapsController,
                  onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
                  // Garante que a latitude e longitude sejam double.
                  initialLocation: LatLng(trip.originLatitude! as double, trip.originLongitude! as double),
                  markers: [
                     FlutterFlowMarker(
                        'passengerLocation',
                        // Garante que a latitude e longitude sejam double.
                        LatLng(trip.originLatitude! as double, trip.originLongitude! as double),
                     ),
                  ],
                  markerColor: GoogleMarkerColor.green,
                  mapType: MapType.normal,
                  style: GoogleMapStyle.standard,
                  initialZoom: 15,
                  allowInteraction: true,
                  allowZoom: true,
                  showZoomControls: true,
                  showLocation: true,
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Aprox. 3 min', style: FlutterFlowTheme.of(context).displayMedium)],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Container(
                            width: 60, height: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(appUser?.photoUrl ?? '', fit: BoxFit.cover, errorBuilder: (c,o,s) => Icon(Icons.person, size: 30)),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(appUser?.fullName ?? 'Passageiro', style: FlutterFlowTheme.of(context).titleMedium),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: FFButtonWidget(
                              // Garante que a latitude e longitude sejam double.
                              onPressed: () => _launchMaps(trip.originLatitude! as double, trip.originLongitude! as double),
                              text: 'Navegar',
                              icon: Icon(Icons.navigation_outlined),
                              options: FFButtonOptions(height: 50, color: FlutterFlowTheme.of(context).primary, textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(color: Colors.white)),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: FFButtonWidget(
                              onPressed: () { /* TODO: Navegar para o chat em português */ },
                              text: 'Chat',
                              icon: Icon(Icons.chat_bubble_outline),
                              options: FFButtonOptions(height: 50, color: FlutterFlowTheme.of(context).secondary, textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      FFButtonWidget(
                        onPressed: () { /* TODO: Implementar cancelamento em português */ },
                        text: 'Cancelar Viagem',
                        options: FFButtonOptions(width: double.infinity, height: 50, color: FlutterFlowTheme.of(context).error, textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}