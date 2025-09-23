import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rating_estrelas_model.dart';
export 'rating_estrelas_model.dart';

/// Widget de Rating com Estrelas para Avaliações
/// Permite selecionar uma avaliação de 1 a 5 estrelas
/// Inclui feedback visual e animações suaves
class RatingEstrelasWidget extends StatefulWidget {
  const RatingEstrelasWidget({
    super.key,
    this.ratingAtual = 0,
    this.onRatingChanged,
    this.tamanhoEstrela = 40.0,
    this.somenteLeitura = false,
    this.mostrarTexto = true,
  });

  final int ratingAtual;
  final Function(int)? onRatingChanged;
  final double tamanhoEstrela;
  final bool somenteLeitura;
  final bool mostrarTexto;

  @override
  State<RatingEstrelasWidget> createState() => _RatingEstrelasWidgetState();
}

class _RatingEstrelasWidgetState extends State<RatingEstrelasWidget> {
  late RatingEstrelasModel _model;
  int _ratingHover = 0;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RatingEstrelasModel());
    _model.ratingAtual = widget.ratingAtual;
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  String _obterTextoRating(int rating) {
    switch (rating) {
      case 1:
        return 'Muito Ruim';
      case 2:
        return 'Ruim';
      case 3:
        return 'Regular';
      case 4:
        return 'Bom';
      case 5:
        return 'Excelente';
      default:
        return 'Toque para avaliar';
    }
  }

  Color _obterCorEstrela(int posicao) {
    int ratingParaUsar = _ratingHover > 0 ? _ratingHover : _model.ratingAtual;

    if (posicao <= ratingParaUsar) {
      switch (ratingParaUsar) {
        case 1:
        case 2:
          return Colors.red;
        case 3:
          return Colors.orange;
        case 4:
        case 5:
          return Colors.amber;
        default:
          return FlutterFlowTheme.of(context).secondaryText;
      }
    }
    return FlutterFlowTheme.of(context).secondaryText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Linha de Estrelas
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              int posicao = index + 1;
              return MouseRegion(
                onEnter: widget.somenteLeitura ? null : (_) {
                  setState(() {
                    _ratingHover = posicao;
                  });
                },
                onExit: widget.somenteLeitura ? null : (_) {
                  setState(() {
                    _ratingHover = 0;
                  });
                },
                child: GestureDetector(
                  onTap: widget.somenteLeitura ? null : () {
                    setState(() {
                      _model.ratingAtual = posicao;
                      _ratingHover = 0;
                    });
                    if (widget.onRatingChanged != null) {
                      widget.onRatingChanged!(posicao);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      child: Icon(
                        posicao <= (_ratingHover > 0 ? _ratingHover : _model.ratingAtual)
                            ? Icons.star
                            : Icons.star_border,
                        color: _obterCorEstrela(posicao),
                        size: widget.tamanhoEstrela,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          // Texto de Feedback
          if (widget.mostrarTexto)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Text(
                  _obterTextoRating(_ratingHover > 0 ? _ratingHover : _model.ratingAtual),
                  key: ValueKey(_ratingHover > 0 ? _ratingHover : _model.ratingAtual),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                    ),
                    color: _obterCorEstrela(_ratingHover > 0 ? _ratingHover : _model.ratingAtual),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}