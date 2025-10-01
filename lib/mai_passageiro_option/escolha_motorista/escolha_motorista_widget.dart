import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/solicitar_viagem_inteligente.dart' as actions;
import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/user_id_converter.dart';
import 'package:flutter/material.dart';
import 'escolha_motorista_model.dart';
export 'escolha_motorista_model.dart';

class EscolhaMotoristaWidget extends StatefulWidget {
  const EscolhaMotoristaWidget({
    super.key,
    this.origem,
    this.destino,
    this.paradas,
    this.distancia,
    this.duracao,
    this.preco,
    this.vehicleCategory,
    this.paymentMethod,
    this.needsPet,
    this.needsGrocerySpace,
    this.needsAc,
    this.needsCondoAccess,
  });

  final FFPlace? origem;
  final FFPlace? destino;
  final List<FFPlace>? paradas;
  final double? distancia;
  final int? duracao;
  final double? preco;
  final String? vehicleCategory;
  final String? paymentMethod;
  final bool? needsPet;
  final bool? needsGrocerySpace;
  final bool? needsAc;
  final bool? needsCondoAccess;

  static String routeName = 'escolhaMotorista';
  static String routePath = '/escolhaMotorista';

  @override
  State<EscolhaMotoristaWidget> createState() => _EscolhaMotoristaWidgetState();
}

class _EscolhaMotoristaWidgetState extends State<EscolhaMotoristaWidget> {
  late EscolhaMotoristaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isRequestingTrip = false;
  String? _selectedDriverId;

  Future<void> _confirmarViagem() async {
    if (_selectedDriverId == null || _isRequestingTrip) return;

    setState(() => _isRequestingTrip = true);

    try {
      final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
      if (appUserId == null) {
        throw Exception('Perfil de usuário não encontrado.');
      }

      final passengerQuery = await PassengersTable().queryRows(
        queryFn: (q) => q.eq('user_id', appUserId).limit(1),
      );

      if (passengerQuery.isEmpty) {
        throw Exception('Perfil de passageiro não encontrado.');
      }
      final passengerId = passengerQuery.first.id;

      final result = await actions.solicitarViagemInteligente(
        passengerId: passengerId,
        originAddress: widget.origem?.address ?? '',
        originLatitude: widget.origem?.latLng.latitude ?? 0.0,
        originLongitude: widget.origem?.latLng.longitude ?? 0.0,
        originNeighborhood: '', // Corrigido: FFPlace não tem 'vicinity'
        destinationAddress: widget.destino?.address ?? '',
        destinationLatitude: widget.destino?.latLng.latitude ?? 0.0,
        destinationLongitude: widget.destino?.latLng.longitude ?? 0.0,
        destinationNeighborhood: '', // Corrigido: FFPlace não tem 'vicinity'
        vehicleCategory: widget.vehicleCategory ?? 'standard',
        needsPet: widget.needsPet ?? false,
        needsGrocerySpace: widget.needsGrocerySpace ?? false,
        needsAc: widget.needsAc ?? false,
        isCondoOrigin: false, // TODO: Implementar lógica de condomínio
        isCondoDestination: false, // TODO: Implementar lógica de condomínio
        numberOfStops: widget.paradas?.length ?? 0,
        estimatedDistanceKm: widget.distancia,
        estimatedDurationMinutes: widget.duracao,
        estimatedFare: widget.preco,
      );

      if (result['sucesso'] == true) {
        context.pushNamed(
          'esperandoMotorista',
          queryParameters: {
            'tripRequestId': result['trip_request_id'].toString(),
          }.withoutNulls,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['erro']?.toString() ?? 'Erro desconhecido ao solicitar viagem.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao solicitar viagem: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isRequestingTrip = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EscolhaMotoristaModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'Escolha o Motorista',
            style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: false,
          elevation: 1.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Expanded(
                child: Container(), // Placeholder para a lista de motoristas
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x1A000000),
                      offset: Offset(0.0, -2.0),
                    ),
                  ],
                ),
                child: FFButtonWidget(
                  onPressed: _selectedDriverId == null || _isRequestingTrip ? null : _confirmarViagem,
                  text: _isRequestingTrip ? 'SOLICITANDO...' : 'CONFIRMAR VIAGEM',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(
                          color: Colors.white,
                        ),
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12.0),
                    disabledColor: FlutterFlowTheme.of(context).alternate,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
