// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_background_service/flutter_background_service.dart';

/// Envia um comando para interromper o serviço de localização em background.
///
/// OBS: Mantido para compatibilidade com o rastreamento LEGADO. Para o fluxo
/// otimizado, utilize `pararRastreamentoOtimizado()` exportado em index.dart.
///
/// Esta ação deve ser vinculada a um evento de interface, como o clique de um botão,
/// para permitir que o usuário pare o rastreamento em tempo real.
Future<void> encerrarLocEmTempoReal() async {
  // Obtém a instância do serviço de background.
  final service = FlutterBackgroundService();

  // Verifica se o serviço está em execução para evitar chamadas desnecessárias.
  bool isRunning = await service.isRunning();
  if (isRunning) {
    // Invoca o evento 'stopService'. O serviço em background deve ser configurado
    // para ouvir este evento e executar sua lógica de encerramento.
    service.invoke('stopService');
  }
}
