// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ChecklistItemStructStruct extends FFFirebaseStruct {
  ChecklistItemStructStruct({
    String? textoItem,
    bool? concluido,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _textoItem = textoItem,
        _concluido = concluido,
        super(firestoreUtilData);

  // "texto_item" field.
  String? _textoItem;
  String get textoItem => _textoItem ?? '';
  set textoItem(String? val) => _textoItem = val;

  bool hasTextoItem() => _textoItem != null;

  // "concluido" field.
  bool? _concluido;
  bool get concluido => _concluido ?? false;
  set concluido(bool? val) => _concluido = val;

  bool hasConcluido() => _concluido != null;

  static ChecklistItemStructStruct fromMap(Map<String, dynamic> data) =>
      ChecklistItemStructStruct(
        textoItem: data['texto_item'] as String?,
        concluido: data['concluido'] as bool?,
      );

  static ChecklistItemStructStruct? maybeFromMap(dynamic data) => data is Map
      ? ChecklistItemStructStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'texto_item': _textoItem,
        'concluido': _concluido,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'texto_item': serializeParam(
          _textoItem,
          ParamType.String,
        ),
        'concluido': serializeParam(
          _concluido,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ChecklistItemStructStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ChecklistItemStructStruct(
        textoItem: deserializeParam(
          data['texto_item'],
          ParamType.String,
          false,
        ),
        concluido: deserializeParam(
          data['concluido'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ChecklistItemStructStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ChecklistItemStructStruct &&
        textoItem == other.textoItem &&
        concluido == other.concluido;
  }

  @override
  int get hashCode => const ListEquality().hash([textoItem, concluido]);
}

ChecklistItemStructStruct createChecklistItemStructStruct({
  String? textoItem,
  bool? concluido,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ChecklistItemStructStruct(
      textoItem: textoItem,
      concluido: concluido,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ChecklistItemStructStruct? updateChecklistItemStructStruct(
  ChecklistItemStructStruct? checklistItemStruct, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    checklistItemStruct
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addChecklistItemStructStructData(
  Map<String, dynamic> firestoreData,
  ChecklistItemStructStruct? checklistItemStruct,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (checklistItemStruct == null) {
    return;
  }
  if (checklistItemStruct.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && checklistItemStruct.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final checklistItemStructData =
      getChecklistItemStructFirestoreData(checklistItemStruct, forFieldValue);
  final nestedData =
      checklistItemStructData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      checklistItemStruct.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getChecklistItemStructFirestoreData(
  ChecklistItemStructStruct? checklistItemStruct, [
  bool forFieldValue = false,
]) {
  if (checklistItemStruct == null) {
    return {};
  }
  final firestoreData = mapToFirestore(checklistItemStruct.toMap());

  // Add any Firestore field values
  checklistItemStruct.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getChecklistItemStructListFirestoreData(
  List<ChecklistItemStructStruct>? checklistItemStructs,
) =>
    checklistItemStructs
        ?.map((e) => getChecklistItemStructFirestoreData(e, true))
        .toList() ??
    [];
