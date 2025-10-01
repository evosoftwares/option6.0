import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/user_id_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'preferencias_motorista_model.dart';
export 'preferencias_motorista_model.dart';

class PreferenciasMotoristaWidget extends StatefulWidget {
  const PreferenciasMotoristaWidget({super.key});

  static String routeName = 'preferenciasMotorista';
  static String routePath = '/preferenciasMotorista';

  @override
  State<PreferenciasMotoristaWidget> createState() =>
      _PreferenciasMotoristaWidgetState();
}

class _PreferenciasMotoristaWidgetState
    extends State<PreferenciasMotoristaWidget> {
  late PreferenciasMotoristaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PreferenciasMotoristaModel());

    // Load driver data on initialization
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadDriverData();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadDriverData() async {
    try {
      // Converter Firebase UID para Supabase UUID
      final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
      if (appUserId == null) {
        print('Error: User not found in system');
        return;
      }

      final driversQuery = await DriversTable().queryRows(
        queryFn: (q) => q.eqOrNull('user_id', appUserId),
      );

      if (driversQuery.isEmpty) {
        return;
      }

      final driver = driversQuery.first;
      _model.initializeWithDriverData(driver);

      // Load additional preference fees from SQL
      final prefRows = await DriverPreferenceFeesTable().queryRows(
        queryFn: (q) => q.eqOrNull('driver_id', driver.id),
      );
      _model.initializeAdditionalPreferencesFromRows(prefRows);

      safeSetState(() {});
    } catch (e) {
      print('Error loading driver data: $e');
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
              context.goNamed('menuMotorista');
            },
          ),
          title: Text(
            'Preferências',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
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
          child: Form(
            key: _model.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Configure suas taxas de serviços extras',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 24.0),

                  // Content area
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Transporte de Pet
                          _buildServiceCard(
                            title: 'Transporte de Pet',
                            description:
                                'Aceito transportar animais de estimação',
                            icon: Icons.pets,
                            switchValue: _model.acceptsPetValue ?? false,
                            onSwitchChanged: (value) {
                              safeSetState(() {
                                _model.acceptsPetValue = value;
                              });
                            },
                            controller: _model.petFeeTextController,
                            focusNode: _model.petFeeFocusNode,
                            validator: _model.petFeeTextControllerValidator,
                            enabled: _model.acceptsPetValue ?? false,
                          ),

                          SizedBox(height: 20.0),

                          // Serviço de Mercado
                          _buildServiceCard(
                            title: 'Serviço de Mercado',
                            description: 'Faço compras e uso do porta-malas',
                            icon: Icons.shopping_bag,
                            switchValue: _model.acceptsGroceryValue ?? false,
                            onSwitchChanged: (value) {
                              safeSetState(() {
                                _model.acceptsGroceryValue = value;
                              });
                            },
                            controller: _model.groceryFeeTextController,
                            focusNode: _model.groceryFeeFocusNode,
                            validator: _model.groceryFeeTextControllerValidator,
                            enabled: _model.acceptsGroceryValue ?? false,
                          ),

                          SizedBox(height: 20.0),

                          // Acesso a Condomínio
                          _buildServiceCard(
                            title: 'Acesso a Condomínio',
                            description: 'Entro em condomínios e residências',
                            icon: Icons.apartment,
                            switchValue: _model.acceptsCondoValue ?? false,
                            onSwitchChanged: (value) {
                              safeSetState(() {
                                _model.acceptsCondoValue = value;
                              });
                            },
                            controller: _model.condoFeeTextController,
                            focusNode: _model.condoFeeFocusNode,
                            validator: _model.condoFeeTextControllerValidator,
                            enabled: _model.acceptsCondoValue ?? false,
                          ),

                          SizedBox(height: 20.0),

                          // Taxa por Parada
                          _buildStopFeeCard(),

                          SizedBox(height: 20.0),

                          // Ar-condicionado
                          _buildServiceCard(
                            title: 'Ar-condicionado',
                            description: 'Disponibilizo ar-condicionado',
                            icon: Icons.ac_unit,
                            switchValue: _model.providesAcValue ?? false,
                            onSwitchChanged: (value) {
                              safeSetState(() {
                                _model.providesAcValue = value;
                              });
                            },
                            controller: _model.acFeeTextController,
                            focusNode: _model.acFeeFocusNode,
                            validator: _model.acFeeTextControllerValidator,
                            enabled: _model.providesAcValue ?? false,
                          ),

                          SizedBox(height: 20.0),

                          // Cadeira infantil
                          _buildServiceCard(
                            title: 'Cadeira infantil',
                            description: 'Disponibilizo cadeira para criança',
                            icon: Icons.child_care,
                            switchValue: _model.providesChildSeatValue ?? false,
                            onSwitchChanged: (value) {
                              safeSetState(() {
                                _model.providesChildSeatValue = value;
                              });
                            },
                            controller: _model.childSeatFeeTextController,
                            focusNode: _model.childSeatFeeFocusNode,
                            validator: _model.childSeatFeeTextControllerValidator,
                            enabled: _model.providesChildSeatValue ?? false,
                          ),

                          SizedBox(height: 20.0),

                          // Acessibilidade (cadeirante)
                          _buildServiceCard(
                            title: 'Acessibilidade',
                            description: 'Veículo adaptado para cadeirante',
                            icon: Icons.accessible,
                            switchValue:
                                _model.providesWheelchairAccessValue ?? false,
                            onSwitchChanged: (value) {
                              safeSetState(() {
                                _model.providesWheelchairAccessValue = value;
                              });
                            },
                            controller: _model.wheelchairFeeTextController,
                            focusNode: _model.wheelchairFeeFocusNode,
                            validator:
                                _model.wheelchairFeeTextControllerValidator,
                            enabled:
                                _model.providesWheelchairAccessValue ?? false,
                          ),

                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),

                  // Save button
                  FFButtonWidget(
                    onPressed: () async {
                      await _savePreferences();
                    },
                    text: 'Salvar Preferências',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 60.0,
                      padding: EdgeInsets.all(8.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(12.0),
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

  Widget _buildServiceCard({
    required String title,
    required String description,
    required IconData icon,
    required bool switchValue,
    required Function(bool) onSwitchChanged,
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required String? Function(BuildContext, String?)? validator,
    required bool enabled,
  }) {
    return Container(
      width: double.infinity,
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
            // Header with icon, title and switch
            Row(
              children: [
                Icon(
                  icon,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 24.0,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.inter(),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0,
                            ),
                      ),
                      Text(
                        description,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: switchValue,
                  onChanged: onSwitchChanged,
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return FlutterFlowTheme.of(context).secondaryText;
                  }),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return FlutterFlowTheme.of(context).primary;
                    }
                    return FlutterFlowTheme.of(context).alternate;
                  }),
                ),
              ],
            ),

            // Fee input field (only shown when service is enabled)
            if (enabled) ...[
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text(
                    'Taxa: R\$',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: '0,00',
                        hintStyle: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
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
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 12.0, 12.0, 12.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(),
                            letterSpacing: 0.0,
                          ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                      ],
                      validator: validator?.asValidator(context),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStopFeeCard() {
    return Container(
      width: double.infinity,
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
            // Header
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 24.0,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Taxa por Parada',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.inter(),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0,
                            ),
                      ),
                      Text(
                        'Valor cobrado por cada parada adicional na viagem',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.0),

            // Fee input field
            Row(
              children: [
                Text(
                  'Taxa: R\$',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.0,
                      ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextFormField(
                    controller: _model.stopFeeTextController,
                    focusNode: _model.stopFeeFocusNode,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: '0,00',
                      hintStyle: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
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
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          12.0, 12.0, 12.0, 12.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(),
                          letterSpacing: 0.0,
                        ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                    validator: _model.stopFeeTextControllerValidator
                        ?.asValidator(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePreferences() async {
    if (_model.formKey.currentState == null ||
        !_model.formKey.currentState!.validate()) {
      return;
    }

    try {
      // Parse currency values (only if service is enabled)
      final petFee = (_model.acceptsPetValue ?? false)
          ? _model.parseCurrency(_model.petFeeTextController?.text ?? '')
          : 0.0;
      final groceryFee = (_model.acceptsGroceryValue ?? false)
          ? _model.parseCurrency(_model.groceryFeeTextController?.text ?? '')
          : 0.0;
      final condoFee = (_model.acceptsCondoValue ?? false)
          ? _model.parseCurrency(_model.condoFeeTextController?.text ?? '')
          : 0.0;
      final stopFee = _model.parseCurrency(_model.stopFeeTextController?.text ?? '');

      final acFee = (_model.providesAcValue ?? false)
          ? _model.parseCurrency(_model.acFeeTextController?.text ?? '')
          : 0.0;
      final childSeatFee = (_model.providesChildSeatValue ?? false)
          ? _model.parseCurrency(_model.childSeatFeeTextController?.text ?? '')
          : 0.0;
      final wheelchairFee = (_model.providesWheelchairAccessValue ?? false)
          ? _model.parseCurrency(_model.wheelchairFeeTextController?.text ?? '')
          : 0.0;

      // Converter Firebase UID para Supabase UUID
      final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(currentUserUid);
      if (appUserId == null) {
        print('Error: User not found in system');
        return;
      }

      // Update driver preferences in Supabase
      await DriversTable().update(
        data: {
          'accepts_pet': _model.acceptsPetValue ?? false,
          'pet_fee': petFee,
          'accepts_grocery': _model.acceptsGroceryValue ?? false,
          'grocery_fee': groceryFee,
          'accepts_condo': _model.acceptsCondoValue ?? false,
          'condo_fee': condoFee,
          'stop_fee': stopFee,
        },
        matchingRows: (rows) => rows.eqOrNull('user_id', appUserId),
      );

      // Persist additional preferences: AC, Child Seat, Wheelchair
      final driverRow = await DriversTable().queryRows(
        queryFn: (q) => q.eqOrNull('user_id', appUserId).limit(1),
      );
      if (driverRow.isNotEmpty) {
        final driverId = driverRow.first.id;
        final upserts = [
          {
            'driver_id': driverId,
            'preference_key': 'needs_ac',
            'enabled': _model.providesAcValue ?? false,
            'fee': acFee,
          },
          {
            'driver_id': driverId,
            'preference_key': 'needs_child_seat',
            'enabled': _model.providesChildSeatValue ?? false,
            'fee': childSeatFee,
          },
          {
            'driver_id': driverId,
            'preference_key': 'needs_wheelchair_access',
            'enabled': _model.providesWheelchairAccessValue ?? false,
            'fee': wheelchairFee,
          },
        ];

        for (final data in upserts) {
          await SupaFlow.client
              .from('driver_preference_fees')
              .upsert(data, onConflict: 'driver_id,preference_key');
        }
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Preferências salvas com sucesso!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: Duration(milliseconds: 3000),
          backgroundColor: Color(0xFF007047),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );

      // Go back to menu
      context.goNamed('menuMotorista');
    } catch (e) {
      print('Error saving preferences: $e');

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao salvar preferências. Tente novamente.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: Duration(milliseconds: 3000),
          backgroundColor: FlutterFlowTheme.of(context).error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );
    }
  }
}
