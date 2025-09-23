// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ResponsavelStruct extends FFFirebaseStruct {
  ResponsavelStruct({
    String? nome,
    String? email,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _email = email,
        super(firestoreUtilData);

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  static ResponsavelStruct fromMap(Map<String, dynamic> data) =>
      ResponsavelStruct(
        nome: data['nome'] as String?,
        email: data['email'] as String?,
      );

  static ResponsavelStruct? maybeFromMap(dynamic data) => data is Map
      ? ResponsavelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'email': _email,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
      }.withoutNulls;

  static ResponsavelStruct fromSerializableMap(Map<String, dynamic> data) =>
      ResponsavelStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ResponsavelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ResponsavelStruct &&
        nome == other.nome &&
        email == other.email;
  }

  @override
  int get hashCode => const ListEquality().hash([nome, email]);
}

ResponsavelStruct createResponsavelStruct({
  String? nome,
  String? email,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ResponsavelStruct(
      nome: nome,
      email: email,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ResponsavelStruct? updateResponsavelStruct(
  ResponsavelStruct? responsavel, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    responsavel
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addResponsavelStructData(
  Map<String, dynamic> firestoreData,
  ResponsavelStruct? responsavel,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (responsavel == null) {
    return;
  }
  if (responsavel.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && responsavel.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final responsavelData =
      getResponsavelFirestoreData(responsavel, forFieldValue);
  final nestedData =
      responsavelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = responsavel.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getResponsavelFirestoreData(
  ResponsavelStruct? responsavel, [
  bool forFieldValue = false,
]) {
  if (responsavel == null) {
    return {};
  }
  final firestoreData = mapToFirestore(responsavel.toMap());

  // Add any Firestore field values
  responsavel.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getResponsavelListFirestoreData(
  List<ResponsavelStruct>? responsavels,
) =>
    responsavels?.map((e) => getResponsavelFirestoreData(e, true)).toList() ??
    [];
