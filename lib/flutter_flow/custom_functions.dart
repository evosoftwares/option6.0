import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

 dynamic converteLatLngSeparado(String latLngString) {
  try {
    String cleanedString = latLngString
        .replaceAll('LatLng(lat: ', '')
        .replaceAll(', lng: ', ',')
        .replaceAll(')', '')
        .trim();

    List<String> parts = cleanedString.split(',');

    if (parts.length != 2) {
      return {};
    }

    double latitude = double.parse(parts[0].trim());
    double longitude = double.parse(parts[1].trim());

    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  } catch (e) {
    print('Erro ao analisar a string LatLng: $e');
    return {};
  }
 }

 String? getCityFromGeocodingResponse(dynamic geocodingResponseJson) {
  if (geocodingResponseJson == null) {
    return null;
  }

  try {
    // geocodingResponseJson já é um objeto JSON dinâmico (Map ou List)
    // Então, não precisamos de `json.decode` aqui.

    if (geocodingResponseJson['results'] != null &&
        geocodingResponseJson['results'].isNotEmpty) {
      // Acessamos o primeiro resultado, que geralmente é o mais relevante
      final firstResult = geocodingResponseJson['results'][0];

      if (firstResult['address_components'] != null &&
          firstResult['address_components'] is List) {
        for (var component in firstResult['address_components']) {
          if (component['types'] != null &&
              component['types'] is List &&
              component['types'].contains('administrative_area_level_2')) {
            return component['long_name'];
          }
        }
      }
    }
  } catch (e) {
    print('Erro ao extrair a cidade do JSON: $e');
    return null;
  }

  return null;
 }

