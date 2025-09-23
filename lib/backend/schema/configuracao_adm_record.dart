import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConfiguracaoAdmRecord extends FirestoreRecord {
  ConfiguracaoAdmRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "valorPorKm" field.
  double? _valorPorKm;
  double get valorPorKm => _valorPorKm ?? 0.0;
  bool hasValorPorKm() => _valorPorKm != null;

  // "valorMinimoCorrida" field.
  double? _valorMinimoCorrida;
  double get valorMinimoCorrida => _valorMinimoCorrida ?? 0.0;
  bool hasValorMinimoCorrida() => _valorMinimoCorrida != null;

  // "margemLucroApp" field.
  double? _margemLucroApp;
  double get margemLucroApp => _margemLucroApp ?? 0.0;
  bool hasMargemLucroApp() => _margemLucroApp != null;

  void _initializeFields() {
    _valorPorKm = castToType<double>(snapshotData['valorPorKm']);
    _valorMinimoCorrida =
        castToType<double>(snapshotData['valorMinimoCorrida']);
    _margemLucroApp = castToType<double>(snapshotData['margemLucroApp']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('configuracaoAdm');

  static Stream<ConfiguracaoAdmRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ConfiguracaoAdmRecord.fromSnapshot(s));

  static Future<ConfiguracaoAdmRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ConfiguracaoAdmRecord.fromSnapshot(s));

  static ConfiguracaoAdmRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ConfiguracaoAdmRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ConfiguracaoAdmRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ConfiguracaoAdmRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ConfiguracaoAdmRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ConfiguracaoAdmRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createConfiguracaoAdmRecordData({
  double? valorPorKm,
  double? valorMinimoCorrida,
  double? margemLucroApp,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'valorPorKm': valorPorKm,
      'valorMinimoCorrida': valorMinimoCorrida,
      'margemLucroApp': margemLucroApp,
    }.withoutNulls,
  );

  return firestoreData;
}

class ConfiguracaoAdmRecordDocumentEquality
    implements Equality<ConfiguracaoAdmRecord> {
  const ConfiguracaoAdmRecordDocumentEquality();

  @override
  bool equals(ConfiguracaoAdmRecord? e1, ConfiguracaoAdmRecord? e2) {
    return e1?.valorPorKm == e2?.valorPorKm &&
        e1?.valorMinimoCorrida == e2?.valorMinimoCorrida &&
        e1?.margemLucroApp == e2?.margemLucroApp;
  }

  @override
  int hash(ConfiguracaoAdmRecord? e) => const ListEquality()
      .hash([e?.valorPorKm, e?.valorMinimoCorrida, e?.margemLucroApp]);

  @override
  bool isValidKey(Object? o) => o is ConfiguracaoAdmRecord;
}
