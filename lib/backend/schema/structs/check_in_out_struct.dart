// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class CheckInOutStruct extends FFFirebaseStruct {
  CheckInOutStruct({
    DateTime? hora,
    LatLng? localizacao,
    String? foto,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _hora = hora,
        _localizacao = localizacao,
        _foto = foto,
        super(firestoreUtilData);

  // "hora" field.
  DateTime? _hora;
  DateTime? get hora => _hora;
  set hora(DateTime? val) => _hora = val;

  bool hasHora() => _hora != null;

  // "localizacao" field.
  LatLng? _localizacao;
  LatLng? get localizacao => _localizacao;
  set localizacao(LatLng? val) => _localizacao = val;

  bool hasLocalizacao() => _localizacao != null;

  // "foto" field.
  String? _foto;
  String get foto => _foto ?? '';
  set foto(String? val) => _foto = val;

  bool hasFoto() => _foto != null;

  static CheckInOutStruct fromMap(Map<String, dynamic> data) =>
      CheckInOutStruct(
        hora: data['hora'] as DateTime?,
        localizacao: data['localizacao'] as LatLng?,
        foto: data['foto'] as String?,
      );

  static CheckInOutStruct? maybeFromMap(dynamic data) => data is Map
      ? CheckInOutStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'hora': _hora,
        'localizacao': _localizacao,
        'foto': _foto,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'hora': serializeParam(
          _hora,
          ParamType.DateTime,
        ),
        'localizacao': serializeParam(
          _localizacao,
          ParamType.LatLng,
        ),
        'foto': serializeParam(
          _foto,
          ParamType.String,
        ),
      }.withoutNulls;

  static CheckInOutStruct fromSerializableMap(Map<String, dynamic> data) =>
      CheckInOutStruct(
        hora: deserializeParam(
          data['hora'],
          ParamType.DateTime,
          false,
        ),
        localizacao: deserializeParam(
          data['localizacao'],
          ParamType.LatLng,
          false,
        ),
        foto: deserializeParam(
          data['foto'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CheckInOutStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CheckInOutStruct &&
        hora == other.hora &&
        localizacao == other.localizacao &&
        foto == other.foto;
  }

  @override
  int get hashCode => const ListEquality().hash([hora, localizacao, foto]);
}

CheckInOutStruct createCheckInOutStruct({
  DateTime? hora,
  LatLng? localizacao,
  String? foto,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CheckInOutStruct(
      hora: hora,
      localizacao: localizacao,
      foto: foto,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CheckInOutStruct? updateCheckInOutStruct(
  CheckInOutStruct? checkInOut, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    checkInOut
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCheckInOutStructData(
  Map<String, dynamic> firestoreData,
  CheckInOutStruct? checkInOut,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (checkInOut == null) {
    return;
  }
  if (checkInOut.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && checkInOut.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final checkInOutData = getCheckInOutFirestoreData(checkInOut, forFieldValue);
  final nestedData = checkInOutData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = checkInOut.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCheckInOutFirestoreData(
  CheckInOutStruct? checkInOut, [
  bool forFieldValue = false,
]) {
  if (checkInOut == null) {
    return {};
  }
  final firestoreData = mapToFirestore(checkInOut.toMap());

  // Add any Firestore field values
  checkInOut.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCheckInOutListFirestoreData(
  List<CheckInOutStruct>? checkInOuts,
) =>
    checkInOuts?.map((e) => getCheckInOutFirestoreData(e, true)).toList() ?? [];
