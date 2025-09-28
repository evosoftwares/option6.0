import 'package:flutter/material.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_zona_exclusao_model.dart';
export 'add_zona_exclusao_model.dart';

class AddZonaExclusaoWidget extends StatefulWidget {
  const AddZonaExclusaoWidget({super.key});

  static String routeName = 'AddZonaExclusao';
  static String routePath = '/addZonaExclusao';

  @override
  State<AddZonaExclusaoWidget> createState() => _AddZonaExclusaoWidgetState();
}

class _AddZonaExclusaoWidgetState extends State<AddZonaExclusaoWidget> {
  late AddZonaExclusaoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddZonaExclusaoModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  List<String> _getExamplesForType(String type) {
    switch (type) {
      case 'Rua/Av.':
        return ['Rua das Flores', 'Avenida Paulista', 'Rua Augusta'];
      case 'Bairro':
        return ['Centro', 'Vila Madalena', 'Jardins'];
      case 'Cidade':
        return ['São Paulo', 'Rio de Janeiro', 'Belo Horizonte'];
      default:
        return [];
    }
  }

  String _getHintForType(String type) {
    switch (type) {
      case 'Rua/Av.':
        return 'Digite o nome da rua ou avenida';
      case 'Bairro':
        return 'Digite o nome do bairro';
      case 'Cidade':
        return 'Digite o nome da cidade';
      default:
        return 'Digite o local';
    }
  }

  bool _isFormValid() {
    return _model.choiceChipsValue != null &&
           _model.textController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 20.0,
                          borderWidth: 1.0,
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
                        Expanded(
                          child: Text(
                            'Adicionar Zona de Exclusão',
                            style: FlutterFlowTheme.of(context).headlineMedium.override(
                              fontFamily: 'Inter',
                              useGoogleFonts: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Criar Nova Zona de Exclusão',
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'Inter',
                            useGoogleFonts: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                          child: Text(
                            'Defina áreas onde você não deseja receber solicitações de corrida. Isso ajuda a otimizar sua rota e evitar locais inconvenientes.',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              useGoogleFonts: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Escopo da Zona',
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter',
                            useGoogleFonts: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: FlutterFlowChoiceChips(
                                  options: [
                                    ChipData('Rua/Av.'),
                                    ChipData('Bairro'),
                                    ChipData('Cidade')
                                  ],
                                  onChanged: (val) => setState(() => _model.choiceChipsValue = val?.firstOrNull),
                                  selectedChipStyle: ChipStyle(
                                    backgroundColor: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      useGoogleFonts: true,
                                    ),
                                    iconColor: FlutterFlowTheme.of(context).primaryText,
                                    iconSize: 18.0,
                                    elevation: 4.0,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  unselectedChipStyle: ChipStyle(
                                    backgroundColor: FlutterFlowTheme.of(context).alternate,
                                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      useGoogleFonts: true,
                                    ),
                                    iconColor: FlutterFlowTheme.of(context).secondaryText,
                                    iconSize: 18.0,
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  chipSpacing: 12.0,
                                  rowSpacing: 12.0,
                                  multiselect: false,
                                  alignment: WrapAlignment.start,
                                  controller: _model.choiceChipsValueController ??= FormFieldController<List<String>>([]),
                                  wrapped: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_model.choiceChipsValue != null)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Escreva abaixo o ${_model.choiceChipsValue?.toLowerCase()} que deseja excluir:',
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter',
                              useGoogleFonts: true,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                            child: Text(
                              'Exemplos de ${_model.choiceChipsValue}:',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Inter',
                                useGoogleFonts: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              direction: Axis.horizontal,
                              runAlignment: WrapAlignment.start,
                              verticalDirection: VerticalDirection.down,
                              clipBehavior: Clip.none,
                              children: _getExamplesForType(_model.choiceChipsValue ?? '')
                                  .map((example) => InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          setState(() {
                                            _model.textController?.text = example;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: BorderRadius.circular(20.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).alternate,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
                                            child: Text(
                                              example,
                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                fontFamily: 'Inter',
                                                color: FlutterFlowTheme.of(context).primaryText,
                                                useGoogleFonts: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                            child: TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: _getHintForType(_model.choiceChipsValue ?? ''),
                                labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Inter',
                                  useGoogleFonts: true,
                                ),
                                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Inter',
                                  useGoogleFonts: true,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).alternate,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                useGoogleFonts: true,
                              ),
                              validator: _model.textControllerValidator.asValidator(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 48.0, 0.0, 24.0),
                    child: FFButtonWidget(
                      onPressed: !_isFormValid()
                          ? null
                          : () async {
                              if (_model.choiceChipsValue != null &&
                                  _model.textController.text.isNotEmpty) {
                                await DriverExcludedZonesTable().insert({
                                  'driver_id': currentUserUid,
                                  'zone_type': _model.choiceChipsValue,
                                  'zone_name': _model.textController.text,
                                  'created_at': supaSerialize<DateTime>(getCurrentTimestamp),
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Zona de exclusão adicionada com sucesso!',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context).primaryText,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                                  ),
                                );

                                context.safePop();
                              }
                            },
                      text: 'Adicionar Zona de Exclusão',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: _isFormValid()
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          useGoogleFonts: true,
                        ),
                        elevation: _isFormValid() ? 2.0 : 0.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ].divide(SizedBox(height: 11.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