/// Busca sugestões de endereços via Google Places Autocomplete.
/// Lê a chave da API do arquivo .env usando as variáveis
/// GOOGLE_MAPS_API_KEY ou GOOGLE_PLACES_API_KEY.
Future<List<dynamic>> googlePlacesAutocomplete(
  String input, {
  String language = 'pt-BR',
  String region = 'br',
}) async {
  try {
    if (input.trim().isEmpty) return [];

    final key = dotenv.env['GOOGLE_MAPS_API_KEY'] ??
        dotenv.env['GOOGLE_PLACES_API_KEY'] ??
        '';
    if (key.isEmpty) {
      debugPrint('Google API key not found in .env (GOOGLE_MAPS_API_KEY).');
      return [];
    }

    final uri = Uri.https('maps.googleapis.com',
        '/maps/api/place/autocomplete/json', {
      'input': input,
      'key': key,
      'language': language,
      'components': 'country:$region',
      'types': 'geocode',
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      debugPrint('Places Autocomplete HTTP ${res.statusCode}: ${res.body}');
      return [];
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status == 'OK' || status == 'ZERO_RESULTS') {
      final predictions = (body['predictions'] as List?) ?? [];
      return predictions;
    } else {
      debugPrint(
          'Places Autocomplete error: $status ${body['error_message'] ?? ''}');
      return [];
    }
  } catch (e) {
    debugPrint('Places Autocomplete exception: $e');
    return [];
  }
}

 dynamic converteDataEmJson(String dataa) {
  List<String> partes = dataa.split('/');
  String mes = partes[0];
  String ano = partes[1];

  final intMes = int.tryParse(mes);
  final intAno = int.tryParse(ano);

  if (intMes == null ||
      intMes < 1 ||
      intMes > 12 ||
      intAno == null ||
      intAno < 0 ||
      intAno > 3000) {
    return null;
  }

  return {
    'mes': mes,
    'ano': ano,
  };
 }

 String? verificaBandeiraCartao(String numeroCartao) {
  // Remove quaisquer caracteres não numéricos do número do cartão.
  String numeroLimpo = numeroCartao.replaceAll(RegExp(r'[^0-9]'), '');

  // Se o número limpo estiver vazio, não podemos identificar a bandeira.
  if (numeroLimpo.isEmpty) {
    return 'Desconhecida'; // Ou retorne null se preferir: return null;
  }

  // Expressões regulares para identificar as bandeiras de cartão.
  // Visa: Começa com 4, tem 13 ou 16 dígitos.
  if (RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$').hasMatch(numeroLimpo)) {
    return 'visa';
  }

  // Mastercard: Começa com 51-55 ou 2221-2720, tem 16 dígitos.
  // ADICIONADO: O prefixo 503143 para Mastercard.
  if (RegExp(
          r'^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720|503143)[0-9]{10,13}$') // Ajustado o comprimento final para 16 dígitos no total
      .hasMatch(numeroLimpo)) {
    return 'mastercard';
  }

  // American Express: Começa com 34 ou 37, tem 15 dígitos.
  if (RegExp(r'^3[47][0-9]{13}$').hasMatch(numeroLimpo)) {
    return 'american express';
  }
  // Elo: Vários prefixos. Esta é uma lista comum, mas pode não ser exaustiva.
  // Exemplos: 401178, 401179, 431274, 438935, 451416, 457393, 457631, 457632, 504175, 506699 ... 650XXX, etc.
  // A regex abaixo tenta cobrir uma gama de prefixos conhecidos da Elo.
  if (RegExp(r'^(40117[8-9]|431274|438935|451416|457393|457631|457632|504175|506699|5067[0-6][0-9]|50677[0-8]|509[0-9]{3}|627780|636297|636368|65003[1-3]|65003[5-9]|65004[0-9]|65005[0-1]|6504[0-3][0-9]|65048[5-9]|65049[0-9]|6505[0-2][0-9]|65053[0-8]|65054[1-9]|6505[5-8][0-9]|65059[0-8]|65070[0-9]|65071[0-8]|65072[0-7]|6509[0-1][0-9]|650920|65165[2-9]|6516[6-7][0-9]|65500[0-9]|65501[0-9]|65502[1-9]|6550[3-4][0-9]|65505[0-8])\d{8,15}$')
          .hasMatch(numeroLimpo) ||
      RegExp(r'^(506699|5067[0-7][0-9]|509\d{3}|65003[1-35-9]|65004\d|65005[01]|6504[0-3]\d|65048[5-9]|65049\d|6505[0-2]\d|65053[0-8]|65054[1-9]|6505[5-8]\d|65059[0-8]|65070\d|65071[0-8]|65072[0-7]|6509[01]\d|650920|65165[2-9]|6516[67]\d|65500\d|65501\d|65502[1-9]|6550[34]\d|65505[0-8])\d{10,13}$')
          .hasMatch(numeroLimpo) ||
      RegExp(r'^(401178|401179|431274|438935|451416|457393|457631|457632|504175|627780|636297|636368)\d{10,13}$')
          .hasMatch(numeroLimpo)) {
    return 'elo';
  }
  // Hipercard: Geralmente começa com 606282, 384100, 384140, 384160.
  if (RegExp(r'^(606282|384100|384140|384160)\d{10,13}$')
      .hasMatch(numeroLimpo)) {
    return 'hipercard';
  }

  return 'Desconhecida';
 }

 dynamic separaNome(String nomeCompleto) {
  List<String> partesDoNome = nomeCompleto.trim().split(' ');

  String primeiroNome = '';
  String sobrenome = '';

  if (partesDoNome.isNotEmpty) {
    primeiroNome = partesDoNome[0];

    if (partesDoNome.length > 1) {
      sobrenome = partesDoNome.sublist(1).join(' ');
    }
  }

  Map<String, String> resultado = {
    'primeiroNome': primeiroNome,
    'sobrenome': sobrenome,
  };

  return resultado;
 }

 String mascaraValorDinheiroInitial(double valorASerAlterado) {
  String valorString = valorASerAlterado.toStringAsFixed(2);

  List<String> partes = valorString.split('.');
  String parteInteira = partes[0];
  String parteDecimal = partes.length > 1 ? partes[1] : '00';

  String parteInteiraFormatada = '';
  for (int i = 0; i < parteInteira.length; i++) {
    parteInteiraFormatada += parteInteira[i];
    if ((parteInteira.length - 1 - i) % 3 == 0 &&
        (parteInteira.length - 1 - i) != 0) {
      parteInteiraFormatada += '.';
    }
  }

  return '$parteInteiraFormatada,$parteDecimal';
 }

 double converteStringEmDouble(String valor) {
  String valorLimpo =
      valor.replaceAll('.', ''); //limpa os ponto no caso de valores +999

  valorLimpo = valorLimpo.replaceAll(',', '.'); //troca a virgula por ponto

  return double.parse(valorLimpo);
 }

 String limpaNumero(String numero) {
  String limpaValor =
      numero.replaceAll(RegExp(r'[\(\)\-]'), '').replaceAll(' ', '');

  return limpaValor;
 }

 String colocaParenteseCelular(String celular) {
  if (celular == null || celular.contains('(')) {
    return celular ?? '';
  }

  // Se não estiver formatado, continua com a lógica original
  if (!celular.startsWith('+55') || celular.length < 5) {
    return celular;
  }

  String prefixo = celular.substring(0, 3);
  String ddd = celular.substring(3, 5);
  String numeroPrincipal = celular.substring(5);

  return '$prefixo($ddd)$numeroPrincipal';
 }

 String? limparStringNumerico(String? cpf) {
  if (cpf == null) {
    return null;
  }

  String cpfLimpo = cpf.replaceAll(RegExp(r'\D'), '');

  return cpfLimpo;
 }

 String? limparStringNumericoCopy(String? cpf) {
  if (cpf == null) {
    return null;
  }

  String cpfLimpo = cpf.replaceAll(RegExp(r'\D'), '');

  return cpfLimpo;
 }

 String? imprimDados(
  String? nome,
  String? email,
  String? celular,
  String? cpf,
  String? cep,
 ) {
  print(celular);
  print(nome);
  print(email);
  print(cpf);
  print(cep);

  return ('oi');
}

double garantirValorDouble(dynamic jsonBody) {
  // Se o corpo do JSON for nulo ou não for um mapa, retorna 0.0
  if (jsonBody == null || jsonBody is! Map<String, dynamic>) {
    return 0.0;
  }

  // Extrai o valor do campo 'value' do JSON
  final valor = jsonBody['value'];

  // Se o valor extraído for nulo, retorna 0.0
  if (valor == null) {
    return 0.0;
  }

  // Se o valor já for um double, retorna ele mesmo.
  if (valor is double) {
    return valor;
  }

  // Se for um inteiro, converte para double.
  if (valor is int) {
    return valor.toDouble();
  }

  // Se for uma String, tenta converter.
  if (valor is String) {
    return double.tryParse(valor) ?? 0.0;
  }

  // Para qualquer outro caso, retorna 0.0 como segurança.
  return 0.0;
}

String? distanciaEntrePontosEBuscaLatLng(
  LatLng pontoDePartida,
  String cidadeSeleciona,
  PerfisPrestadorRecord prestadorDoc,
) {
  final areasAtuacaoList = prestadorDoc.areasAtuacao;

  // ignore: unnecessary_null_comparison
  if (areasAtuacaoList != null && areasAtuacaoList.isNotEmpty) {
    LatLng? pontoDeDestino;

    for (var area in areasAtuacaoList) {
      if (area.areaAtuacaoCidade == cidadeSeleciona) {
        if (area.areaAtuacaoLatLnt != null) {
          pontoDeDestino = area.areaAtuacaoLatLnt;
          break;
        }
      }
    }

    if (pontoDeDestino != null) {
      const double earthRadius = 6371;

      double lat1Rad = pontoDePartida.latitude * math.pi / 180;
      double lon1Rad = pontoDePartida.longitude * math.pi / 180;
      double lat2Rad = pontoDeDestino.latitude * math.pi / 180;
      double lon2Rad = pontoDeDestino.longitude * math.pi / 180;

      double deltaLat = lat2Rad - lat1Rad;
      double deltaLon = lon2Rad - lon1Rad;

      double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
          math.cos(lat1Rad) *
              math.cos(lat2Rad) *
              math.sin(deltaLon / 2) *
              math.sin(deltaLon / 2);

      double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

      double distance = earthRadius * c;

      if (distance < 1) {
        return '${(distance * 1000).toStringAsFixed(0)}m';
      } else {
        return '${distance.toStringAsFixed(1)}km';
      }
    }
  }
  return 'N/A';
}

Future<FFPlace?> googlePlaceDetails(
  String placeId, {
  String language = 'pt-BR',
}) async {
  try {
    if (placeId.trim().isEmpty) return null;


    final key = dotenv.env['GOOGLE_MAPS_API_KEY'] ??
        dotenv.env['GOOGLE_PLACES_API_KEY'] ??
        '';
    if (key.isEmpty) {
      debugPrint('Google API key not found in .env (GOOGLE_MAPS_API_KEY).');
      return null;
    }

    debugPrint('🌐 API CALL: Place Details para $placeId');

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': placeId,
        'key': key,
        'language': language,
        // Campos otimizados para melhor performance
        'fields': 'name,formatted_address,geometry/location,address_components',
      },
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      debugPrint('Place Details HTTP ${res.statusCode}: ${res.body}');
      return null;
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status != 'OK') {
      debugPrint('Place Details error: $status ${body['error_message'] ?? ''}');
      return null;
    }

    final result = body['result'] as Map<String, dynamic>?;
    if (result == null) return null;

    final name = (result['name'] as String?) ?? '';
    final formattedAddress = (result['formatted_address'] as String?) ?? '';

    final geometry = result['geometry'] as Map<String, dynamic>?;
    final location = geometry != null ? geometry['location'] as Map<String, dynamic>? : null;
    final lat = (location != null ? location['lat'] : null) as num?;
    final lng = (location != null ? location['lng'] : null) as num?;

    String city = '';
    String state = '';
    String country = '';
    String zipCode = '';

    final components = (result['address_components'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    for (final c in components) {
      final types = (c['types'] as List?)?.cast<String>() ?? const [];
      final longName = (c['long_name'] as String?) ?? '';
      if (types.contains('locality')) {
        city = longName;
      } else if (types.contains('administrative_area_level_1')) {
        state = longName;
      } else if (types.contains('country')) {
        country = longName;
      } else if (types.contains('postal_code')) {
        zipCode = longName;
      }
    }

    final ffPlace = FFPlace(
      latLng: (lat != null && lng != null) ? LatLng(lat.toDouble(), lng.toDouble()) : const LatLng(0.0, 0.0),
      name: name,
      address: formattedAddress,
      city: city,
      state: state,
      country: country,
      zipCode: zipCode,
    );


    return ffPlace;
  } catch (e) {
    debugPrint('Place Details exception: $e');
    return null;
  }
}

String distanciaEntrePontosCopy(
  LatLng pontoA,
  LatLng pintoB,
) {
  const double earthRadius = 6371; // Raio da Terra em quilômetros

  // Converte graus para radianos
  double lat1Rad = pontoA.latitude * math.pi / 180;
  double lon1Rad = pontoA.longitude * math.pi / 180;
  double lat2Rad = pintoB.latitude * math.pi / 180;
  double lon2Rad = pintoB.longitude * math.pi / 180;

  // Diferenças
  double deltaLat = lat2Rad - lat1Rad;
  double deltaLon = lon2Rad - lon1Rad;

  // Fórmula de Haversine
  double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
      math.cos(lat1Rad) *
          math.cos(lat2Rad) *
          math.sin(deltaLon / 2) *
          math.sin(deltaLon / 2);

  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  // Distância em quilômetros
  double distance = earthRadius * c;

  // Retorna formatado
  if (distance < 1) {
    return '${(distance * 1000).toStringAsFixed(0)}m';
  } else {
    return '${distance.toStringAsFixed(1)}km';
  }
}

double calcularProgressoChecklist(List<ChecklistItemStructStruct> listaItens) {
  if (listaItens == null || listaItens.isEmpty) {
    return 0.0;
  }

  // Conta quantos itens têm o campo 'concluido' como true.
  int itensConcluidos =
      listaItens.where((item) => item.concluido == true).length;

  // Calcula a proporção.
  double progresso = itensConcluidos / listaItens.length;

  return progresso;
}

double? calcularValorCorridaPorCategoria(
  double? distanciaEmMetros,
  CategoriasMobilidadeRecord? categoria,
  double valorPorKm,
  double valorMinimoCorrida,
) {
  if (distanciaEmMetros == null || categoria == null) {
    return null;
  }
  // Garante que o fator multiplicador da categoria exista.
  if (!categoria.hasFatorMultiplicador()) {
    return null;
  }

  // --- Lógica de Cálculo ---

  // 1. Converte a distância de metros para quilômetros.
  final double distanciaEmKm = distanciaEmMetros / 1000.0;

  // 2. Calcula o "Custo Base" da viagem, baseado apenas na distância.
  final double custoBase = distanciaEmKm * valorPorKm;

  // 3. Aplica o fator de multiplicação da categoria sobre o custo base.
  // O fatorMultiplicador vem diretamente do documento da categoria no Firestore.
  final double custoComMultiplicador = custoBase * categoria.fatorMultiplicador;

  // 4. Aplica a regra do valor mínimo.
  // O preço final será o maior valor entre o custo calculado e o valor mínimo definido.
  // Isso garante que corridas muito curtas ainda sejam viáveis.
  if (custoComMultiplicador < valorMinimoCorrida) {
    return valorMinimoCorrida;
  } else {
    return custoComMultiplicador;
  }
}

double calcularMediaAvaliacoes(List<double>? listaDeAvaliacoes) {
  if (listaDeAvaliacoes == null || listaDeAvaliacoes.isEmpty) {
    return 0.0;
  }

  double somaTotal =
      listaDeAvaliacoes.fold(0.0, (soma, avaliacao) => soma + avaliacao);

  return somaTotal / listaDeAvaliacoes.length;
}

TipoVeiculoEnum? stringToTipoVeiculoEnum(String tipoString) {
  // Percorre todos os valores possíveis do Enum.
  for (TipoVeiculoEnum enumValue in TipoVeiculoEnum.values) {
    // Compara a representação em String do Enum com a String recebida.
    // O '.toString().split('.').last' pega apenas o nome do valor (ex: "HATCH").
    if (enumValue.toString().split('.').last == tipoString) {
      // Se encontrar uma correspondência, retorna o valor do Enum.
      return enumValue;
    }
  }
  // Se não encontrar nenhuma correspondência após percorrer todos os valores,
  // retorna nulo para indicar que a conversão falhou.
  return null;
}

List<DateTime>? calcularProximaDatas(
  String dataBase,
  String frequencia,
) {
  if (dataBase.isEmpty) {
    return [];
  }
  if (dataBase.isEmpty) {
    return [];
  }

  try {
    final List<String> partes = dataBase.split('/');
    if (partes.length != 3) {
      return [];
    }

    final int dia = int.parse(partes[0]);
    final int mes = int.parse(partes[1]);
    final int ano = int.parse(partes[2]);

    DateTime dataBaseConvertida = DateTime(ano, mes, dia);
    int quantidade = 5;
    List<DateTime> datas = [];
    DateTime dataAtual = dataBaseConvertida;

    for (int i = 0; i < quantidade; i++) {
      switch (frequencia) {
        case "semanalmente":
          dataAtual = dataAtual.add(const Duration(days: 7));
          break;
        case "duasSemanas":
          dataAtual = dataAtual.add(const Duration(days: 14));
          break;
        case "mensal":
          dataAtual =
              DateTime(dataAtual.year, dataAtual.month + 1, dataAtual.day);
          break;
        default:
          return [];
      }
      datas.add(dataAtual);
    }

    return datas;
  } catch (e) {
    print('Erro ao converter ou calcular a data: $e');
    return [];
  }
}

String? calcularProximaData(
  String dataBase,
  String frequencia,
) {
  // Retorna nulo se as entradas estiverem vazias para evitar erros.
  if (dataBase.isEmpty || frequencia.isEmpty) {
    return null;
  }

  try {
    // Tenta converter a string "dd/MM/yyyy" para um objeto DateTime.
    final DateFormat formatadorEntrada = DateFormat('dd/MM/yyyy');
    DateTime dataInicial = formatadorEntrada.parseStrict(dataBase);

    DateTime proximaData;

    // Calcula a próxima data com base na frequência fornecida.
    // Usamos toLowerCase() para garantir que a comparação não seja sensível a maiúsculas/minúsculas.
    switch (frequencia.toLowerCase()) {
      case 'semanalmente':
        proximaData = dataInicial.add(const Duration(days: 7));
        break;
      case 'duassemanas':
        proximaData = dataInicial.add(const Duration(days: 14));
        break;
      case 'mensal':
        // Adiciona um mês, lidando corretamente com meses de tamanhos diferentes.
        proximaData =
            DateTime(dataInicial.year, dataInicial.month + 1, dataInicial.day);
        break;
      default:
        // Se a frequência não for uma das três válidas, retorna nulo.
        print('Frequência "$frequencia" não reconhecida.');
        return null;
    }

    // Formata a data calculada de volta para o formato "dd/MM/yyyy".
    final DateFormat formatadorSaida = DateFormat('dd/MM/yyyy');
    return formatadorSaida.format(proximaData);
  } catch (e) {
    // Se ocorrer um erro na conversão da data, imprime no console e retorna nulo.
    print('Erro ao converter ou calcular a data: $e');
    return null;
  }
}

String emailMinusculo(String email) {
  return email.toLowerCase();
}

String? printImage(String? endereamento) {
  print(endereamento);

  return (endereamento);
}

String? debugImageListToString(List<String>? listaDeImagens) {
  if (listaDeImagens == null || listaDeImagens.isEmpty) {
    return "A lista de imagens está VAZIA ou NULA.";
  }

  // Se a lista não estiver vazia, formata para exibição
  String conteudo = listaDeImagens
      .join('\n- '); // Junta cada item com uma nova linha e um traço

  return "Itens na lista: ${listaDeImagens.length}\n\nCaminhos:\n- ${conteudo}";
}
