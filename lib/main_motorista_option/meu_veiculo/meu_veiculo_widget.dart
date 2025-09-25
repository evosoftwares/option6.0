import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'meu_veiculo_model.dart';
export 'meu_veiculo_model.dart';
// import '/flutter_flow/user_id_converter.dart';

class MeuVeiculoWidget extends StatefulWidget {
  const MeuVeiculoWidget({
    super.key,
    this.driver,
  });

  final DriversRow? driver;

  static String routeName = 'meuVeiculo';
  static String routePath = '/meuVeiculo';

  @override
  State<MeuVeiculoWidget> createState() => _MeuVeiculoWidgetState();
}

class _MeuVeiculoWidgetState extends State<MeuVeiculoWidget> {
  late MeuVeiculoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Lista de marcas e modelos populares no mercado brasileiro.
  // Mantida localmente para performance e simplicidade no MVP.
  final Map<String, List<String>> _brandsModels = const {
    'Chevrolet': [
      'Onix', 'Onix Plus', 'Tracker', 'Equinox', 'S10', 'Montana', 'Spin', 'Trailblazer', 'Camaro'
    ],
    'Fiat': [
      'Argo', 'Mobi', 'Cronos', 'Pulse', 'Fastback', 'Toro', 'Strada', '500e', 'Ducato'
    ],
    'Volkswagen': [
      'Polo', 'Virtus', 'Nivus', 'T-Cross', 'Taos', 'Saveiro', 'Amarok', 'Gol (usado)', 'Jetta'
    ],
    'Hyundai': [
      'HB20', 'HB20S', 'Creta', 'Creta N Line', 'Tucson', 'ix35 (usado)', 'Azera (usado)'
    ],
    'Ford': [
      'Ka (usado)', 'Fiesta (usado)', 'EcoSport (usado)', 'Territory', 'Ranger', 'Bronco'
    ],
    'Toyota': [
      'Corolla', 'Corolla Cross', 'Yaris', 'Yaris Sedan', 'Hilux', 'SW4', 'Prius (usado)'
    ],
    'Honda': [
      'City', 'City Hatch', 'Civic (usado)', 'HR-V', 'WR-V (usado)'
    ],
    'Renault': [
      'Kwid', 'Stepway', 'Logan (usado)', 'Duster', 'Oroch', 'Captur (usado)'
    ],
    'Nissan': [
      'Kicks', 'Versa', 'Sentra', 'Frontier'
    ],
    'Peugeot': [
      '208', '2008', '3008', '2008 Turbo', 'Partner Rapid'
    ],
    'Citroën': [
      'C3', 'C4 Cactus', 'C3 Aircross'
    ],
    'Jeep': [
      'Renegade', 'Compass', 'Commander'
    ],
    'Caoa Chery': [
      'Tiggo 5x', 'Tiggo 7', 'Tiggo 8', 'Arrizo 6 Pro'
    ],
    'BYD': [
      'Dolphin', 'Dolphin Mini', 'Yuan Plus (Atto 3)', 'Song Plus', 'Seal', 'Han', 'Seal U'
    ],
    'GWM (Haval)': [
      'Haval H6 HEV', 'Haval H6 PHEV', 'Ora 03'
    ],
    'JAC Motors': [
      'e-JS1', 'T40 (usado)', 'T50 (usado)', 'T60 (usado)'
    ],
    'Kia': [
      'Sportage', 'Cerato (usado)', 'Seltos', 'Stonic (importado)'
    ],
    'Lexus': [
      'UX', 'NX', 'RX', 'IS (importado)'
    ],
    'Mitsubishi': [
      'L200 Triton', 'Outlander', 'Eclipse Cross', 'ASX (usado)'
    ],
    'Suzuki': [
      'Jimny', 'Vitara (usado)'
    ],
    'Volvo': [
      'XC40', 'XC60', 'XC90', 'C40'
    ],
    'BMW': [
      'X1', 'X3', '320i', 'iX1', 'i4'
    ],
    'Mercedes-Benz': [
      'GLA', 'GLC', 'Classe C', 'Classe A (usado)'
    ],
    'Audi': [
      'A3', 'Q3', 'Q5', 'e-tron (usado)'
    ],
    'Land Rover': [
      'Discovery Sport', 'Range Rover Evoque', 'Defender'
    ],
    'Porsche': [
      'Macan', 'Cayenne', '911 (importado)'
    ],
    'Ram': [
      'Rampage', '1500'
    ],
    'Mini': [
      'Cooper', 'Countryman'
    ],
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeuVeiculoModel());

