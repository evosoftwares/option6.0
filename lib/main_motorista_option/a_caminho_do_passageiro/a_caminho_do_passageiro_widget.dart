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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ACaminhoDoPassageiroModel());
  }

  Future<AppUsersRow?> _fetchPassengerUserDetails(String passengerId) async {
    final passengerList = await PassengersTable().queryRows(
      queryFn: (q) => q.eq('id', passengerId).limit(1),
    );
    if (passengerList.isEmpty) return null;
    final passenger = passengerList.first;

    final appUserList = await AppUsersTable().queryRows(
      queryFn: (q) => q.eq('id', passenger.userId).limit(1),
    );
    return appUserList.isNotEmpty ? appUserList.first : null;
  }

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

  Future<void> _handleArrival() async {
    if (widget.tripId == null) return;
    await TripsTable().update(
      data: {
        'status': 'waiting_passenger',
        'driver_arrived_at': DateTime.now().toIso8601String(),
      },
      matchingRows: (q) => q.eq('id', widget.tripId!),
    );
  }

  Future<void> _handleStartTrip() async {
    if (widget.tripId == null) return;
    await TripsTable().update(
      data: {
        'status': 'in_progress',
        'trip_started_at': DateTime.now().toIso8601String(),
      },
      matchingRows: (q) => q.eq('id', widget.tripId!),
    );
  }

  Future<void> _handleFinishTrip() async {
    // TODO: Implementar lógica de finalização da viagem, cálculo de preço e pagamento.
    print('Finalizar corrida clicado');
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
      body: StreamBuilder<List<TripsRow>>(
        stream: Supabase.instance.client
            .from('trips')
            .stream(primaryKey: ['id'])
            .eq('id', widget.tripId!)
            .map((data) => data.map((row) => TripsRow(row)).toList()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          final trip = snapshot.data!.first;

          return FutureBuilder<AppUsersRow?>(
            future: _fetchPassengerUserDetails(trip.passengerId.toString()),
            builder: (context, passengerSnapshot) {
              if (passengerSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final appUser = passengerSnapshot.data;

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: FlutterFlowGoogleMap(
                      controller: _model.googleMapsController,
                      onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
                      initialLocation: LatLng(trip.originLatitude! as double, trip.originLongitude! as double),
                      markers: [
                        FlutterFlowMarker(
                          'passengerLocation',
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
                  _buildBottomCard(trip, appUser),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomCard(TripsRow trip, AppUsersRow? appUser) {
    return Container(
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
            _buildActionButton(trip),
            SizedBox(height: 16),
            if (trip.status != 'in_progress') // Oculta o botão cancelar se a viagem já começou
              FFButtonWidget(
                onPressed: () { /* TODO: Implementar cancelamento em português */ },
                text: 'Cancelar Viagem',
                options: FFButtonOptions(width: double.infinity, height: 50, color: FlutterFlowTheme.of(context).error, textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(TripsRow trip) {
    // O status inicial pode ser 'driver_assigned' ou 'driver_arriving'
    if (trip.status == 'driver_assigned' || trip.status == 'driver_arriving') {
      return FFButtonWidget(
        onPressed: _handleArrival,
        text: 'Cheguei ao Local',
        options: FFButtonOptions(width: double.infinity, height: 50, color: FlutterFlowTheme.of(context).success, textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(color: Colors.white)),
      );
    } else if (trip.status == 'waiting_passenger') {
      return FFButtonWidget(
        onPressed: _handleStartTrip,
        text: 'Iniciar Corrida',
        options: FFButtonOptions(width: double.infinity, height: 50, color: FlutterFlowTheme.of(context).primary, textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(color: Colors.white)),
      );
    } else if (trip.status == 'in_progress') {
      return FFButtonWidget(
        onPressed: _handleFinishTrip,
        text: 'Finalizar Corrida',
        options: FFButtonOptions(width: double.infinity, height: 50, color: FlutterFlowTheme.of(context).tertiary, textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(color: Colors.white)),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}