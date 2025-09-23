import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CarteirasRecord extends FirestoreRecord {
  CarteirasRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idUsuario" field.
  DocumentReference? _idUsuario;
  DocumentReference? get idUsuario => _idUsuario;
  bool hasIdUsuario() => _idUsuario != null;

  // "saldoDisponivel" field.
  double? _saldoDisponivel;
  double get saldoDisponivel => _saldoDisponivel ?? 0.0;
  bool hasSaldoDisponivel() => _saldoDisponivel != null;

  // "saldoPendente" field.
  double? _saldoPendente;
  double get saldoPendente => _saldoPendente ?? 0.0;
  bool hasSaldoPendente() => _saldoPendente != null;

  // "ultimaAtualizacao" field.
  DateTime? _ultimaAtualizacao;
  DateTime? get ultimaAtualizacao => _ultimaAtualizacao;
  bool hasUltimaAtualizacao() => _ultimaAtualizacao != null;

  void _initializeFields() {
    _idUsuario = snapshotData['idUsuario'] as DocumentReference?;
    _saldoDisponivel = castToType<double>(snapshotData['saldoDisponivel']);
    _saldoPendente = castToType<double>(snapshotData['saldoPendente']);
    _ultimaAtualizacao = snapshotData['ultimaAtualizacao'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('carteiras');

  static Stream<CarteirasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CarteirasRecord.fromSnapshot(s));

  static Future<CarteirasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CarteirasRecord.fromSnapshot(s));

  static CarteirasRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CarteirasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CarteirasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CarteirasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CarteirasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CarteirasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCarteirasRecordData({
  DocumentReference? idUsuario,
  double? saldoDisponivel,
  double? saldoPendente,
  DateTime? ultimaAtualizacao,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idUsuario': idUsuario,
      'saldoDisponivel': saldoDisponivel,
      'saldoPendente': saldoPendente,
      'ultimaAtualizacao': ultimaAtualizacao,
    }.withoutNulls,
  );

  return firestoreData;
}

class CarteirasRecordDocumentEquality implements Equality<CarteirasRecord> {
  const CarteirasRecordDocumentEquality();

  @override
  bool equals(CarteirasRecord? e1, CarteirasRecord? e2) {
    return e1?.idUsuario == e2?.idUsuario &&
        e1?.saldoDisponivel == e2?.saldoDisponivel &&
        e1?.saldoPendente == e2?.saldoPendente &&
        e1?.ultimaAtualizacao == e2?.ultimaAtualizacao;
  }

  @override
  int hash(CarteirasRecord? e) => const ListEquality().hash([
        e?.idUsuario,
        e?.saldoDisponivel,
        e?.saldoPendente,
        e?.ultimaAtualizacao
      ]);

  @override
  bool isValidKey(Object? o) => o is CarteirasRecord;
}
