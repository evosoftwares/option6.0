import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/conectar_interface_passageiro.dart' as pax_actions;
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
  });

  final FFPlace? origem;
  final FFPlace? destino;
  final List<FFPlace>? paradas;
  final double? distancia;
  final int? duracao;
  final double? preco;

  static String routeName = 'escolhaMotorista';
  static String routePath = '/escolhaMotorista';

  @override
  State<EscolhaMotoristaWidget> createState() => _EscolhaMotoristaWidgetState();
}

class _EscolhaMotoristaWidgetState extends State<EscolhaMotoristaWidget> {
  late EscolhaMotoristaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Estado mínimo para busca de motoristas
  String _vehicleCategory = 'standard';
  bool _needsPet = false;
  bool _needsGrocerySpace = false;
  bool _needsAc = false;
  bool _loadingDrivers = true;
  List<Map<String, dynamic>> _drivers = [];
  String? _selectedDriverId;

  Future<void> _fetchDrivers() async {
    try {
      final origin = widget.origem;
      if (origin == null) {
        setState(() => _loadingDrivers = false);
        return;
      }

      final results = await pax_actions.buscarMotoristasDisponiveis(
        originLatitude: origin.latLng.latitude,
        originLongitude: origin.latLng.longitude,
        vehicleCategory: _vehicleCategory,
        needsPet: _needsPet,
        needsGrocerySpace: _needsGrocerySpace,
        needsAc: _needsAc,
        isCondoOrigin: false,
        isCondoDestination: false,
      );

      setState(() {
        _drivers = results;
        _loadingDrivers = false;
        if (_drivers.isNotEmpty) {
          _selectedDriverId ??= _drivers.first['driver_id'] as String?;
        }
      });
    } catch (e) {
      setState(() => _loadingDrivers = false);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_car_outlined, size: 48, color: theme.secondaryText),
          SizedBox(height: 8),
          Text(
            'Nenhum motorista disponível agora',
            style: theme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            'Tente novamente em alguns instantes ou ajuste sua localização.',
            style: theme.bodySmall.copyWith(
              color: theme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          FFButtonWidget(
            onPressed: () {
              setState(() => _loadingDrivers = true);
              _fetchDrivers();
            },
            text: 'Tentar novamente',
            options: FFButtonOptions(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 16),
              color: theme.primary,
              textStyle: theme.titleSmall.copyWith(
                color: Colors.white,
              ),
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EscolhaMotoristaModel());
    // Carregar motoristas ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchDrivers());
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
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'Escolha o Motorista',
            style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 1.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Mantemos apenas o AppBar e a lista com empty state inteligente
                SizedBox(height: 0),
                // Lista dinâmica de motoristas ocupando a tela
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: _loadingDrivers
                        ? Center(child: SizedBox(width: 36, height: 36, child: CircularProgressIndicator()))
                        : (_drivers.isEmpty
                            ? _buildEmptyState(context)
                            : ListView.separated(
                                itemCount: _drivers.length,
                                separatorBuilder: (_, __) => SizedBox(height: 8.0),
                                itemBuilder: (context, index) {
                                  final d = _drivers[index];
                                  final selected = d['driver_id'] == _selectedDriverId;
                                  return InkWell(
                                    onTap: () => setState(() => _selectedDriverId = d['driver_id'] as String?),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? FlutterFlowTheme.of(context).primaryBackground
                                            : FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: selected
                                              ? FlutterFlowTheme.of(context).primary
                                              : FlutterFlowTheme.of(context).alternate,
                                        ),
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                                        title: Text((d['nome'] ?? 'Motorista').toString()),
                                        subtitle: Text((d['vehicle_info'] ?? '').toString()),
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            if (d['preco_estimado'] is num)
                                              Text('R\$ ${(d['preco_estimado'] as num).toStringAsFixed(2)}'),
                                            if (d['tempo_chegada_minutos'] != null)
                                              Text('${d['tempo_chegada_minutos']} min'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
