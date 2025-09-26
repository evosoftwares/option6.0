import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'menu_passageiro_model.dart';
export 'menu_passageiro_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuPassageiroWidget extends StatefulWidget {
  const MenuPassageiroWidget({super.key});

  static String routeName = 'menuPassageiro';
  static String routePath = '/menuPassageiro';

  @override
  State<MenuPassageiroWidget> createState() => _MenuPassageiroWidgetState();
}

class _MenuPassageiroWidgetState extends State<MenuPassageiroWidget> {
  late MenuPassageiroModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuPassageiroModel());
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
              print('🔍 [MENU_PASSAGEIRO] Fechando menu e voltando para tela principal');
              context.goNamed('mainPassageiro');
            },
          ),
          title: Text(
            'Menu Passageiro',
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
                      // Suas Viagens
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print('🔍 [MENU_PASSAGEIRO] Navegando para Minhas Viagens');
                          context.pushNamed(MinhasViagensPaxWidget.routeName);
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
                                  Icons.history,
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

                      // Carteira
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print('🔍 [MENU_PASSAGEIRO] Navegando para Carteira');
                          context.pushNamed(CarteiraPassageiroWidget.routeName);
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

                      // Ajuda
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print('🔍 [MENU_PASSAGEIRO] Navegando para Ajuda');
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
                      SizedBox(height: 16.0),
                      
                      // ### NOVO BOTÃO ADICIONADO AQUI ###
                      // Minhas Avaliações
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        
                        onTap: () async {
                          print(' [MENU_PASSAGEIRO] A navegar para As Minhas Avaliações');
  
                           // 1. Obtém o utilizador atual do Firebase
                          final user = FirebaseAuth.instance.currentUser;
  
                           // 2. Verifica se o utilizador está realmente autenticado
                          if (user != null) {
                            // 3. Se estiver autenticado, navega para a página
                             context.pushNamed(
                              'review_page',
                                queryParameters: {
                                  'userId': serializeParam(
                                    user.uid, // Agora o 'user' está definido e o erro desaparece
                                    ParamType.String,
                                  ),
                                  'userType': serializeParam(
                                    'passageiro', 
                                    ParamType.String,
                                  ),
                                }.withoutNulls,                       
                            );
                          } else {
                            print('Erro: Nenhum utilizador autenticado para ver as avaliações.');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erro: Precisa de estar autenticado.'))
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
                                  Icons.star_outline, // Ícone de estrela
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 26.0,
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
                    print('🔍 [MENU_PASSAGEIRO] Logout seguro concluído');
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