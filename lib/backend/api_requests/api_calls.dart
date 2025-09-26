import 'dart:convert';
import 'package:flutter/foundation.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GoogleConvertGeocodeCall {
  static Future<ApiCallResponse> call({
    String? lat = '',
    String? lng = '',
    String? apiKey = 'AIzaSyDU_PTxyu1HVmVhy98FvWyHRaIYhVjL4S4',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'google convert geocode',
      apiUrl:
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=${apiKey}',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ObterQRCodeCall {
  static Future<ApiCallResponse> call({
    String? id = '',
  }) async {
    final ffApiRequestBody = '''
{
  "paymentId": "${id}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Obter QR Code',
      apiUrl:
          'https://qlbwacmavngtonauxnte.supabase.co/functions/v1/obter-qr-code',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? linkPix(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.payload''',
      ));
  static String? imagem(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.encodedImage''',
      ));
}

class ChecaStatusCobrancaCall {
  static Future<ApiCallResponse> call({
    String? id = '',
  }) async {
    final ffApiRequestBody = '''
{
  "paymentId": "${id}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Checa Status Cobranca',
      apiUrl:
          'https://qlbwacmavngtonauxnte.supabase.co/functions/v1/checar-status-cobranca',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? statusPagamento(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
}

class CriarClienteAsaasCall {
  static Future<ApiCallResponse> call({
    String? name = '',
    String? cpfCnpj = '',
    String? email = '',
    String? phone = '',
    String? postalCode = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${escapeStringForJson(name)}",
  "cpfCnpj": "${escapeStringForJson(cpfCnpj)}",
  "email": "${escapeStringForJson(email)}",
  "phone": "${escapeStringForJson(phone)}",
  "postalCode": "${escapeStringForJson(postalCode)}",
  "notificationDisabled": true
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Criar Cliente Asaas',
      apiUrl:
          'https://qlbwacmavngtonauxnte.supabase.co/functions/v1/criar-cliente-asaas',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? idCerto(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.id''',
      ));
}

class CriarCobrancaAsaasCall {
  static Future<ApiCallResponse> call({
    String? customer = '',
    String? billingType = '',
    double? value,
    String? dueDate = '',
    String? description = '',
    String? holderName = '',
    String? number = '',
    String? expiryMonth = '',
    String? expiryYear = '',
    String? ccv = '',
    String? name = '',
    String? email = '',
    String? cpfCnpj = '',
    String? postalCode = '',
    String? adressNumber = '',
    String? phone = '',
    String? remoteIp = '',
  }) async {
    final ffApiRequestBody = '''
{
  "customer": "${escapeStringForJson(customer)}",
  "billingType": "${escapeStringForJson(billingType)}",
  "value": ${value},
  "dueDate": "${escapeStringForJson(dueDate)}",
  "description": "${escapeStringForJson(description)}",
  "creditCard": {
    "holderName": "${escapeStringForJson(holderName)}",
    "number": "${escapeStringForJson(number)}",
    "expiryMonth": "${escapeStringForJson(expiryMonth)}",
    "expiryYear": "${escapeStringForJson(expiryYear)}",
    "ccv": "${escapeStringForJson(ccv)}"
  },
  "creditCardHolderInfo": {
    "name": "${escapeStringForJson(name)}",
    "email": "${escapeStringForJson(email)}",
    "cpfCnpj": "${escapeStringForJson(cpfCnpj)}",
    "postalCode": "${escapeStringForJson(postalCode)}",
    "addressNumber": "${escapeStringForJson(adressNumber)}",
    "phone": "${escapeStringForJson(phone)}"
  },
  "remoteIp": "${escapeStringForJson(remoteIp)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Criar Cobranca Asaas via Edge Function',
      apiUrl:
          'https://qlbwacmavngtonauxnte.supabase.co/functions/v1/criar-cobranca-asaas',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? idPagamento(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.id''',
      ));
}

class SaqueCall {
  static Future<ApiCallResponse> call({
    double? value,
    String? operationType = 'PIX',
    String? pixAddresKey = '',
    String? pixAdressKeyType = '',
    String? description = 'Saque do Chama Aí',
  }) async {
    final ffApiRequestBody = '''
{
  "value": ${value},
  "operationType": "${escapeStringForJson(operationType)}",
  "pixAddressKey": "${escapeStringForJson(pixAddresKey)}",
  "pixAddressKeyType": "${escapeStringForJson(pixAdressKeyType)}",
  "description": "${escapeStringForJson(description)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Saque',
      apiUrl:
          'https://qlbwacmavngtonauxnte.supabase.co/functions/v1/iniciar-saque-asaas',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class IniciarSaqueAsaasCall {
  static Future<ApiCallResponse> call({
    String? idInterno = '',
    double? valor,
    dynamic dadosBancariosJson,
  }) async {
    final dadosBancarios = _serializeJson(dadosBancariosJson);
    final ffApiRequestBody = '''
{
  "valor": ${valor},
  "idInterno": "${escapeStringForJson(idInterno)}",
  "dadosBancarios": ${dadosBancarios}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'iniciarSaqueAsaas',
      apiUrl:
          'https://iniciar-saque-577837412094.southamerica-east1.run.app/iniciarSaque',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiCalculoDistanciaRotaCall {
  static Future<ApiCallResponse> call({
    String? apiKey = 'AIzaSyA_bXqiI5tTGAKZmdw39x-OUoSUJ9LbE-o',
    String? origem = '',
    String? destino = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'apiCalculoDistanciaRota',
      apiUrl: 'https://maps.googleapis.com/maps/api/distancematrix/json',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'key': apiKey,
        'mode': "driving",
        'origins': origem,
        'destinations': destino,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? distanciaMetros(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.rows[:].elements[:].distance.value''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
