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

import 'dart:convert';

class DebugDisplayWidget extends StatefulWidget {
  const DebugDisplayWidget({
    super.key,
    this.width,
    this.height,
    this.ipAddress,
    this.apiClienteResponse,
    this.apiCobrancaResponse,
    this.apiPixResponse,
  });

  final double? width;
  final double? height;
  final String? ipAddress;
  final dynamic apiClienteResponse;
  final dynamic apiCobrancaResponse;
  final dynamic apiPixResponse;

  @override
  State<DebugDisplayWidget> createState() => _DebugDisplayWidgetState();
}

class _DebugDisplayWidgetState extends State<DebugDisplayWidget> {
  // Função auxiliar para formatar o JSON de forma legível.
  String _formatJson(dynamic json) {
    if (json == null) {
      return 'N/A (Nulo ou Vazio)';
    }
    try {
      // Tenta decodificar e re-codificar com indentação.
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (e) {
      // Se não for um JSON válido, apenas retorna o conteúdo como texto.
      return json.toString();
    }
  }

  // Função para criar cada "cartão" de informação.
  Widget _buildInfoCard(String title, dynamic content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(
                _formatJson(content),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // O widget em si, que será uma lista rolável com os cartões de debug.
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          _buildInfoCard(
              'Endereço de IP Capturado', widget.ipAddress ?? 'Não capturado'),
          _buildInfoCard(
              'Resposta API - Criar Cliente', widget.apiClienteResponse),
          _buildInfoCard(
              'Resposta API - Criar Cobrança', widget.apiCobrancaResponse),
          _buildInfoCard(
              'Resposta API - Obter QR Code (PIX)', widget.apiPixResponse),
        ],
      ),
    );
  }
}
