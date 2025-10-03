import 'dart:async';
import 'dart:math';
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
  Timer? _etaTimer;
  String _etaMessage = 'Calculando ETA...';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ACaminhoDoPassageiroModel());

    if (widget.tripId != null) {
      _etaTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        _updateETA();
      });
      _updateETA();
    }
  }

  @override
  void dispose() {
    _etaTimer?.cancel();
    _model.dispose();
    super.dispose();
  }

  double _calculateDistanceInKm(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> _updateETA() async {
    if (widget.tripId == null) return;
    try {
      final tripList = await TripsTable().queryRows(
        queryFn: (q) => q.eq('id', widget.tripId!).limit(1),
      );
      if (tripList.isEmpty) return;
      final trip = tripList.first;

      if (trip.driverId == null) return;

      final driverList = await DriversTable().queryRows(
        queryFn: (q) => q.eq('id', trip.driverId!).limit(1),
      );
      if (driverList.isEmpty) return;
      final driver = driverList.first;

      final driverLat = driver.currentLatitude;
      final driverLon = driver.currentLongitude;

      final targetLat = trip.status == 'in_progress'
          ? trip.destinationLatitude
          : trip.originLatitude;
      final targetLon = trip.status == 'in_progress'
          ? trip.destinationLongitude
          : trip.originLongitude;

      if (driverLat != null &&
          driverLon != null &&
          targetLat != null &&
          targetLon != null) {
        final distance =
            _calculateDistanceInKm(driverLat, driverLon, targetLat, targetLon);

        const averageSpeedKmH = 30;
        final timeHours = distance / averageSpeedKmH;
        final timeMinutes = (timeHours * 60).ceil();

        if (mounted) {
          setState(() {
            _etaMessage = 'Aprox. $timeMinutes min';
          });
        }
      }
    } catch (e) {
      print('Error updating ETA: $e');
      if (mounted) {
        setState(() {
          _etaMessage = 'Erro ao calcular';
        });
      }
    }
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
      final webUri = Uri.tryParse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon');
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

  Future<void> _handleFinishTrip(TripsRow trip) async {
    try {
      final settingsList = await PlatformSettingsTable().queryRows(
        queryFn: (q) => q.eq('category', trip.vehicleCategory!).limit(1),
      );
      if (settingsList.isEmpty) {
        throw Exception(
            'Platform settings not found for category ${trip.vehicleCategory}');
      }
      final platformSettings = settingsList.first;

      final driverList = await DriversTable().queryRows(
        queryFn: (q) => q.eq('id', trip.driverId!).limit(1),
      );
      if (driverList.isEmpty) {
        throw Exception('Driver details not found.');
      }
      final driver = driverList.first;

      final distanceValue = (trip.actualDistanceKm ?? 0.0) *
          (platformSettings.basePricePerKm ?? 0.0);
      final timeValue = (trip.actualDurationMinutes ?? 0) *
          (platformSettings.basePricePerMinute ?? 0.0);

      double extraFees = 0;
      if (trip.needsPet == true) extraFees += driver.petFee ?? 0;
      if (trip.needsGrocerySpace == true) extraFees += driver.groceryFee ?? 0;
      if (trip.isCondoOrigin == true || trip.isCondoDestination == true)
        extraFees += driver.condoFee ?? 0;
      extraFees += (trip.numberOfStops ?? 0) * (driver.stopFee ?? 0);

      final calculatedFare = distanceValue + timeValue + extraFees;
      final totalFare =
          max<double>(calculatedFare, platformSettings.minFare ?? 0.0);

      final platformCommission =
          totalFare * (platformSettings.platformCommissionPercent ?? 0.0);
      final driverEarnings = totalFare - platformCommission;

      await TripsTable().update(
        data: {
          'status': 'completed',
          'total_fare': totalFare,
          'platform_commission': platformCommission,
          'driver_earnings': driverEarnings,
          'trip_completed_at': DateTime.now().toIso8601String(),
        },
        matchingRows: (q) => q.eq('id', trip.id),
      );

      final passengerWallets = await PassengerWalletsTable().queryRows(
          queryFn: (q) => q.eq('passenger_id', trip.passengerId!).limit(1));
      if (passengerWallets.isNotEmpty) {
        final passengerWallet = passengerWallets.first;
        final newPassengerBalance =
            (passengerWallet.availableBalance ?? 0) - totalFare;
        await PassengerWalletsTable().update(
          data: {'available_balance': newPassengerBalance},
          matchingRows: (q) => q.eq('id', passengerWallet.id),
        );
        await PassengerWalletTransactionsTable().insert({
          'wallet_id': passengerWallet.id,
          'passenger_id': trip.passengerId,
          'type': 'trip_payment',
          'amount': totalFare,
          'description': 'Pagamento da corrida ${trip.tripCode ?? ''}',
          'trip_id': trip.id,
          'status': 'completed',
        });
      }

      final driverWallets = await DriverWalletsTable().queryRows(
          queryFn: (q) => q.eq('driver_id', trip.driverId!).limit(1));
      if (driverWallets.isNotEmpty) {
        final driverWallet = driverWallets.first;
        final newDriverBalance =
            (driverWallet.availableBalance ?? 0) + driverEarnings;
        await DriverWalletsTable().update(
          data: {'available_balance': newDriverBalance},
          matchingRows: (q) => q.eq('id', driverWallet.id),
        );
        await WalletTransactionsTable().insert({
          'wallet_id': driverWallet.id,
          'type': 'earning',
          'amount': driverEarnings,
          'description': 'Ganhos da corrida ${trip.tripCode ?? ''}',
          'reference_type': 'trip',
          'reference_id': trip.id,
          'status': 'completed',
        });
      }

      if (mounted) {
        context.pushReplacementNamed(
          'AvaliacaoViagemWidget',
          queryParameters: {
            'tripId': trip.id,
            'userType': 'motorista',
          },
        );
      }
    } catch (e) {
      print('Error finishing trip: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao finalizar a corrida: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _promptCancellationReason(TripsRow trip) async {
    if (trip.status == 'waiting_passenger') {
      if (trip.driverArrivedAt == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Erro: Não foi possível verificar o tempo de espera.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final waitingDuration = DateTime.now().difference(trip.driverArrivedAt!);

      final settingsList = await PlatformSettingsTable().queryRows(
        queryFn: (q) => q.eq('category', trip.vehicleCategory!).limit(1),
      );

      if (settingsList.isNotEmpty) {
        final platformSettings = settingsList.first;
        final noShowWaitMinutes = platformSettings.noShowWaitMinutes ?? 3;

        if (waitingDuration.inMinutes < noShowWaitMinutes) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Aguarde o tempo mínimo de $noShowWaitMinutes minutos no local antes de cancelar.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }
      }
    }

    String? selectedReason;
    final reasons = [
      'Passageiro não apareceu',
      'Endereço incorreto',
      'Problema no veículo',
      'Outro',
    ];

    final reason = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Motivo do Cancelamento'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: reasons.map((reason) {
                  return RadioListTile<String>(
                    title: Text(reason),
                    value: reason,
                    groupValue: selectedReason,
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                  );
                }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Voltar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Confirmar'),
                  onPressed: () {
                    if (selectedReason != null) {
                      Navigator.of(context).pop(selectedReason);
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, selecione um motivo.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (reason != null && reason.isNotEmpty) {
      await _handleCancellation(trip, reason);
    }
  }

  Future<void> _handleCancellation(TripsRow trip, String reason) async {
    try {
      final settingsList = await PlatformSettingsTable().queryRows(
        queryFn: (q) => q.eq('category', trip.vehicleCategory!).limit(1),
      );
      if (settingsList.isEmpty) {
        throw Exception('Platform settings not found.');
      }
      final platformSettings = settingsList.first;

      final estimatedFare = trip.estimatedDistanceKm ?? 0.0;
      final percentageValue =
          estimatedFare * (platformSettings.cancellationFeePercent ?? 0.0);
      final cancellationFee = max<double>(
          platformSettings.minCancellationFee ?? 0.0, percentageValue);

      final passengerWallets = await PassengerWalletsTable().queryRows(
          queryFn: (q) => q.eq('passenger_id', trip.passengerId!).limit(1));
      if (passengerWallets.isNotEmpty) {
        final passengerWallet = passengerWallets.first;
        final newPassengerBalance =
            (passengerWallet.availableBalance ?? 0) - cancellationFee;
        await PassengerWalletsTable().update(
          data: {'available_balance': newPassengerBalance},
          matchingRows: (q) => q.eq('id', passengerWallet.id),
        );
        await PassengerWalletTransactionsTable().insert({
          'wallet_id': passengerWallet.id,
          'passenger_id': trip.passengerId,
          'type': 'cancellation_fee',
          'amount': cancellationFee,
          'description':
              'Taxa de cancelamento da corrida ${trip.tripCode ?? ''}',
          'trip_id': trip.id,
          'status': 'completed',
        });
      }

      await TripsTable().update(
        data: {
          'status': 'cancelled_by_driver',
          'cancellation_fee': cancellationFee,
          'cancelled_by': 'driver',
          'cancelled_at': DateTime.now().toIso8601String(),
          'cancellation_reason': reason,
        },
        matchingRows: (q) => q.eq('id', trip.id),
      );

      if (mounted) {
        context.goNamed('mainMotorista');
      }
    } catch (e) {
      print('Error cancelling trip: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cancelar a corrida: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // O MÉTODO BUILD DEVE ESTAR AQUI, DENTRO DA CLASSE
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
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          final trip = snapshot.data!.first;

          return FutureBuilder<AppUsersRow?>(
            future: _fetchPassengerUserDetails(trip.passengerId.toString()),
            builder: (context, passengerSnapshot) {
              if (passengerSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final appUser = passengerSnapshot.data;

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: FlutterFlowGoogleMap(
                      controller: _model.googleMapsController,
                      onCameraIdle: (latLng) =>
                          _model.googleMapsCenter = latLng,
                      initialLocation: LatLng(trip.originLatitude! as double,
                          trip.originLongitude! as double),
                      markers: [
                        FlutterFlowMarker(
                          'passengerLocation',
                          LatLng(trip.originLatitude! as double,
                              trip.originLongitude! as double),
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
              children: [
                Text(_etaMessage,
                    style: FlutterFlowTheme.of(context).displayMedium)
              ],
            ),
            Divider(),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(appUser?.photoUrl ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (c, o, s) =>
                            Icon(Icons.person, size: 30)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(appUser?.fullName ?? 'Passageiro',
                      style: FlutterFlowTheme.of(context).titleMedium),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FFButtonWidget(
                    onPressed: () => _launchMaps(trip.originLatitude! as double,
                        trip.originLongitude! as double),
                    text: 'Navegar',
                    icon: Icon(Icons.navigation_outlined),
                    options: FFButtonOptions(
                        height: 50,
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .copyWith(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FFButtonWidget(
                    onPressed: () {
                      context.pushNamed(
                        'tripChatPage',
                        queryParameters: {
                          'tripId': serializeParam(trip.id, ParamType.String),
                        }.withoutNulls,
                      );
                    },
                    text: 'Chat',
                    icon: Icon(Icons.chat_bubble_outline),
                    options: FFButtonOptions(
                        height: 50,
                        color: FlutterFlowTheme.of(context).secondary,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .copyWith(color: Colors.white)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildActionButton(trip),
            SizedBox(height: 16),
            if (trip.status != 'in_progress')
              FFButtonWidget(
                onPressed: () => _promptCancellationReason(trip),
                text: 'Cancelar Viagem',
                options: FFButtonOptions(
                    width: double.infinity,
                    height: 50,
                    color: FlutterFlowTheme.of(context).error,
                    textStyle: FlutterFlowTheme.of(context)
                        .titleSmall
                        .copyWith(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(TripsRow trip) {
    if (trip.status == 'driver_assigned' || trip.status == 'driver_arriving') {
      return FFButtonWidget(
        onPressed: _handleArrival,
        text: 'Cheguei ao Local',
        options: FFButtonOptions(
            width: double.infinity,
            height: 50,
            color: FlutterFlowTheme.of(context).success,
            textStyle: FlutterFlowTheme.of(context)
                .titleSmall
                .copyWith(color: Colors.white)),
      );
    } else if (trip.status == 'waiting_passenger') {
      return FFButtonWidget(
        onPressed: _handleStartTrip,
        text: 'Iniciar Corrida',
        options: FFButtonOptions(
            width: double.infinity,
            height: 50,
            color: FlutterFlowTheme.of(context).primary,
            textStyle: FlutterFlowTheme.of(context)
                .titleSmall
                .copyWith(color: Colors.white)),
      );
    } else if (trip.status == 'in_progress') {
      return FFButtonWidget(
        onPressed: () => _handleFinishTrip(trip),
        text: 'Finalizar Corrida',
        options: FFButtonOptions(
            width: double.infinity,
            height: 50,
            color: FlutterFlowTheme.of(context).tertiary,
            textStyle: FlutterFlowTheme.of(context)
                .titleSmall
                .copyWith(color: Colors.white)),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
