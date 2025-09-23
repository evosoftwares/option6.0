// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ReputacaoStruct extends FFFirebaseStruct {
  ReputacaoStruct({
    double? notaMedia,
    int? totalAvaliacoes,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _notaMedia = notaMedia,
        _totalAvaliacoes = totalAvaliacoes,
        super(firestoreUtilData);

  // "notaMedia" field.
  double? _notaMedia;
  double get notaMedia => _notaMedia ?? 0.0;
  set notaMedia(double? val) => _notaMedia = val;

  void incrementNotaMedia(double amount) => notaMedia = notaMedia + amount;

  bool hasNotaMedia() => _notaMedia != null;

  // "totalAvaliacoes" field.
  int? _totalAvaliacoes;
  int get totalAvaliacoes => _totalAvaliacoes ?? 0;
  set totalAvaliacoes(int? val) => _totalAvaliacoes = val;

  void incrementTotalAvaliacoes(int amount) =>
      totalAvaliacoes = totalAvaliacoes + amount;

  bool hasTotalAvaliacoes() => _totalAvaliacoes != null;

  static ReputacaoStruct fromMap(Map<String, dynamic> data) => ReputacaoStruct(
        notaMedia: castToType<double>(data['notaMedia']),
        totalAvaliacoes: castToType<int>(data['totalAvaliacoes']),
      );

  static ReputacaoStruct? maybeFromMap(dynamic data) => data is Map
      ? ReputacaoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'notaMedia': _notaMedia,
        'totalAvaliacoes': _totalAvaliacoes,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'notaMedia': serializeParam(
          _notaMedia,
          ParamType.double,
        ),
        'totalAvaliacoes': serializeParam(
          _totalAvaliacoes,
          ParamType.int,
        ),
      }.withoutNulls;

  static ReputacaoStruct fromSerializableMap(Map<String, dynamic> data) =>
      ReputacaoStruct(
        notaMedia: deserializeParam(
          data['notaMedia'],
          ParamType.double,
          false,
        ),
        totalAvaliacoes: deserializeParam(
          data['totalAvaliacoes'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'ReputacaoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ReputacaoStruct &&
        notaMedia == other.notaMedia &&
        totalAvaliacoes == other.totalAvaliacoes;
  }

  @override
  int get hashCode => const ListEquality().hash([notaMedia, totalAvaliacoes]);
}

ReputacaoStruct createReputacaoStruct({
  double? notaMedia,
  int? totalAvaliacoes,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ReputacaoStruct(
      notaMedia: notaMedia,
      totalAvaliacoes: totalAvaliacoes,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ReputacaoStruct? updateReputacaoStruct(
  ReputacaoStruct? reputacao, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    reputacao
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addReputacaoStructData(
  Map<String, dynamic> firestoreData,
  ReputacaoStruct? reputacao,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (reputacao == null) {
    return;
  }
  if (reputacao.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && reputacao.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final reputacaoData = getReputacaoFirestoreData(reputacao, forFieldValue);
  final nestedData = reputacaoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = reputacao.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getReputacaoFirestoreData(
  ReputacaoStruct? reputacao, [
  bool forFieldValue = false,
]) {
  if (reputacao == null) {
    return {};
  }
  final firestoreData = mapToFirestore(reputacao.toMap());

  // Add any Firestore field values
  reputacao.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getReputacaoListFirestoreData(
  List<ReputacaoStruct>? reputacaos,
) =>
    reputacaos?.map((e) => getReputacaoFirestoreData(e, true)).toList() ?? [];
