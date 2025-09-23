// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class MetricasMotoristaStruct extends FFFirebaseStruct {
  MetricasMotoristaStruct({
    int? totalCorridas,
    double? avaliacaoMedia,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _totalCorridas = totalCorridas,
        _avaliacaoMedia = avaliacaoMedia,
        super(firestoreUtilData);

  // "totalCorridas" field.
  int? _totalCorridas;
  int get totalCorridas => _totalCorridas ?? 0;
  set totalCorridas(int? val) => _totalCorridas = val;

  void incrementTotalCorridas(int amount) =>
      totalCorridas = totalCorridas + amount;

  bool hasTotalCorridas() => _totalCorridas != null;

  // "avaliacaoMedia" field.
  double? _avaliacaoMedia;
  double get avaliacaoMedia => _avaliacaoMedia ?? 0.0;
  set avaliacaoMedia(double? val) => _avaliacaoMedia = val;

  void incrementAvaliacaoMedia(double amount) =>
      avaliacaoMedia = avaliacaoMedia + amount;

  bool hasAvaliacaoMedia() => _avaliacaoMedia != null;

  static MetricasMotoristaStruct fromMap(Map<String, dynamic> data) =>
      MetricasMotoristaStruct(
        totalCorridas: castToType<int>(data['totalCorridas']),
        avaliacaoMedia: castToType<double>(data['avaliacaoMedia']),
      );

  static MetricasMotoristaStruct? maybeFromMap(dynamic data) => data is Map
      ? MetricasMotoristaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'totalCorridas': _totalCorridas,
        'avaliacaoMedia': _avaliacaoMedia,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'totalCorridas': serializeParam(
          _totalCorridas,
          ParamType.int,
        ),
        'avaliacaoMedia': serializeParam(
          _avaliacaoMedia,
          ParamType.double,
        ),
      }.withoutNulls;

  static MetricasMotoristaStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      MetricasMotoristaStruct(
        totalCorridas: deserializeParam(
          data['totalCorridas'],
          ParamType.int,
          false,
        ),
        avaliacaoMedia: deserializeParam(
          data['avaliacaoMedia'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'MetricasMotoristaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MetricasMotoristaStruct &&
        totalCorridas == other.totalCorridas &&
        avaliacaoMedia == other.avaliacaoMedia;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([totalCorridas, avaliacaoMedia]);
}

MetricasMotoristaStruct createMetricasMotoristaStruct({
  int? totalCorridas,
  double? avaliacaoMedia,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MetricasMotoristaStruct(
      totalCorridas: totalCorridas,
      avaliacaoMedia: avaliacaoMedia,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MetricasMotoristaStruct? updateMetricasMotoristaStruct(
  MetricasMotoristaStruct? metricasMotorista, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    metricasMotorista
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMetricasMotoristaStructData(
  Map<String, dynamic> firestoreData,
  MetricasMotoristaStruct? metricasMotorista,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (metricasMotorista == null) {
    return;
  }
  if (metricasMotorista.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && metricasMotorista.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final metricasMotoristaData =
      getMetricasMotoristaFirestoreData(metricasMotorista, forFieldValue);
  final nestedData =
      metricasMotoristaData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = metricasMotorista.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMetricasMotoristaFirestoreData(
  MetricasMotoristaStruct? metricasMotorista, [
  bool forFieldValue = false,
]) {
  if (metricasMotorista == null) {
    return {};
  }
  final firestoreData = mapToFirestore(metricasMotorista.toMap());

  // Add any Firestore field values
  metricasMotorista.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMetricasMotoristaListFirestoreData(
  List<MetricasMotoristaStruct>? metricasMotoristas,
) =>
    metricasMotoristas
        ?.map((e) => getMetricasMotoristaFirestoreData(e, true))
        .toList() ??
    [];
