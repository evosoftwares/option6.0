// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class EnderecoComercialStruct extends FFFirebaseStruct {
  EnderecoComercialStruct({
    String? cep,
    String? logradouro,
    String? cidade,
    String? estado,
    String? numero,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _cep = cep,
        _logradouro = logradouro,
        _cidade = cidade,
        _estado = estado,
        _numero = numero,
        super(firestoreUtilData);

  // "cep" field.
  String? _cep;
  String get cep => _cep ?? '';
  set cep(String? val) => _cep = val;

  bool hasCep() => _cep != null;

  // "logradouro" field.
  String? _logradouro;
  String get logradouro => _logradouro ?? '';
  set logradouro(String? val) => _logradouro = val;

  bool hasLogradouro() => _logradouro != null;

  // "cidade" field.
  String? _cidade;
  String get cidade => _cidade ?? '';
  set cidade(String? val) => _cidade = val;

  bool hasCidade() => _cidade != null;

  // "estado" field.
  String? _estado;
  String get estado => _estado ?? '';
  set estado(String? val) => _estado = val;

  bool hasEstado() => _estado != null;

  // "numero" field.
  String? _numero;
  String get numero => _numero ?? '';
  set numero(String? val) => _numero = val;

  bool hasNumero() => _numero != null;

  static EnderecoComercialStruct fromMap(Map<String, dynamic> data) =>
      EnderecoComercialStruct(
        cep: data['cep'] as String?,
        logradouro: data['logradouro'] as String?,
        cidade: data['cidade'] as String?,
        estado: data['estado'] as String?,
        numero: data['numero'] as String?,
      );

  static EnderecoComercialStruct? maybeFromMap(dynamic data) => data is Map
      ? EnderecoComercialStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'cep': _cep,
        'logradouro': _logradouro,
        'cidade': _cidade,
        'estado': _estado,
        'numero': _numero,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'cep': serializeParam(
          _cep,
          ParamType.String,
        ),
        'logradouro': serializeParam(
          _logradouro,
          ParamType.String,
        ),
        'cidade': serializeParam(
          _cidade,
          ParamType.String,
        ),
        'estado': serializeParam(
          _estado,
          ParamType.String,
        ),
        'numero': serializeParam(
          _numero,
          ParamType.String,
        ),
      }.withoutNulls;

  static EnderecoComercialStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      EnderecoComercialStruct(
        cep: deserializeParam(
          data['cep'],
          ParamType.String,
          false,
        ),
        logradouro: deserializeParam(
          data['logradouro'],
          ParamType.String,
          false,
        ),
        cidade: deserializeParam(
          data['cidade'],
          ParamType.String,
          false,
        ),
        estado: deserializeParam(
          data['estado'],
          ParamType.String,
          false,
        ),
        numero: deserializeParam(
          data['numero'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'EnderecoComercialStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EnderecoComercialStruct &&
        cep == other.cep &&
        logradouro == other.logradouro &&
        cidade == other.cidade &&
        estado == other.estado &&
        numero == other.numero;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([cep, logradouro, cidade, estado, numero]);
}

EnderecoComercialStruct createEnderecoComercialStruct({
  String? cep,
  String? logradouro,
  String? cidade,
  String? estado,
  String? numero,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EnderecoComercialStruct(
      cep: cep,
      logradouro: logradouro,
      cidade: cidade,
      estado: estado,
      numero: numero,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EnderecoComercialStruct? updateEnderecoComercialStruct(
  EnderecoComercialStruct? enderecoComercial, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    enderecoComercial
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEnderecoComercialStructData(
  Map<String, dynamic> firestoreData,
  EnderecoComercialStruct? enderecoComercial,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (enderecoComercial == null) {
    return;
  }
  if (enderecoComercial.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && enderecoComercial.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final enderecoComercialData =
      getEnderecoComercialFirestoreData(enderecoComercial, forFieldValue);
  final nestedData =
      enderecoComercialData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = enderecoComercial.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEnderecoComercialFirestoreData(
  EnderecoComercialStruct? enderecoComercial, [
  bool forFieldValue = false,
]) {
  if (enderecoComercial == null) {
    return {};
  }
  final firestoreData = mapToFirestore(enderecoComercial.toMap());

  // Add any Firestore field values
  enderecoComercial.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEnderecoComercialListFirestoreData(
  List<EnderecoComercialStruct>? enderecoComercials,
) =>
    enderecoComercials
        ?.map((e) => getEnderecoComercialFirestoreData(e, true))
        .toList() ??
    [];
