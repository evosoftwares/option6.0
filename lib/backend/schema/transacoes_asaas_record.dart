import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TransacoesAsaasRecord extends FirestoreRecord {
  TransacoesAsaasRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "asaas_payment_id" field.
  String? _asaasPaymentId;
  String get asaasPaymentId => _asaasPaymentId ?? '';
  bool hasAsaasPaymentId() => _asaasPaymentId != null;

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  bool hasValor() => _valor != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "data_criacao" field.
  DateTime? _dataCriacao;
  DateTime? get dataCriacao => _dataCriacao;
  bool hasDataCriacao() => _dataCriacao != null;

  void _initializeFields() {
    _asaasPaymentId = snapshotData['asaas_payment_id'] as String?;
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _valor = castToType<double>(snapshotData['valor']);
    _status = snapshotData['status'] as String?;
    _dataCriacao = snapshotData['data_criacao'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('transacoes_asaas');

  static Stream<TransacoesAsaasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TransacoesAsaasRecord.fromSnapshot(s));

  static Future<TransacoesAsaasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TransacoesAsaasRecord.fromSnapshot(s));

  static TransacoesAsaasRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TransacoesAsaasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TransacoesAsaasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TransacoesAsaasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TransacoesAsaasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TransacoesAsaasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTransacoesAsaasRecordData({
  String? asaasPaymentId,
  DocumentReference? userRef,
  double? valor,
  String? status,
  DateTime? dataCriacao,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'asaas_payment_id': asaasPaymentId,
      'user_ref': userRef,
      'valor': valor,
      'status': status,
      'data_criacao': dataCriacao,
    }.withoutNulls,
  );

  return firestoreData;
}

class TransacoesAsaasRecordDocumentEquality
    implements Equality<TransacoesAsaasRecord> {
  const TransacoesAsaasRecordDocumentEquality();

  @override
  bool equals(TransacoesAsaasRecord? e1, TransacoesAsaasRecord? e2) {
    return e1?.asaasPaymentId == e2?.asaasPaymentId &&
        e1?.userRef == e2?.userRef &&
        e1?.valor == e2?.valor &&
        e1?.status == e2?.status &&
        e1?.dataCriacao == e2?.dataCriacao;
  }

  @override
  int hash(TransacoesAsaasRecord? e) => const ListEquality().hash(
      [e?.asaasPaymentId, e?.userRef, e?.valor, e?.status, e?.dataCriacao]);

  @override
  bool isValidKey(Object? o) => o is TransacoesAsaasRecord;
}
