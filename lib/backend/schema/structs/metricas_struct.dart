// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class MetricasStruct extends FFFirebaseStruct {
  MetricasStruct({
    int? servicosConcluidos,
    double? taxaResposta,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _servicosConcluidos = servicosConcluidos,
        _taxaResposta = taxaResposta,
        super(firestoreUtilData);

  // "servicosConcluidos" field.
  int? _servicosConcluidos;
  int get servicosConcluidos => _servicosConcluidos ?? 0;
  set servicosConcluidos(int? val) => _servicosConcluidos = val;

  void incrementServicosConcluidos(int amount) =>
      servicosConcluidos = servicosConcluidos + amount;

  bool hasServicosConcluidos() => _servicosConcluidos != null;

  // "taxaResposta" field.
  double? _taxaResposta;
  double get taxaResposta => _taxaResposta ?? 0.0;
  set taxaResposta(double? val) => _taxaResposta = val;

  void incrementTaxaResposta(double amount) =>
      taxaResposta = taxaResposta + amount;

  bool hasTaxaResposta() => _taxaResposta != null;

  static MetricasStruct fromMap(Map<String, dynamic> data) => MetricasStruct(
        servicosConcluidos: castToType<int>(data['servicosConcluidos']),
        taxaResposta: castToType<double>(data['taxaResposta']),
      );

  static MetricasStruct? maybeFromMap(dynamic data) =>
      data is Map ? MetricasStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'servicosConcluidos': _servicosConcluidos,
        'taxaResposta': _taxaResposta,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'servicosConcluidos': serializeParam(
          _servicosConcluidos,
          ParamType.int,
        ),
        'taxaResposta': serializeParam(
          _taxaResposta,
          ParamType.double,
        ),
      }.withoutNulls;

  static MetricasStruct fromSerializableMap(Map<String, dynamic> data) =>
      MetricasStruct(
        servicosConcluidos: deserializeParam(
          data['servicosConcluidos'],
          ParamType.int,
          false,
        ),
        taxaResposta: deserializeParam(
          data['taxaResposta'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'MetricasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MetricasStruct &&
        servicosConcluidos == other.servicosConcluidos &&
        taxaResposta == other.taxaResposta;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([servicosConcluidos, taxaResposta]);
}

MetricasStruct createMetricasStruct({
  int? servicosConcluidos,
  double? taxaResposta,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MetricasStruct(
      servicosConcluidos: servicosConcluidos,
      taxaResposta: taxaResposta,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MetricasStruct? updateMetricasStruct(
  MetricasStruct? metricas, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    metricas
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMetricasStructData(
  Map<String, dynamic> firestoreData,
  MetricasStruct? metricas,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (metricas == null) {
    return;
  }
  if (metricas.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && metricas.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final metricasData = getMetricasFirestoreData(metricas, forFieldValue);
  final nestedData = metricasData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = metricas.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMetricasFirestoreData(
  MetricasStruct? metricas, [
  bool forFieldValue = false,
]) {
  if (metricas == null) {
    return {};
  }
  final firestoreData = mapToFirestore(metricas.toMap());

  // Add any Firestore field values
  metricas.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMetricasListFirestoreData(
  List<MetricasStruct>? metricass,
) =>
    metricass?.map((e) => getMetricasFirestoreData(e, true)).toList() ?? [];
