// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class EnderecoPessoalStruct extends FFFirebaseStruct {
  EnderecoPessoalStruct({
    String? cep,
    String? logradouro,
    String? cidade,
    String? estado,
    String? numero,
    String? complemento,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _cep = cep,
        _logradouro = logradouro,
        _cidade = cidade,
        _estado = estado,
        _numero = numero,
        _complemento = complemento,
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

  // "complemento" field.
  String? _complemento;
  String get complemento => _complemento ?? '';
  set complemento(String? val) => _complemento = val;

  bool hasComplemento() => _complemento != null;

  static EnderecoPessoalStruct fromMap(Map<String, dynamic> data) =>
      EnderecoPessoalStruct(
        cep: data['cep'] as String?,
        logradouro: data['logradouro'] as String?,
        cidade: data['cidade'] as String?,
        estado: data['estado'] as String?,
        numero: data['numero'] as String?,
        complemento: data['complemento'] as String?,
      );

  static EnderecoPessoalStruct? maybeFromMap(dynamic data) => data is Map
      ? EnderecoPessoalStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'cep': _cep,
        'logradouro': _logradouro,
        'cidade': _cidade,
        'estado': _estado,
        'numero': _numero,
        'complemento': _complemento,
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
        'complemento': serializeParam(
          _complemento,
          ParamType.String,
        ),
      }.withoutNulls;

  static EnderecoPessoalStruct fromSerializableMap(Map<String, dynamic> data) =>
      EnderecoPessoalStruct(
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
        complemento: deserializeParam(
          data['complemento'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'EnderecoPessoalStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EnderecoPessoalStruct &&
        cep == other.cep &&
        logradouro == other.logradouro &&
        cidade == other.cidade &&
        estado == other.estado &&
        numero == other.numero &&
        complemento == other.complemento;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([cep, logradouro, cidade, estado, numero, complemento]);
}

EnderecoPessoalStruct createEnderecoPessoalStruct({
  String? cep,
  String? logradouro,
  String? cidade,
  String? estado,
  String? numero,
  String? complemento,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EnderecoPessoalStruct(
      cep: cep,
      logradouro: logradouro,
      cidade: cidade,
      estado: estado,
      numero: numero,
      complemento: complemento,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EnderecoPessoalStruct? updateEnderecoPessoalStruct(
  EnderecoPessoalStruct? enderecoPessoal, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    enderecoPessoal
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEnderecoPessoalStructData(
  Map<String, dynamic> firestoreData,
  EnderecoPessoalStruct? enderecoPessoal,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (enderecoPessoal == null) {
    return;
  }
  if (enderecoPessoal.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && enderecoPessoal.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final enderecoPessoalData =
      getEnderecoPessoalFirestoreData(enderecoPessoal, forFieldValue);
  final nestedData =
      enderecoPessoalData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = enderecoPessoal.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEnderecoPessoalFirestoreData(
  EnderecoPessoalStruct? enderecoPessoal, [
  bool forFieldValue = false,
]) {
  if (enderecoPessoal == null) {
    return {};
  }
  final firestoreData = mapToFirestore(enderecoPessoal.toMap());

  // Add any Firestore field values
  enderecoPessoal.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEnderecoPessoalListFirestoreData(
  List<EnderecoPessoalStruct>? enderecoPessoals,
) =>
    enderecoPessoals
        ?.map((e) => getEnderecoPessoalFirestoreData(e, true))
        .toList() ??
    [];
