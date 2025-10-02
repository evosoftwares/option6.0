// import '/auth/firebase_auth/auth_util.dart';
// Keep if needed in future; currently not used in this file.
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
// import '/flutter_flow/user_id_converter.dart';
// Keep if needed in future; currently not used in this file.
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'preferencias_passageiro_model.dart';
export 'preferencias_passageiro_model.dart';

class PreferenciasPassageiroWidget extends StatefulWidget {
  const PreferenciasPassageiroWidget({
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

  static String routeName = 'preferenciasPassageiro';
  static String routePath = '/preferenciasPassageiro';

  @override
  State<PreferenciasPassageiroWidget> createState() =>
      _PreferenciasPassageiroWidgetState();
}

class _PreferenciasPassageiroWidgetState
    extends State<PreferenciasPassageiroWidget> {
  late PreferenciasPassageiroModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PreferenciasPassageiroModel());

    // Load passenger preferences on initialization
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadPassengerPreferences();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadPassengerPreferences() async {
    setState(() => _model.isLoading = true);
    try {
      // TODO: Implementar carregamento das preferências do Supabase
      // Por enquanto, usar valores padrão
    } catch (e) {
      print('Erro ao carregar preferências: $e');
    } finally {
      setState(() => _model.isLoading = false);
    }
  }

  Future<void> _savePreferencesAndContinue() async {
    if (_model.isSaving) return;
    
    setState(() => _model.isSaving = true);
    try {
      // TODO: Salvar preferências no Supabase
      
      // Mostrar feedback de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preferências salvas com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Navegar para escolha de motorista com as preferências
      if (mounted) {
        context.pushReplacementNamed(
          'escolhaMotorista',
          queryParameters: {
            'origem': serializeParam(widget.origem, ParamType.FFPlace),
            'destino': serializeParam(widget.destino, ParamType.FFPlace),
            'paradas': serializeParam(widget.paradas, ParamType.FFPlace, isList: true),
            'distancia': serializeParam(widget.distancia, ParamType.double),
            'duracao': serializeParam(widget.duracao, ParamType.int),
            'preco': serializeParam(widget.preco, ParamType.double),
            // Adicionar preferências como parâmetros
            'vehicleCategory': serializeParam(_model.vehicleCategory, ParamType.String),
            'paymentMethod': serializeParam(_model.paymentMethod, ParamType.String),
            'needsPet': serializeParam(_model.needsPet, ParamType.bool),
            'needsGrocerySpace': serializeParam(_model.needsGrocerySpace, ParamType.bool),
            'needsAc': serializeParam(_model.needsAc, ParamType.bool),
            'needsCondoAccess': serializeParam(_model.needsCondoAccess, ParamType.bool),
          }.withoutNulls,
        );
      }
    } catch (e) {
      print('Erro ao salvar preferências: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar preferências. Tente novamente.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _model.isSaving = false);
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
              context.goNamed('mainPassageiro');
            },
          ),
          title: Text(
            'Suas Preferências',
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
          child: _model.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                )
              : Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Descrição
                              Text(
                                'Configure suas preferências para uma viagem personalizada',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              SizedBox(height: 24.0),

                              // Categoria do Veículo
                              _buildSectionTitle('Categoria do Veículo'),
                              SizedBox(height: 12.0),
                              _buildVehicleCategorySelector(),
                              SizedBox(height: 24.0),

                              // Forma de Pagamento
                              _buildSectionTitle('Forma de Pagamento'),
                              SizedBox(height: 12.0),
                              _buildPaymentMethodSelector(),
                              SizedBox(height: 24.0),

                              // Necessidades Especiais
                              _buildSectionTitle('Necessidades Especiais'),
                              SizedBox(height: 12.0),
                              _buildSpecialNeedsSection(),
                              SizedBox(height: 24.0),

                              // Preferências de Conforto
                              _buildSectionTitle('Preferências de Conforto'),
                              SizedBox(height: 12.0),
                              _buildComfortPreferencesSection(),
                              SizedBox(height: 24.0),

                              // Preferências de Viagem
                              _buildSectionTitle('Preferências de Viagem'),
                              SizedBox(height: 12.0),
                              _buildTripPreferencesSection(),
                              SizedBox(height: 32.0),
                            ],
                          ),
                        ),
                      ),
                      // Botão de continuar fixo na parte inferior
                      Container(
                        width: double.infinity,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
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
                          onPressed: _model.isSaving ? null : _savePreferencesAndContinue,
                          text: _model.isSaving ? 'Salvando...' : 'Continuar',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 50.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: FlutterFlowTheme.of(context).headlineSmall.override(
            font: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
            ),
            color: FlutterFlowTheme.of(context).primaryText,
            letterSpacing: 0.0,
            fontSize: 18.0,
          ),
    );
  }

  Widget _buildVehicleCategorySelector() {
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
        child: FutureBuilder<List<PlatformSettingsRow>>(
          future: PlatformSettingsTable().queryRows(
            queryFn: (q) => q,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
              );
            }

            final rows = snapshot.data!;
            final categorias = rows
                .map((e) => e.category)
                .where((e) => e != null && e.trim().isNotEmpty)
                .cast<String>()
                .toSet()
                .toList()
              ..sort();

            if (_model.vehicleCategory.isEmpty && categorias.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _model.vehicleCategory.isEmpty) {
                  setState(() => _model.vehicleCategory = categorias.first);
                }
              });
            }

            if (categorias.isEmpty) {
              return Text(
                'Nenhuma categoria disponível.',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              );
            }

            return Column(
              children: [
                for (final cat in categorias)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildVehicleOption(
                      cat,
                      cat,
                      'Categoria de veículo',
                      Icons.directions_car,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildVehicleOption(
      String value, String title, String description, IconData icon) {
    final isSelected = _model.vehicleCategory == value;
    return InkWell(
      onTap: () {
        setState(() {
          _model.vehicleCategory = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).secondaryText,
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
                          color: isSelected
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
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
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: FlutterFlowTheme.of(context).primary,
                size: 20.0,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
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
          children: [
            _buildPaymentOption(
              'dinheiro',
              'Dinheiro',
              'Pagamento em espécie',
              Icons.money,
            ),
            SizedBox(height: 12.0),
            _buildPaymentOption(
              'cartao',
              'Cartão',
              'Pagamento com cartão de crédito/débito',
              Icons.credit_card,
            ),
            SizedBox(height: 12.0),
            _buildPaymentOption(
              'pix',
              'PIX',
              'Pagamento via PIX',
              Icons.qr_code,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
      String value, String title, String description, IconData icon) {
    final isSelected = _model.paymentMethod == value;
    return InkWell(
      onTap: () {
        setState(() {
          _model.paymentMethod = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).secondaryText,
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
                          color: isSelected
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
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
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: FlutterFlowTheme.of(context).primary,
                size: 20.0,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialNeedsSection() {
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
          children: [
            _buildSwitchOption(
              'Viajo com pet',
              'Preciso de um veículo que aceite animais',
              Icons.pets,
              _model.needsPet,
              (value) => setState(() => _model.needsPet = value),
            ),
            SizedBox(height: 16.0),
            _buildSwitchOption(
              'Espaço para compras',
              'Preciso de espaço extra para bagagens/compras',
              Icons.shopping_bag,
              _model.needsGrocerySpace,
              (value) => setState(() => _model.needsGrocerySpace = value),
            ),
            SizedBox(height: 16.0),
            _buildSwitchOption(
              'Cadeira infantil',
              'Preciso de cadeira de segurança para criança',
              Icons.child_care,
              _model.needsChildSeat,
              (value) => setState(() => _model.needsChildSeat = value),
            ),
            SizedBox(height: 16.0),
            _buildSwitchOption(
              'Acessibilidade',
              'Preciso de veículo adaptado para cadeirante',
              Icons.accessible,
              _model.needsWheelchairAccess,
              (value) => setState(() => _model.needsWheelchairAccess = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComfortPreferencesSection() {
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
          children: [
            _buildSwitchOption(
              'Ar-condicionado',
              'Prefiro veículos com ar-condicionado',
              Icons.ac_unit,
              _model.needsAc,
              (value) => setState(() => _model.needsAc = value),
            ),
            SizedBox(height: 16.0),
            _buildSwitchOption(
              'Acesso a condomínio',
              'Motorista deve ter acesso a condomínios',
              Icons.home,
              _model.needsCondoAccess,
              (value) => setState(() => _model.needsCondoAccess = value),
            ),
            SizedBox(height: 16.0),
            _buildSwitchOption(
              'Viagem silenciosa',
              'Prefiro viagens mais quietas',
              Icons.volume_off,
              _model.preferQuietRide,
              (value) => setState(() => _model.preferQuietRide = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripPreferencesSection() {
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
            Text(
              'Preferência de música',
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    font: GoogleFonts.inter(),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8.0),
            _buildDropdownOption(
              _model.musicPreference,
              [
                {'value': 'sem_preferencia', 'label': 'Sem preferência'},
                {'value': 'musica_baixa', 'label': 'Música baixa'},
                {'value': 'sem_musica', 'label': 'Sem música'},
                {'value': 'minha_playlist', 'label': 'Posso conectar minha playlist'},
              ],
              (value) => setState(() => _model.musicPreference = value!),
            ),
            SizedBox(height: 16.0),
            Text(
              'Preferência de conversa',
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    font: GoogleFonts.inter(),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8.0),
            _buildDropdownOption(
              _model.conversationPreference,
              [
                {'value': 'sem_preferencia', 'label': 'Sem preferência'},
                {'value': 'gosto_conversar', 'label': 'Gosto de conversar'},
                {'value': 'prefiro_silencio', 'label': 'Prefiro silêncio'},
                {'value': 'apenas_necessario', 'label': 'Apenas o necessário'},
              ],
              (value) => setState(() => _model.conversationPreference = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchOption(
    String title,
    String description,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
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
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
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
          value: value,
          onChanged: onChanged,
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return FlutterFlowTheme.of(context).primary;
            }
            return FlutterFlowTheme.of(context).secondaryText;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return FlutterFlowTheme.of(context).primary.withAlpha(77);
            }
            return FlutterFlowTheme.of(context).alternate;
          }),
        ),
      ],
    );
  }

  Widget _buildDropdownOption(
    String currentValue,
    List<Map<String, String>> options,
    Function(String?) onChanged,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          border: InputBorder.none,
        ),
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option['value'],
            child: Text(
              option['label']!,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(),
                    letterSpacing: 0.0,
                  ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(),
              letterSpacing: 0.0,
            ),
      ),
    );
  }
}