import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SaquesRecord extends FirestoreRecord {
  SaquesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userID" field.
  String? _userID;
  String get userID => _userID ?? '';
  bool hasUserID() => _userID != null;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  bool hasValor() => _valor != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "dataCriacao" field.
  DateTime? _dataCriacao;
  DateTime? get dataCriacao => _dataCriacao;
  bool hasDataCriacao() => _dataCriacao != null;

  // "dataAtualizacao" field.
  DateTime? _dataAtualizacao;
  DateTime? get dataAtualizacao => _dataAtualizacao;
  bool hasDataAtualizacao() => _dataAtualizacao != null;

  // "dadosBancarios" field.
  DadosTransfStruct? _dadosBancarios;
  DadosTransfStruct get dadosBancarios =>
      _dadosBancarios ?? DadosTransfStruct();
  bool hasDadosBancarios() => _dadosBancarios != null;

  void _initializeFields() {
    _userID = snapshotData['userID'] as String?;
    _valor = castToType<double>(snapshotData['valor']);
    _status = snapshotData['status'] as String?;
    _dataCriacao = snapshotData['dataCriacao'] as DateTime?;
    _dataAtualizacao = snapshotData['dataAtualizacao'] as DateTime?;
    _dadosBancarios = snapshotData['dadosBancarios'] is DadosTransfStruct
        ? snapshotData['dadosBancarios']
        : DadosTransfStruct.maybeFromMap(snapshotData['dadosBancarios']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('saques');

  static Stream<SaquesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SaquesRecord.fromSnapshot(s));

  static Future<SaquesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SaquesRecord.fromSnapshot(s));

  static SaquesRecord fromSnapshot(DocumentSnapshot snapshot) => SaquesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SaquesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SaquesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SaquesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SaquesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSaquesRecordData({
  String? userID,
  double? valor,
  String? status,
  DateTime? dataCriacao,
  DateTime? dataAtualizacao,
  DadosTransfStruct? dadosBancarios,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userID': userID,
      'valor': valor,
      'status': status,
      'dataCriacao': dataCriacao,
      'dataAtualizacao': dataAtualizacao,
      'dadosBancarios': DadosTransfStruct().toMap(),
    }.withoutNulls,
  );

  // Handle nested data for "dadosBancarios" field.
  addDadosTransfStructData(firestoreData, dadosBancarios, 'dadosBancarios');

  return firestoreData;
}

class SaquesRecordDocumentEquality implements Equality<SaquesRecord> {
  const SaquesRecordDocumentEquality();

  @override
  bool equals(SaquesRecord? e1, SaquesRecord? e2) {
    return e1?.userID == e2?.userID &&
        e1?.valor == e2?.valor &&
        e1?.status == e2?.status &&
        e1?.dataCriacao == e2?.dataCriacao &&
        e1?.dataAtualizacao == e2?.dataAtualizacao &&
        e1?.dadosBancarios == e2?.dadosBancarios;
  }

  @override
  int hash(SaquesRecord? e) => const ListEquality().hash([
        e?.userID,
        e?.valor,
        e?.status,
        e?.dataCriacao,
        e?.dataAtualizacao,
        e?.dadosBancarios
      ]);

  @override
  bool isValidKey(Object? o) => o is SaquesRecord;
}
