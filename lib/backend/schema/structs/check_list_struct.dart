// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class CheckListStruct extends FFFirebaseStruct {
  CheckListStruct({
    int? total,
    int? totalFeito,
    double? porcentagemFeita,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _total = total,
        _totalFeito = totalFeito,
        _porcentagemFeita = porcentagemFeita,
        super(firestoreUtilData);

  // "total" field.
  int? _total;
  int get total => _total ?? 0;
  set total(int? val) => _total = val;

  void incrementTotal(int amount) => total = total + amount;

  bool hasTotal() => _total != null;

  // "totalFeito" field.
  int? _totalFeito;
  int get totalFeito => _totalFeito ?? 0;
  set totalFeito(int? val) => _totalFeito = val;

  void incrementTotalFeito(int amount) => totalFeito = totalFeito + amount;

  bool hasTotalFeito() => _totalFeito != null;

  // "porcentagemFeita" field.
  double? _porcentagemFeita;
  double get porcentagemFeita => _porcentagemFeita ?? 0.0;
  set porcentagemFeita(double? val) => _porcentagemFeita = val;

  void incrementPorcentagemFeita(double amount) =>
      porcentagemFeita = porcentagemFeita + amount;

  bool hasPorcentagemFeita() => _porcentagemFeita != null;

  static CheckListStruct fromMap(Map<String, dynamic> data) => CheckListStruct(
        total: castToType<int>(data['total']),
        totalFeito: castToType<int>(data['totalFeito']),
        porcentagemFeita: castToType<double>(data['porcentagemFeita']),
      );

  static CheckListStruct? maybeFromMap(dynamic data) => data is Map
      ? CheckListStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'total': _total,
        'totalFeito': _totalFeito,
        'porcentagemFeita': _porcentagemFeita,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'total': serializeParam(
          _total,
          ParamType.int,
        ),
        'totalFeito': serializeParam(
          _totalFeito,
          ParamType.int,
        ),
        'porcentagemFeita': serializeParam(
          _porcentagemFeita,
          ParamType.double,
        ),
      }.withoutNulls;

  static CheckListStruct fromSerializableMap(Map<String, dynamic> data) =>
      CheckListStruct(
        total: deserializeParam(
          data['total'],
          ParamType.int,
          false,
        ),
        totalFeito: deserializeParam(
          data['totalFeito'],
          ParamType.int,
          false,
        ),
        porcentagemFeita: deserializeParam(
          data['porcentagemFeita'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'CheckListStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CheckListStruct &&
        total == other.total &&
        totalFeito == other.totalFeito &&
        porcentagemFeita == other.porcentagemFeita;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([total, totalFeito, porcentagemFeita]);
}

CheckListStruct createCheckListStruct({
  int? total,
  int? totalFeito,
  double? porcentagemFeita,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CheckListStruct(
      total: total,
      totalFeito: totalFeito,
      porcentagemFeita: porcentagemFeita,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CheckListStruct? updateCheckListStruct(
  CheckListStruct? checkList, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    checkList
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCheckListStructData(
  Map<String, dynamic> firestoreData,
  CheckListStruct? checkList,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (checkList == null) {
    return;
  }
  if (checkList.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && checkList.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final checkListData = getCheckListFirestoreData(checkList, forFieldValue);
  final nestedData = checkListData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = checkList.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCheckListFirestoreData(
  CheckListStruct? checkList, [
  bool forFieldValue = false,
]) {
  if (checkList == null) {
    return {};
  }
  final firestoreData = mapToFirestore(checkList.toMap());

  // Add any Firestore field values
  checkList.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCheckListListFirestoreData(
  List<CheckListStruct>? checkLists,
) =>
    checkLists?.map((e) => getCheckListFirestoreData(e, true)).toList() ?? [];
