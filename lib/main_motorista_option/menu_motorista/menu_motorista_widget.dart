import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'menu_motorista_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '/backend/supabase/supabase.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- IMPORTAÇÃO ADICIONADA
export 'menu_motorista_model.dart';

class MenuMotoristaWidget extends StatefulWidget {
  const MenuMotoristaWidget({super.key});

  static String routeName = 'menuMotorista';
  static String routePath = '/menuMotorista';

  @override
  State<MenuMotoristaWidget> createState() => _MenuMotoristaWidgetState();
}

class _MenuMotoristaWidgetState extends State<MenuMotoristaWidget> {
  late MenuMotoristaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuMotoristaModel());

    // Verificar se os dados do veículo estão completos
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.redirecionarParaVeiculoSeIncompleto(context);
    });
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            buttonSize: 40.0,
            icon: Icon(
              Icons.close_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              print('🔍 [MENU_MOTORISTA] Fechando menu e voltando para tela principal');
              context.goNamed('mainMotorista');
            },
          ),
          title: Text(
            'Menu Motorista',
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
          actions: [],
          centerTitle: false,
          elevation: 1.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              // Menu principal
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Suas Viagens - AGORA CLICÁVEL
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print('🔍 [MENU_MOTORISTA] Navegando para Minhas Viagens');
                          context.pushNamed('minhasViagens');
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 26.0,
                                ),
                                Text(
                                  'Suas Viagens',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // Meu Veículo - JÁ CLICÁVEL
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print('🔍 [MENU_MOTORISTA] Navegando para Meu Veículo - consultando dados do driver');
                          _model.rowDriver = await DriversTable().queryRows(
                            queryFn: (q) => q.eqOrNull(
                              'user_id',
                              currentUserUid,
                            ),
                          );
                          print('🔍 [MENU_MOTORISTA] Driver encontrado: ${_model.rowDriver?.firstOrNull?.id}');

                          if (_model.rowDriver?.isNotEmpty == true) {
                            context.pushNamed(
                              'meuVeiculo',
                              queryParameters: {
                                'driver': serializeParam(
                                  _model.rowDriver?.first,
                                  ParamType.SupabaseRow,
                                ),
                              }.withoutNulls,
                            );
                          } else {
                            print('❌ [MENU_MOTORISTA] Nenhum driver encontrado, criando registro...');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Configurando seus dados de motorista...',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: FlutterFlowTheme.of(context).primary,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            context.pushNamed('meuVeiculo');
                          }
                          safeSetState(() {});
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.car_rental,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 26.0,
                                ),
                                Text(
                                  'Meu Veículo',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // Carteira - AGORA CLICÁVEL (redirecionando para carteira do passageiro)
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print('🔍 [MENU_MOTORISTA] Navegando para Carteira do Motorista');
                          // Verificar se existe uma tela específica de carteira para motorista
                          // Por enquanto, redirecionar para uma tela dedicada ou mostrar mensagem
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Carteira do motorista - funcionalidade em desenvolvimento'),
                              backgroundColor: FlutterFlowTheme.of(context).primary,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          // TODO: Implementar tela de carteira específica para motorista
                          // context.pushNamed('carteiraMotorista');
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 26.0,
                                ),
                                Text(
                                  'Carteira',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // Preferências - NOVO ITEM
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print('🔍 [MENU_MOTORISTA] Navegando para Preferências');
                          context.pushNamed('preferenciasMotorista');
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.tune,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                                Text(
                                  'Preferências',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // Ajuda - JÁ CLICÁVEL
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print('🔍 [MENU_MOTORISTA] Navegando para Ajuda');
                          context.pushNamed(SuporteRecuperacaoWidget.routeName);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.help_outline,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                                Text(
                                  'Ajuda',
                                  style: FlutterFlowTheme.of(context)
                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ),

                      // ### NOVO BOTÃO ADICIONADO AQUI ###
                      SizedBox(height: 16.0),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print('🔍 [MENU_MOTORISTA] Navegando para Minhas Avaliações');
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            context.pushNamed(
                              'review_page',
                              queryParameters: {
                                'userId': serializeParam(
                                  user.uid,
                                  ParamType.String,
                                ),
                                'userType': serializeParam(
                                  'motorista',
                                  ParamType.String,
                                ),
                              }.withoutNulls,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erro: Você precisa estar logado.')),
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.star_outline,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                                Text(
                                  'Minhas Avaliações',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16.0),

                      // Privacidade e Localização - Revogar consentimento
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final hasConsent = prefs.getBool('driver_bg_location_consent') ?? false;

                          // Verificar status das permissões
                          final basicLocationStatus = await Permission.location.status;
                          final backgroundLocationStatus = await Permission.locationAlways.status;

                          final bool hasBasicPermission = basicLocationStatus.isGranted;
                          final bool hasBackgroundPermission = backgroundLocationStatus.isGranted;

                          await showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: const Text('Privacidade e Localização'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'O aplicativo coleta sua localização em segundo plano quando você está ONLINE como motorista.',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 16),

                                      // Status das permissões
                                      const Text(
                                        'Status das Permissões:',
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),

                                      Row(
                                        children: [
                                          Icon(
                                            hasBasicPermission ? Icons.check_circle : Icons.cancel,
                                            color: hasBasicPermission ? Colors.green : Colors.red,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          const Expanded(child: Text('Localização básica')),
                                        ],
                                      ),
                                      const SizedBox(height: 4),

                                      Row(
                                        children: [
                                          Icon(
                                            hasBackgroundPermission ? Icons.check_circle : Icons.cancel,
                                            color: hasBackgroundPermission ? Colors.green : Colors.red,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          const Expanded(child: Text('Localização em segundo plano')),
                                        ],
                                      ),
                                      const SizedBox(height: 4),

                                      Row(
                                        children: [
                                          Icon(
                                            hasConsent ? Icons.check_circle : Icons.cancel,
                                            color: hasConsent ? Colors.green : Colors.red,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          const Expanded(child: Text('Consentimento do usuário')),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Status resumido
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: (hasBasicPermission && hasBackgroundPermission && hasConsent)
                                              ? Colors.green.withValues(alpha: 0.1)
                                              : Colors.orange.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: (hasBasicPermission && hasBackgroundPermission && hasConsent)
                                                ? Colors.green
                                                : Colors.orange,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          (hasBasicPermission && hasBackgroundPermission && hasConsent)
                                              ? '✓ Todas as permissões estão configuradas corretamente'
                                              : '⚠ Algumas permissões precisam ser configuradas',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: (hasBasicPermission && hasBackgroundPermission && hasConsent)
                                                ? Colors.green.shade700
                                                : Colors.orange.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('Fechar'),
                                  ),

                                  // Botão para solicitar permissões (se necessário)
                                  if (!hasBasicPermission || !hasBackgroundPermission || !hasConsent)
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(ctx).pop();

                                        // Solicitar permissões através do sistema otimizado
                                        final success = await actions.iniciarRastreamentoViagemOtimizado(context, '');

                                        if (success) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('✓ Permissões configuradas com sucesso!'),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Não foi possível configurar todas as permissões...'),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 4),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Configurar Permissões'),
                                    ),

                                  // Botão para revogar consentimento (se ativo)
                                  if (hasConsent)
                                    TextButton(
                                      onPressed: () async {
                                        await prefs.setBool('driver_bg_location_consent', false);
                                        try {
                                          await actions.pararRastreamentoOtimizado();
                                        } catch (_) {}
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Consentimento revogado. Rastreamento em segundo plano interrompido.'),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 4),
                                            ),
                                          );
                                          Navigator.of(ctx).pop();
                                        }
                                      },
                                      child: const Text('Revogar Consentimento'),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(minHeight: 60.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.privacy_tip,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                                SizedBox(width: 12.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Privacidade e Localização',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Gerencie seu consentimento de rastreamento em segundo plano',
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                              font: GoogleFonts.inter(),
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),

                      // Seção Funcionalidades Exclusivas
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 12.0),
                        child: Text(
                          'Funcionalidades exclusivas',
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),

                      // Zonas de Exclusão - JÁ CLICÁVEL
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print('🔍 [MENU_MOTORISTA] Navegando para Zonas de Exclusão');
                          context.pushNamed(ZonasdeExclusaoMotoristaWidget.routeName);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.location_off,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                                Text(
                                  'Zonas de Exclusão',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                     ),
                      SizedBox(height: 12.0),

                      // Upload de Documentos - JÁ CLICÁVEL
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print('🔍 [MENU_MOTORISTA] Navegando para Upload de Documentos');
                          context.goNamed(DocumentosMotoristaWidget.routeName);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                                Text(
                                  'Upload de Documentos',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botão Sair Seguro (fixo na parte inferior)
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                child: LogoutButtonWidget(
                  buttonText: 'Sair da Conta',
                  showConfirmDialog: true,
                  buttonColor: FlutterFlowTheme.of(context).error,
                  textColor: Colors.white,
                  iconData: Icons.logout,
                  onLogoutComplete: () {
                    print('🔍 [MENU_MOTORISTA] Logout seguro concluído');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
