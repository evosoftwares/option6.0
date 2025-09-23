import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BotWhatsappRecord extends FirestoreRecord {
  BotWhatsappRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idWhatsapp" field.
  int? _idWhatsapp;
  int get idWhatsapp => _idWhatsapp ?? 0;
  bool hasIdWhatsapp() => _idWhatsapp != null;

  // "Indicador" field.
  String? _indicador;
  String get indicador => _indicador ?? '';
  bool hasIndicador() => _indicador != null;

  // "Indicado" field.
  String? _indicado;
  String get indicado => _indicado ?? '';
  bool hasIndicado() => _indicado != null;

  void _initializeFields() {
    _idWhatsapp = castToType<int>(snapshotData['idWhatsapp']);
    _indicador = snapshotData['Indicador'] as String?;
    _indicado = snapshotData['Indicado'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('botWhatsapp');

  static Stream<BotWhatsappRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BotWhatsappRecord.fromSnapshot(s));

  static Future<BotWhatsappRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BotWhatsappRecord.fromSnapshot(s));

  static BotWhatsappRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BotWhatsappRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BotWhatsappRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BotWhatsappRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BotWhatsappRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BotWhatsappRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBotWhatsappRecordData({
  int? idWhatsapp,
  String? indicador,
  String? indicado,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idWhatsapp': idWhatsapp,
      'Indicador': indicador,
      'Indicado': indicado,
    }.withoutNulls,
  );

  return firestoreData;
}

class BotWhatsappRecordDocumentEquality implements Equality<BotWhatsappRecord> {
  const BotWhatsappRecordDocumentEquality();

  @override
  bool equals(BotWhatsappRecord? e1, BotWhatsappRecord? e2) {
    return e1?.idWhatsapp == e2?.idWhatsapp &&
        e1?.indicador == e2?.indicador &&
        e1?.indicado == e2?.indicado;
  }

  @override
  int hash(BotWhatsappRecord? e) =>
      const ListEquality().hash([e?.idWhatsapp, e?.indicador, e?.indicado]);

  @override
  bool isValidKey(Object? o) => o is BotWhatsappRecord;
}
