// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AreaAtuacaoStruct extends FFFirebaseStruct {
  AreaAtuacaoStruct({
    String? areaAtuacaoEndereco,
    LatLng? areaAtuacaoLatLnt,
    String? areaAtuacaoCidade,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _areaAtuacaoEndereco = areaAtuacaoEndereco,
        _areaAtuacaoLatLnt = areaAtuacaoLatLnt,
        _areaAtuacaoCidade = areaAtuacaoCidade,
        super(firestoreUtilData);

  // "areaAtuacao_Endereco" field.
  String? _areaAtuacaoEndereco;
  String get areaAtuacaoEndereco => _areaAtuacaoEndereco ?? '';
  set areaAtuacaoEndereco(String? val) => _areaAtuacaoEndereco = val;

  bool hasAreaAtuacaoEndereco() => _areaAtuacaoEndereco != null;

  // "areaAtuacao_LatLnt" field.
  LatLng? _areaAtuacaoLatLnt;
  LatLng? get areaAtuacaoLatLnt => _areaAtuacaoLatLnt;
  set areaAtuacaoLatLnt(LatLng? val) => _areaAtuacaoLatLnt = val;

  bool hasAreaAtuacaoLatLnt() => _areaAtuacaoLatLnt != null;

  // "areaAtuacao_Cidade" field.
  String? _areaAtuacaoCidade;
  String get areaAtuacaoCidade => _areaAtuacaoCidade ?? '';
  set areaAtuacaoCidade(String? val) => _areaAtuacaoCidade = val;

  bool hasAreaAtuacaoCidade() => _areaAtuacaoCidade != null;

  static AreaAtuacaoStruct fromMap(Map<String, dynamic> data) =>
      AreaAtuacaoStruct(
        areaAtuacaoEndereco: data['areaAtuacao_Endereco'] as String?,
        areaAtuacaoLatLnt: data['areaAtuacao_LatLnt'] as LatLng?,
        areaAtuacaoCidade: data['areaAtuacao_Cidade'] as String?,
      );

  static AreaAtuacaoStruct? maybeFromMap(dynamic data) => data is Map
      ? AreaAtuacaoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'areaAtuacao_Endereco': _areaAtuacaoEndereco,
        'areaAtuacao_LatLnt': _areaAtuacaoLatLnt,
        'areaAtuacao_Cidade': _areaAtuacaoCidade,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'areaAtuacao_Endereco': serializeParam(
          _areaAtuacaoEndereco,
          ParamType.String,
        ),
        'areaAtuacao_LatLnt': serializeParam(
          _areaAtuacaoLatLnt,
          ParamType.LatLng,
        ),
        'areaAtuacao_Cidade': serializeParam(
          _areaAtuacaoCidade,
          ParamType.String,
        ),
      }.withoutNulls;

  static AreaAtuacaoStruct fromSerializableMap(Map<String, dynamic> data) =>
      AreaAtuacaoStruct(
        areaAtuacaoEndereco: deserializeParam(
          data['areaAtuacao_Endereco'],
          ParamType.String,
          false,
        ),
        areaAtuacaoLatLnt: deserializeParam(
          data['areaAtuacao_LatLnt'],
          ParamType.LatLng,
          false,
        ),
        areaAtuacaoCidade: deserializeParam(
          data['areaAtuacao_Cidade'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AreaAtuacaoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AreaAtuacaoStruct &&
        areaAtuacaoEndereco == other.areaAtuacaoEndereco &&
        areaAtuacaoLatLnt == other.areaAtuacaoLatLnt &&
        areaAtuacaoCidade == other.areaAtuacaoCidade;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([areaAtuacaoEndereco, areaAtuacaoLatLnt, areaAtuacaoCidade]);
}

AreaAtuacaoStruct createAreaAtuacaoStruct({
  String? areaAtuacaoEndereco,
  LatLng? areaAtuacaoLatLnt,
  String? areaAtuacaoCidade,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AreaAtuacaoStruct(
      areaAtuacaoEndereco: areaAtuacaoEndereco,
      areaAtuacaoLatLnt: areaAtuacaoLatLnt,
      areaAtuacaoCidade: areaAtuacaoCidade,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AreaAtuacaoStruct? updateAreaAtuacaoStruct(
  AreaAtuacaoStruct? areaAtuacao, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    areaAtuacao
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAreaAtuacaoStructData(
  Map<String, dynamic> firestoreData,
  AreaAtuacaoStruct? areaAtuacao,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (areaAtuacao == null) {
    return;
  }
  if (areaAtuacao.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && areaAtuacao.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final areaAtuacaoData =
      getAreaAtuacaoFirestoreData(areaAtuacao, forFieldValue);
  final nestedData =
      areaAtuacaoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = areaAtuacao.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAreaAtuacaoFirestoreData(
  AreaAtuacaoStruct? areaAtuacao, [
  bool forFieldValue = false,
]) {
  if (areaAtuacao == null) {
    return {};
  }
  final firestoreData = mapToFirestore(areaAtuacao.toMap());

  // Add any Firestore field values
  areaAtuacao.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAreaAtuacaoListFirestoreData(
  List<AreaAtuacaoStruct>? areaAtuacaos,
) =>
    areaAtuacaos?.map((e) => getAreaAtuacaoFirestoreData(e, true)).toList() ??
    [];
