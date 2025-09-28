// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class ChecklistTilePerfeito extends StatefulWidget {
  const ChecklistTilePerfeito({
    super.key,
    this.width,
    this.height,
    required this.textoDoItem,
    required this.foiConcluido,
    required this.acaoAoMudar,
  });

  final double? width;
  final double? height;
  final String textoDoItem;
  final bool foiConcluido;
  final Future Function(bool novoValor) acaoAoMudar;

  @override
  State<ChecklistTilePerfeito> createState() => _ChecklistTilePerfeitoState();
}

class _ChecklistTilePerfeitoState extends State<ChecklistTilePerfeito> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    // Inicializa o estado interno do widget com o valor vindo do banco.
    _isChecked = widget.foiConcluido;
  }

  // ESTA É A PARTE MAIS IMPORTANTE:
  // Este método é chamado sempre que a página é reconstruída com novos dados.
  // Ele garante que o estado visual do checkbox SEMPRE reflita o estado real do banco de dados.
  @override
  void didUpdateWidget(covariant ChecklistTilePerfeito oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.foiConcluido != _isChecked) {
      setState(() {
        _isChecked = widget.foiConcluido;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos um InkWell para tornar a linha inteira clicável.
    return InkWell(
      onTap: () {
        // Quando o usuário toca na linha, chamamos a ação da página,
        // invertendo o valor atual do checkbox.
        widget.acaoAoMudar(!_isChecked);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                widget.textoDoItem,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Checkbox(
              value: _isChecked,
              onChanged: (bool? newValue) async {
                // O onChanged do Checkbox também chama a ação principal.
                if (newValue != null) {
                  await widget.acaoAoMudar(newValue);
                }
              },
-              activeColor: FlutterFlowTheme.of(context).primary,
+              activeColor: FlutterFlowTheme.of(context).primary,
               checkColor: FlutterFlowTheme.of(context).info,
            ),
          ],
        ),
      ),
    );
  }
}
