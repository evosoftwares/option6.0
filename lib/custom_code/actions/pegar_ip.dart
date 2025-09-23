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

/*import '/backend/backend.dart';

import 'package:public_ip_address/public_ip_address.dart';

Future<String?> pegarIp() async {
  // Add your function code here!

  IpAddress _ipAddress = IpAddress();
  var ip = await _ipAddress.getIp();
  print(ip);
  return ip;
}*/

// ... (NÃO MUDE OS IMPORTS AUTOMÁTICOS) ...

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> pegarIp() async {
  // Esta função agora usa o pacote http para chamar uma API que funciona na web.

  try {
    final response = await http.get(
      Uri.parse('https://api.ipify.org?format=json'),
    );

    if (response.statusCode == 200) {
      // Se a chamada foi bem-sucedida, extrai o IP da resposta.
      final data = json.decode(response.body);
      return data['ip'];
    } else {
      // Se houve um erro na resposta do servidor.
      print('Falha ao obter o IP. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Se ocorreu um erro na chamada (ex: sem internet).
    print('Erro ao obter o IP: $e');
    return null;
  }
}
