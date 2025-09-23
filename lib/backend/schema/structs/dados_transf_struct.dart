// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class DadosTransfStruct extends FFFirebaseStruct {
  DadosTransfStruct({
    String? chavePix,
    String? tipoChave,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _chavePix = chavePix,
        _tipoChave = tipoChave,
        super(firestoreUtilData);

  // "chavePix" field.
  String? _chavePix;
  String get chavePix => _chavePix ?? '';
  set chavePix(String? val) => _chavePix = val;

  bool hasChavePix() => _chavePix != null;

  // "tipoChave" field.
  String? _tipoChave;
  String get tipoChave => _tipoChave ?? '';
  set tipoChave(String? val) => _tipoChave = val;

  bool hasTipoChave() => _tipoChave != null;

  static DadosTransfStruct fromMap(Map<String, dynamic> data) =>
      DadosTransfStruct(
        chavePix: data['chavePix'] as String?,
        tipoChave: data['tipoChave'] as String?,
      );

  static DadosTransfStruct? maybeFromMap(dynamic data) => data is Map
      ? DadosTransfStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'chavePix': _chavePix,
        'tipoChave': _tipoChave,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'chavePix': serializeParam(
          _chavePix,
          ParamType.String,
        ),
        'tipoChave': serializeParam(
          _tipoChave,
          ParamType.String,
        ),
      }.withoutNulls;

  static DadosTransfStruct fromSerializableMap(Map<String, dynamic> data) =>
      DadosTransfStruct(
        chavePix: deserializeParam(
          data['chavePix'],
          ParamType.String,
          false,
        ),
        tipoChave: deserializeParam(
          data['tipoChave'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DadosTransfStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DadosTransfStruct &&
        chavePix == other.chavePix &&
        tipoChave == other.tipoChave;
  }

  @override
  int get hashCode => const ListEquality().hash([chavePix, tipoChave]);
}

DadosTransfStruct createDadosTransfStruct({
  String? chavePix,
  String? tipoChave,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DadosTransfStruct(
      chavePix: chavePix,
      tipoChave: tipoChave,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DadosTransfStruct? updateDadosTransfStruct(
  DadosTransfStruct? dadosTransf, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dadosTransf
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDadosTransfStructData(
  Map<String, dynamic> firestoreData,
  DadosTransfStruct? dadosTransf,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dadosTransf == null) {
    return;
  }
  if (dadosTransf.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && dadosTransf.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dadosTransfData =
      getDadosTransfFirestoreData(dadosTransf, forFieldValue);
  final nestedData =
      dadosTransfData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = dadosTransf.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDadosTransfFirestoreData(
  DadosTransfStruct? dadosTransf, [
  bool forFieldValue = false,
]) {
  if (dadosTransf == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dadosTransf.toMap());

  // Add any Firestore field values
  dadosTransf.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDadosTransfListFirestoreData(
  List<DadosTransfStruct>? dadosTransfs,
) =>
    dadosTransfs?.map((e) => getDadosTransfFirestoreData(e, true)).toList() ??
    [];
