// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GamificacaoStruct extends FFFirebaseStruct {
  GamificacaoStruct({
    Nivel? nivel,
    int? pontosXP,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nivel = nivel,
        _pontosXP = pontosXP,
        super(firestoreUtilData);

  // "nivel" field.
  Nivel? _nivel;
  Nivel get nivel => _nivel ?? Nivel.Bronze;
  set nivel(Nivel? val) => _nivel = val;

  bool hasNivel() => _nivel != null;

  // "pontosXP" field.
  int? _pontosXP;
  int get pontosXP => _pontosXP ?? 0;
  set pontosXP(int? val) => _pontosXP = val;

  void incrementPontosXP(int amount) => pontosXP = pontosXP + amount;

  bool hasPontosXP() => _pontosXP != null;

  static GamificacaoStruct fromMap(Map<String, dynamic> data) =>
      GamificacaoStruct(
        nivel: data['nivel'] is Nivel
            ? data['nivel']
            : deserializeEnum<Nivel>(data['nivel']),
        pontosXP: castToType<int>(data['pontosXP']),
      );

  static GamificacaoStruct? maybeFromMap(dynamic data) => data is Map
      ? GamificacaoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nivel': _nivel?.serialize(),
        'pontosXP': _pontosXP,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nivel': serializeParam(
          _nivel,
          ParamType.Enum,
        ),
        'pontosXP': serializeParam(
          _pontosXP,
          ParamType.int,
        ),
      }.withoutNulls;

  static GamificacaoStruct fromSerializableMap(Map<String, dynamic> data) =>
      GamificacaoStruct(
        nivel: deserializeParam<Nivel>(
          data['nivel'],
          ParamType.Enum,
          false,
        ),
        pontosXP: deserializeParam(
          data['pontosXP'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'GamificacaoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GamificacaoStruct &&
        nivel == other.nivel &&
        pontosXP == other.pontosXP;
  }

  @override
  int get hashCode => const ListEquality().hash([nivel, pontosXP]);
}

GamificacaoStruct createGamificacaoStruct({
  Nivel? nivel,
  int? pontosXP,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    GamificacaoStruct(
      nivel: nivel,
      pontosXP: pontosXP,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

GamificacaoStruct? updateGamificacaoStruct(
  GamificacaoStruct? gamificacao, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    gamificacao
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addGamificacaoStructData(
  Map<String, dynamic> firestoreData,
  GamificacaoStruct? gamificacao,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (gamificacao == null) {
    return;
  }
  if (gamificacao.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && gamificacao.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final gamificacaoData =
      getGamificacaoFirestoreData(gamificacao, forFieldValue);
  final nestedData =
      gamificacaoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = gamificacao.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getGamificacaoFirestoreData(
  GamificacaoStruct? gamificacao, [
  bool forFieldValue = false,
]) {
  if (gamificacao == null) {
    return {};
  }
  final firestoreData = mapToFirestore(gamificacao.toMap());

  // Add any Firestore field values
  gamificacao.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getGamificacaoListFirestoreData(
  List<GamificacaoStruct>? gamificacaos,
) =>
    gamificacaos?.map((e) => getGamificacaoFirestoreData(e, true)).toList() ??
    [];
