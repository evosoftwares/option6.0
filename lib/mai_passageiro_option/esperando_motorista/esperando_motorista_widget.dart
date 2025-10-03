import 'dart:async';
import 'dart:math';
import 'package:just_audio/just_audio.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '/utils/num_utils.dart';
import 'esperando_motorista_model.dart';
export 'esperando_motorista_model.dart';

class EsperandoMotoristaWidget extends StatefulWidget {
  const EsperandoMotoristaWidget({
    super.key,
    this.tripRequestId,
  });

  final String? tripRequestId;

  static String routeName = 'esperandoMotorista';
  static String routePath = '/esperandoMotorista';

  @override
  State<EsperandoMotoristaWidget> createState() =>
      _EsperandoMotoristaWidgetState();
}

class _EsperandoMotoristaWidgetState extends State<EsperandoMotoristaWidget> {
  late EsperandoMotoristaModel _model;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundPlayed = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _etaTimer;
  String _etaMessage = 'Calculando ETA...';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EsperandoMotoristaModel());

    // Start the timer to update ETA every 30 seconds
    if (widget.tripRequestId != null) {
      _etaTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        _updateETA();
      });
      // Initial call
      _updateETA();
    }
  }

  @override
  void dispose() {
    _etaTimer?.cancel(); // Cancel the timer
    _model.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Function to calculate distance using Haversine formula
  double _calculateDistanceInKm(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Pi / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  Future<void> _updateETA() async {
    if (widget.tripRequestId == null) return;

    try {
      // Fetch the latest trip details using the request_id
      final tripList = await TripsTable().queryRows(
        queryFn: (q) => q.eq('request_id', widget.tripRequestId!).limit(1),
      );
      if (tripList.isEmpty || tripList.first.driverId == null) return;
      final trip = tripList.first;

      // Fetch the driver's current location
      final driverList = await DriversTable().queryRows(
        queryFn: (q) => q.eq('id', trip.driverId!).limit(1),
      );
      if (driverList.isEmpty) return;
      final driver = driverList.first;

      final driverLat = driver.currentLatitude;
      final driverLon = driver.currentLongitude;
      
      // In this screen, the passenger is always at the origin
      final passengerLat = trip.originLatitude;
      final passengerLon = trip.originLongitude;

      if (driverLat != null && driverLon != null && passengerLat != null && passengerLon != null) {
        final distance = _calculateDistanceInKm(driverLat, driverLon, passengerLat, passengerLon);
        
        // Assume average speed of 30 km/h
        const averageSpeedKmH = 30;
        final timeHours = distance / averageSpeedKmH;
        final timeMinutes = (timeHours * 60).ceil();

        if (mounted) {
          setState(() {
            _etaMessage = 'Chega em $timeMinutes min';
          });
        }
      }
    } catch (e) {
      print('Error updating ETA: $e');
      if (mounted) {
        setState(() {
          _etaMessage = 'Erro no ETA';
        });
      }
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
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 11.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 20.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      context.safePop();
                    },
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      'Aguardando motorista',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            font: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle:
                                FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: StreamBuilder<List<TripsRow>>(
          stream: Supabase.instance.client
              .from('trips')
              .stream(primaryKey: ['id'])
              .eq('request_id', widget.tripRequestId!)
              .map((snapshot) {
            final table = TripsTable();
            return snapshot.map(table.createRow).toList();
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSearchingUI();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildSearchingUI();
            }

            final trip = snapshot.data!.first;

            // INÍCIO DA MODIFICAÇÃO: Redirecionar se a viagem for concluída
            if (trip.status == 'completed') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pushReplacementNamed(
                  'avaliacaoViagem',
                  queryParameters: {
                    'tripId': trip.id,
                    'userType': 'passageiro',
                  },
                );
              });
              return const Center(child: CircularProgressIndicator());
            }
            // FIM DA MODIFICAÇÃO

            if (trip.status == 'waiting_passenger' && !_soundPlayed) {              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await _audioPlayer.setAsset('assets/audios/ride_arrived.mp3');
                _audioPlayer.play();
                if (mounted) {
                  setState(() {
                    _soundPlayed = true;
                  });
                }
              });
            }

            switch (trip.status) {
              case 'waiting_passenger':
                return _buildDriverArrivedUI(trip);
              case 'in_progress':
                return _buildTripInProgressUI(trip);
              case 'driver_arriving':
              default:
                if (trip.driverId == null) {
                  return _buildSearchingUI();
                }
                return FutureBuilder<List<DriversRow>>(
                  future: DriversTable().querySingleRow(
                    queryFn: (q) => q.eq('id', trip.driverId!),
                  ),
                  builder: (context, driverSnapshot) {
                    if (!driverSnapshot.hasData || driverSnapshot.data!.isEmpty) {
                      return _buildSearchingUI();
                    }
                    final driver = driverSnapshot.data!.first;

                    return FutureBuilder<List<AppUsersRow>>(
                      future: AppUsersTable().querySingleRow(
                        queryFn: (q) => q.eq('id', driver.userId),
                      ),
                      builder: (context, appUserSnapshot) {
                        if (!appUserSnapshot.hasData || appUserSnapshot.data!.isEmpty) {
                          return _buildSearchingUI();
                        }
                        final appUser = appUserSnapshot.data!.first;
                        return _buildDriverFoundUI(trip, driver, appUser);
                      },
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDriverArrivedUI(TripsRow trip) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
          SizedBox(height: 20),
          Text(
            'Seu motorista chegou!',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTripInProgressUI(TripsRow trip) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            'Viagem em andamento...',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            'Aguarde enquanto encontramos o melhor motorista para você.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildDriverFoundUI(TripsRow trip, DriversRow driver, AppUsersRow appUser) {
    final originLat = toDoubleOrNull(trip.originLatitude);
    final originLng = toDoubleOrNull(trip.originLongitude);
    final dLat = toDoubleOrNull(driver.currentLatitude);
    final dLng = toDoubleOrNull(driver.currentLongitude);
    final rating = toDoubleOrNull(driver.averageRating);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: FlutterFlowGoogleMap(
            controller: _model.googleMapsController,
            onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
            initialLocation: LatLng(
              originLat ?? 13.106061,
              originLng ?? -59.613158,
            ),
            markers: [
              if (dLat != null && dLng != null)
                FlutterFlowMarker(
                  'driverLocation',
                  LatLng(dLat, dLng),
                ),
            ],
            markerColor: GoogleMarkerColor.red,
            mapType: MapType.normal,
            style: GoogleMapStyle.standard,
            initialZoom: 15,
            allowInteraction: true,
            allowZoom: true,
            showZoomControls: true,
            showLocation: true,
            showCompass: false,
            showMapToolbar: false,
            showTraffic: false,
            centerMapOnMarkerTap: true,
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x33000000), offset: Offset(0, -2))],
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_etaMessage, style: FlutterFlowTheme.of(context).headlineMedium),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(appUser.fullName ?? 'Nome não disponível', style: FlutterFlowTheme.of(context).titleMedium),
                        Row(
                          children: [
                            Text(rating != null ? rating.toStringAsFixed(1) : '--', style: FlutterFlowTheme.of(context).bodyMedium),
                            Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(appUser.photoUrl ?? '', fit: BoxFit.cover, errorBuilder: (c, o, s) => Icon(Icons.person, size: 30)),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driver.vehicleModel ?? 'Modelo', style: FlutterFlowTheme.of(context).bodyMedium),
                        Text(driver.vehiclePlate ?? 'Placa', style: FlutterFlowTheme.of(context).titleMedium),
                      ],
                    ),
                    Container(
                      width: 60, height: 40,
                      child: Icon(Icons.directions_car, size: 30),
                    ),
                  ],
                ),
                Divider(),
                FFButtonWidget(
                  onPressed: () { /* TODO: Implementar cancelamento em português */ },
                  text: 'Cancelar viagem',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 60,
                    color: FlutterFlowTheme.of(context).error,
                    textStyle: FlutterFlowTheme.of(context).titleMedium.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
