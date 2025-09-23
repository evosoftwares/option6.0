import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tags_avaliacao_model.dart';
export 'tags_avaliacao_model.dart';

/// Widget de Tags de Avaliação
/// Permite selecionar múltiplas tags para complementar a avaliação
/// Inclui sets de tags específicos para motoristas e passageiros
class TagsAvaliacaoWidget extends StatefulWidget {
  const TagsAvaliacaoWidget({
    super.key,
    required this.tipoAvaliacao,
    this.tagsSelecionadas = const [],
    this.onTagsChanged,
    this.maxTags = 3,
  });

  final String tipoAvaliacao; // 'motorista' ou 'passageiro'
  final List<String> tagsSelecionadas;
  final Function(List<String>)? onTagsChanged;
  final int maxTags;

  @override
  State<TagsAvaliacaoWidget> createState() => _TagsAvaliacaoWidgetState();
}

class _TagsAvaliacaoWidgetState extends State<TagsAvaliacaoWidget> {
  late TagsAvaliacaoModel _model;

  // Tags para avaliar MOTORISTAS (passageiro avalia motorista)
  static const List<String> _tagsMotorista = [
    'Direção Segura',
    'Pontual',
    'Veículo Limpo',
    'Educado',
    'Música Agradável',
    'Rota Eficiente',
    'Conversação Boa',
    'Ar-condicionado',
    'Veículo Confortável',
    'Respeitoso',
    'Ajudou com Bagagem',
    'Seguiu GPS',
  ];

  // Tags para avaliar PASSAGEIROS (motorista avalia passageiro)
  static const List<String> _tagsPassageiro = [
    'Pontual',
    'Educado',
    'Respeitoso',
    'Local Limpo',
    'Seguiu Instruções',
    'Comunicativo',
    'Paciente',
    'Pagamento Rápido',
    'Sem Problemas',
    'Recomendo',
    'Bagagem Organizada',
    'Trajeto Claro',
  ];

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TagsAvaliacaoModel());
    _model.tagsSelecionadas = List.from(widget.tagsSelecionadas);
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  List<String> _obterTagsDisponiveis() {
    return widget.tipoAvaliacao == 'motorista' ? _tagsMotorista : _tagsPassageiro;
  }

  bool _tagEstaSelecionada(String tag) {
    return _model.tagsSelecionadas.contains(tag);
  }

  void _alternarTag(String tag) {
    setState(() {
      if (_tagEstaSelecionada(tag)) {
        _model.tagsSelecionadas.remove(tag);
      } else {
        if (_model.tagsSelecionadas.length < widget.maxTags) {
          _model.tagsSelecionadas.add(tag);
        }
      }
    });

    if (widget.onTagsChanged != null) {
      widget.onTagsChanged!(_model.tagsSelecionadas);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> tagsDisponiveis = _obterTagsDisponiveis();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            'Selecione até ${widget.maxTags} características:',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
              ),
              color: FlutterFlowTheme.of(context).primaryText,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Contador de tags selecionadas
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 16.0),
            child: Text(
              '${_model.tagsSelecionadas.length}/${widget.maxTags} selecionadas',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                font: GoogleFonts.inter(),
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
            ),
          ),

          // Grid de Tags
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: tagsDisponiveis.map((tag) {
              bool selecionada = _tagEstaSelecionada(tag);
              bool podeSelecionar = selecionada || _model.tagsSelecionadas.length < widget.maxTags;

              return GestureDetector(
                onTap: podeSelecionar ? () => _alternarTag(tag) : null,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: selecionada
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: selecionada
                          ? FlutterFlowTheme.of(context).primary
                          : podeSelecionar
                              ? FlutterFlowTheme.of(context).alternate
                              : FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selecionada)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 16.0,
                            ),
                          ),
                        Text(
                          tag,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ),
                            color: selecionada
                                ? Colors.white
                                : podeSelecionar
                                    ? FlutterFlowTheme.of(context).primaryText
                                    : FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Mensagem quando limite atingido
          if (_model.tagsSelecionadas.length >= widget.maxTags)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
              child: Container(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).accent4.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).accent4.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: FlutterFlowTheme.of(context).accent4,
                      size: 16.0,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Limite máximo de tags atingido',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).accent4,
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
    );
  }
}