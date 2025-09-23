import '/components/rating_estrelas_widget.dart';
import '/components/tags_avaliacao_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/actions/actions.dart' as action_blocks;
import '/custom_code/actions/processar_avaliacao.dart' as custom_actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'avaliar_passageiro_model.dart';
export 'avaliar_passageiro_model.dart';

/// Tela de Avaliação do Passageiro
/// Permite que o motorista avalie o passageiro após a viagem
/// Inclui rating com estrelas, tags e comentário opcional
class AvaliarPassageiroWidget extends StatefulWidget {
  const AvaliarPassageiroWidget({
    super.key,
    required this.tripId,
    this.passageiroNome,
    this.origemDestino,
  });

  final String tripId;
  final String? passageiroNome;
  final String? origemDestino;

  static String routeName = 'avaliarPassageiro';
  static String routePath = '/avaliarPassageiro';

  @override
  State<AvaliarPassageiroWidget> createState() => _AvaliarPassageiroWidgetState();
}

class _AvaliarPassageiroWidgetState extends State<AvaliarPassageiroWidget> {
  late AvaliarPassageiroModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AvaliarPassageiroModel());

    _model.comentarioTextController ??= TextEditingController();
    _model.comentarioFocusNode ??= FocusNode();
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            buttonSize: 46.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'Avaliar Passageiro',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              font: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
              ),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações da Viagem
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48.0,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.passageiroNome ?? 'Passageiro',
                                        style: FlutterFlowTheme.of(context).titleMedium.override(
                                          font: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (widget.origemDestino != null)
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                          child: Text(
                                            widget.origemDestino!,
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                              font: GoogleFonts.inter(),
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Seção de Rating
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Como foi o passageiro?',
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                            ),
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                          child: Text(
                            'Sua avaliação ajuda a manter a qualidade do serviço',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                          child: Center(
                            child: RatingEstrelasWidget(
                              ratingAtual: _model.rating,
                              onRatingChanged: (newRating) {
                                setState(() {
                                  _model.rating = newRating;
                                });
                              },
                              tamanhoEstrela: 50.0,
                              mostrarTexto: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Seção de Tags
                  if (_model.rating > 0)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                      child: TagsAvaliacaoWidget(
                        tipoAvaliacao: 'passageiro',
                        tagsSelecionadas: _model.tagsSelecionadas,
                        onTagsChanged: (tags) {
                          setState(() {
                            _model.tagsSelecionadas = tags;
                          });
                        },
                        maxTags: 3,
                      ),
                    ),

                  // Seção de Comentário
                  if (_model.rating > 0)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Comentário (opcional)',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _model.comentarioTextController,
                                focusNode: _model.comentarioFocusNode,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'Compartilhe sua experiência com o passageiro...',
                                  hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(),
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).alternate,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).primary,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(),
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                ),
                                maxLines: 4,
                                maxLength: 300,
                                validator: _model.comentarioTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Botão de Enviar
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 32.0),
                    child: FFButtonWidget(
                      onPressed: _model.rating == 0 ? null : () async {
                        // Processar avaliação
                        await _processarAvaliacao();
                      },
                      text: 'Enviar Avaliação',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: _model.rating == 0
                            ? FlutterFlowTheme.of(context).secondaryText
                            : FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                          ),
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
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

  Future<void> _processarAvaliacao() async {
    // Usar custom action para processar avaliação de forma inteligente
    final resultado = await custom_actions.processarAvaliacao(
      widget.tripId,
      'passageiro',
      _model.rating,
      _model.tagsSelecionadas,
      _model.comentarioTextController.text.isNotEmpty
          ? _model.comentarioTextController.text
          : null,
    );

    if (resultado['sucesso'] == true) {
      // Mostrar feedback de sucesso
      await action_blocks.snackSalvo(context);

      // Voltar para tela anterior
      context.safePop();
    } else {
      // Mostrar erro
      await action_blocks.alertaNegativo(
        context,
        mensagem: resultado['erro'] ?? 'Erro ao enviar avaliação. Tente novamente.',
      );
    }
  }
}