    _model.textController ??=
        TextEditingController(text: widget.driver?.vehiclePlate);
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          _showIncompleteDataWarning();
        }
      },
      child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
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
              _showIncompleteDataWarning();
            },
          ),
          title: Text(
            'Seu Veículo',
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
                _showIncompleteDataWarning();
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
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tipo de Veículo',
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
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            FutureBuilder<List<PlatformSettingsRow>>(
                              future: PlatformSettingsTable().queryRows(
                                queryFn: (q) => q,
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                List<PlatformSettingsRow>
                                    dropDownPlatformSettingsRowList =
                                    snapshot.data!;

                                final categorias = dropDownPlatformSettingsRowList
                                    .map((e) => e.category)
                                    .where((e) => e != null && e.trim().isNotEmpty)
                                    .cast<String>()
                                    .toSet()
                                    .toList()
                                  ..sort();

                                // Garante que a categoria já salva (se houver) esteja na lista
                                final currentCategory = widget.driver?.vehicleCategory;
                                if (currentCategory != null && currentCategory.trim().isNotEmpty && !categorias.contains(currentCategory)) {
                                  categorias.add(currentCategory);
                                  categorias.sort();
                                }

                                return FlutterFlowDropDown<String>(
                                  controller:
                                      _model.dropDownValueController1 ??=
                                          FormFieldController<String>(
                                    _model.dropDownValue1 ??=
                                        (widget.driver?.vehicleCategory?.trim().isNotEmpty == true
                                            ? widget.driver!.vehicleCategory
                                            : (categorias.isNotEmpty ? categorias.first : null)),
                                  ),
                                  options: categorias,
                                  onChanged: (val) => safeSetState(
                                      () => _model.dropDownValue1 = val),
                                  width: double.infinity,
                                  height: 50.0,
                                  textStyle: FlutterFlowTheme.of(context)
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
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  hintText: 'Selecione',
                                  fillColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  elevation: 0.0,
                                  borderColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  borderWidth: 1.0,
                                  borderRadius: 8.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 12.0, 12.0, 12.0),
                                  hidesUnderline: true,
                                  isSearchable: true,
                                  isMultiSelect: false,
                                  validator: (val) {
                                    if (val == null || (val.trim().isEmpty)) {
                                      return 'Obrigatório';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Marca',
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
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            FlutterFlowDropDown<String>(
                              controller: _model.dropDownValueController2 ??=
                                  FormFieldController<String>(
                                _model.dropDownValue2 ??=
                                    widget.driver?.vehicleBrand,
                              ),
                              options: (() {
                                final set = {..._brandsModels.keys};
                                final saved = widget.driver?.vehicleBrand;
                                if (saved != null && saved.trim().isNotEmpty) {
                                  set.add(saved);
                                }
                                final list = List<String>.from(set)..sort();
                                return list;
                              }()),
                              onChanged: (val) => safeSetState(() {
                                _model.dropDownValue2 = val;
                                // Resetar modelo ao trocar de marca
                                _model.dropDownValue3 = null;
                                _model.dropDownValueController3?.value = null;
                              }),
                              width: double.infinity,
                              height: 50.0,
                              textStyle: FlutterFlowTheme.of(context)
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
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              hintText: 'Selecione',
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              elevation: 0.0,
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderWidth: 1.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 12.0, 12.0, 12.0),
                              hidesUnderline: true,
                              isSearchable: true,
                              isMultiSelect: false,
                              validator: (val) {
                                if (val == null || (val.trim().isEmpty)) {
                                  return 'Obrigatório';
                                }
                                return null;
                              },
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Modelo',
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
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            FlutterFlowDropDown<String>(
                              controller: _model.dropDownValueController3 ??=
                                  FormFieldController<String>(
                                _model.dropDownValue3 ??=
                                    widget.driver?.vehicleModel,
                              ),
                              options: (() {
                                final brand = _model.dropDownValue2 ?? widget.driver?.vehicleBrand;
                                final base = List<String>.from(
                                  _brandsModels[brand] ?? const <String>[],
                                );
                                final saved = widget.driver?.vehicleModel;
                                if (saved != null && saved.trim().isNotEmpty && !base.contains(saved)) {
                                  base.add(saved);
                                }
                                base.sort();
                                return base;
                              }()),
                              onChanged: (val) => safeSetState(
                                  () => _model.dropDownValue3 = val),
                              width: double.infinity,
                              height: 50.0,
                              textStyle: FlutterFlowTheme.of(context)
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
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              hintText: 'Selecione',
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              elevation: 0.0,
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderWidth: 1.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 12.0, 12.0, 12.0),
                              hidesUnderline: true,
                              isSearchable: true,
                              isMultiSelect: false,
                              validator: (val) {
                                if (val == null || (val.trim().isEmpty)) {
                                  return 'Obrigatório';
                                }
                                return null;
                              },
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ano',
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
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            FlutterFlowDropDown<String>(
                              controller: _model.dropDownValueController4 ??=
                                  FormFieldController<String>(
                                _model.dropDownValue4 ??=
                                    widget.driver?.vehicleYear?.toString(),
                              ),
                              options: ['2024', '2023', '2022', '2021'],
                              onChanged: (val) => safeSetState(
                                  () => _model.dropDownValue4 = val),
                              width: double.infinity,
                              height: 50.0,
                              textStyle: FlutterFlowTheme.of(context)
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
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              hintText: 'Selecione',
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              elevation: 0.0,
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderWidth: 1.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 12.0, 12.0, 12.0),
                              hidesUnderline: true,
                              isSearchable: false,
                              isMultiSelect: false,
                              validator: (val) {
                                if (val == null || (val.trim().isEmpty)) {
                                  return 'Obrigatório';
                                }
                                return null;
                              },
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Placa',
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
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _model.textController,
                                focusNode: _model.textFieldFocusNode,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'ABC-1234',
                                  hintStyle: FlutterFlowTheme.of(context)
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
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).primary,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          12.0, 12.0, 12.0, 12.0),
                                ),
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
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                validator: _model.textControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cor',
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
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            FlutterFlowDropDown<String>(
                              controller: _model.dropDownValueController5 ??=
                                  FormFieldController<String>(
                                _model.dropDownValue5 ??=
                                    widget.driver?.vehicleColor,
                              ),
                              options: ['Branco', 'Preto', 'Prata', 'Azul'],
                              onChanged: (val) => safeSetState(
                                  () => _model.dropDownValue5 = val),
                              width: double.infinity,
                              height: 50.0,
                              textStyle: FlutterFlowTheme.of(context)
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
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              hintText: 'Selecione',
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              elevation: 0.0,
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderWidth: 1.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 12.0, 12.0, 12.0),
                              hidesUnderline: true,
                              isSearchable: false,
                              isMultiSelect: false,
                              validator: (val) {
                                if (val == null || (val.trim().isEmpty)) {
                                  return 'Obrigatório';
                                }
                                return null;
                              },
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          // Logs detalhados iniciais do salvamento
                          debugPrint('SEU VEÍCULO: salvar iniciado. payload atual -> categoria=$_model.dropDownValue1, marca=$_model.dropDownValue2, modelo=$_model.dropDownValue3, ano=$_model.dropDownValue4, cor=$_model.dropDownValue5, placa=${_model.textController.text}');
                          debugPrint('SEU VEÍCULO: valores coletados -> categoria: ${_model.dropDownValue1}, marca: ${_model.dropDownValue2}, modelo: ${_model.dropDownValue3}, ano: ${_model.dropDownValue4}, cor: ${_model.dropDownValue5}, placa: ${_model.textController.text}');
                          if (_model.formKey.currentState == null ||
                              !_model.formKey.currentState!.validate()) {
                            return;
                          }
                          if (_model.dropDownValue1 == null) {
                            return;
                          }
                          if (_model.dropDownValue2 == null) {
                            return;
                          }
                          if (_model.dropDownValue3 == null) {
                            return;
                          }
                          if (_model.dropDownValue4 == null) {
                            return;
                          }
                          if (_model.dropDownValue5 == null) {
                            debugPrint('SEU VEÍCULO: cor não preenchida');
                            return;
                          }
                          final payload = {
                            'vehicle_brand': _model.dropDownValue2,
                            'vehicle_year': int.tryParse(_model.dropDownValue4 ?? ''),
                            'vehicle_model': _model.dropDownValue3,
                            'vehicle_color': _model.dropDownValue5,
                            'vehicle_plate': _model.textController.text,
                            'vehicle_category': _model.dropDownValue1,
                          };
                          debugPrint('SEU VEÍCULO: payload preparado -> $payload');
                          debugPrint('SEU VEÍCULO: enviando payload para Supabase...');
                          try {
                            // Garantir que usamos o UUID do app_user (não o Firebase UID)
                            final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
                            debugPrint('SEU VEÍCULO: appUserId resolvido -> $appUserId (a partir de currentUserUid=$currentUserUid)');
                            if (appUserId == null) {
                              throw Exception('Não foi possível resolver appUserId a partir do Firebase UID');
                            }
                            final updateResult = await DriversTable().update(
                              data: payload,
                              matchingRows: (rows) => rows.eqOrNull(
                                'user_id',
                                appUserId,
                              ),
                            );
                            debugPrint('SEU VEÍCULO: update concluído. result -> $updateResult');
                            debugPrint('SEU VEÍCULO: navegando para ${MainMotoristaWidget.routeName}');

                            context.pushNamed(MainMotoristaWidget.routeName);
                            debugPrint('SEU VEÍCULO: navegação concluída');

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Salvo com sucesso',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                duration: Duration(milliseconds: 4000),
                                backgroundColor: Color(0xFF007047),
                              ),
                            );
                          } catch (e, s) {
                            debugPrint('SEU VEÍCULO: erro ao salvar: $e');
                            debugPrint('SEU VEÍCULO: stacktrace: $s');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erro ao salvar veículo. Tente novamente.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: FlutterFlowTheme.of(context).error,
                                duration: Duration(seconds: 4),
                              ),
                            );
                          }
                        },
                        text: 'Salvar',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 60.0,
                          padding: EdgeInsets.all(8.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.roboto(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ].divide(SizedBox(height: 20.0)),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  void _showIncompleteDataWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'É necessário preencher todos os dados do veículo para receber corridas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: Duration(milliseconds: 4000),
        backgroundColor: FlutterFlowTheme.of(context).error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        action: SnackBarAction(
          label: 'ENTENDI',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
