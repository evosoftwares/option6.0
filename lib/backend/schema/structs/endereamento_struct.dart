// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class EndereamentoStruct extends FFFirebaseStruct {
  EndereamentoStruct({
    String? corredor,
    String? setor,
    String? prateleira,
    String? nivel,
    String? geladeira,
    String? lado,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _corredor = corredor,
        _setor = setor,
        _prateleira = prateleira,
        _nivel = nivel,
        _geladeira = geladeira,
        _lado = lado,
        super(firestoreUtilData);

  // "corredor" field.
  String? _corredor;
  String get corredor => _corredor ?? '';
  set corredor(String? val) => _corredor = val;

  bool hasCorredor() => _corredor != null;

  // "setor" field.
  String? _setor;
  String get setor => _setor ?? '';
  set setor(String? val) => _setor = val;

  bool hasSetor() => _setor != null;

  // "prateleira" field.
  String? _prateleira;
  String get prateleira => _prateleira ?? '';
  set prateleira(String? val) => _prateleira = val;

  bool hasPrateleira() => _prateleira != null;

  // "nivel" field.
  String? _nivel;
  String get nivel => _nivel ?? '';
  set nivel(String? val) => _nivel = val;

  bool hasNivel() => _nivel != null;

  // "geladeira" field.
  String? _geladeira;
  String get geladeira => _geladeira ?? '';
  set geladeira(String? val) => _geladeira = val;

  bool hasGeladeira() => _geladeira != null;

  // "lado" field.
  String? _lado;
  String get lado => _lado ?? '';
  set lado(String? val) => _lado = val;

  bool hasLado() => _lado != null;

  static EndereamentoStruct fromMap(Map<String, dynamic> data) =>
      EndereamentoStruct(
        corredor: data['corredor'] as String?,
        setor: data['setor'] as String?,
        prateleira: data['prateleira'] as String?,
        nivel: data['nivel'] as String?,
        geladeira: data['geladeira'] as String?,
        lado: data['lado'] as String?,
      );

  static EndereamentoStruct? maybeFromMap(dynamic data) => data is Map
      ? EndereamentoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'corredor': _corredor,
        'setor': _setor,
        'prateleira': _prateleira,
        'nivel': _nivel,
        'geladeira': _geladeira,
        'lado': _lado,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'corredor': serializeParam(
          _corredor,
          ParamType.String,
        ),
        'setor': serializeParam(
          _setor,
          ParamType.String,
        ),
        'prateleira': serializeParam(
          _prateleira,
          ParamType.String,
        ),
        'nivel': serializeParam(
          _nivel,
          ParamType.String,
        ),
        'geladeira': serializeParam(
          _geladeira,
          ParamType.String,
        ),
        'lado': serializeParam(
          _lado,
          ParamType.String,
        ),
      }.withoutNulls;

  static EndereamentoStruct fromSerializableMap(Map<String, dynamic> data) =>
      EndereamentoStruct(
        corredor: deserializeParam(
          data['corredor'],
          ParamType.String,
          false,
        ),
        setor: deserializeParam(
          data['setor'],
          ParamType.String,
          false,
        ),
        prateleira: deserializeParam(
          data['prateleira'],
          ParamType.String,
          false,
        ),
        nivel: deserializeParam(
          data['nivel'],
          ParamType.String,
          false,
        ),
        geladeira: deserializeParam(
          data['geladeira'],
          ParamType.String,
          false,
        ),
        lado: deserializeParam(
          data['lado'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'EndereamentoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EndereamentoStruct &&
        corredor == other.corredor &&
        setor == other.setor &&
        prateleira == other.prateleira &&
        nivel == other.nivel &&
        geladeira == other.geladeira &&
        lado == other.lado;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([corredor, setor, prateleira, nivel, geladeira, lado]);
}

EndereamentoStruct createEndereamentoStruct({
  String? corredor,
  String? setor,
  String? prateleira,
  String? nivel,
  String? geladeira,
  String? lado,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EndereamentoStruct(
      corredor: corredor,
      setor: setor,
      prateleira: prateleira,
      nivel: nivel,
      geladeira: geladeira,
      lado: lado,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EndereamentoStruct? updateEndereamentoStruct(
  EndereamentoStruct? endereamento, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    endereamento
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEndereamentoStructData(
  Map<String, dynamic> firestoreData,
  EndereamentoStruct? endereamento,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (endereamento == null) {
    return;
  }
  if (endereamento.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && endereamento.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final endereamentoData =
      getEndereamentoFirestoreData(endereamento, forFieldValue);
  final nestedData =
      endereamentoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = endereamento.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEndereamentoFirestoreData(
  EndereamentoStruct? endereamento, [
  bool forFieldValue = false,
]) {
  if (endereamento == null) {
    return {};
  }
  final firestoreData = mapToFirestore(endereamento.toMap());

  // Add any Firestore field values
  endereamento.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEndereamentoListFirestoreData(
  List<EndereamentoStruct>? endereamentos,
) =>
    endereamentos?.map((e) => getEndereamentoFirestoreData(e, true)).toList() ??
    [];
