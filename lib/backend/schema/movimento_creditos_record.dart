import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MovimentoCreditosRecord extends FirestoreRecord {
  MovimentoCreditosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "tipo" field.
  TipoMovimento? _tipo;
  TipoMovimento? get tipo => _tipo;
  bool hasTipo() => _tipo != null;

  // "dataMovimento" field.
  DateTime? _dataMovimento;
  DateTime? get dataMovimento => _dataMovimento;
  bool hasDataMovimento() => _dataMovimento != null;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  bool hasValor() => _valor != null;

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "fonte" field.
  DocumentReference? _fonte;
  DocumentReference? get fonte => _fonte;
  bool hasFonte() => _fonte != null;

  // "missao" field.
  DocumentReference? _missao;
  DocumentReference? get missao => _missao;
  bool hasMissao() => _missao != null;

  // "corrida" field.
  DocumentReference? _corrida;
  DocumentReference? get corrida => _corrida;
  bool hasCorrida() => _corrida != null;

  // "requerimento" field.
  DocumentReference? _requerimento;
  DocumentReference? get requerimento => _requerimento;
  bool hasRequerimento() => _requerimento != null;

  void _initializeFields() {
    _tipo = snapshotData['tipo'] is TipoMovimento
        ? snapshotData['tipo']
        : deserializeEnum<TipoMovimento>(snapshotData['tipo']);
    _dataMovimento = snapshotData['dataMovimento'] as DateTime?;
    _valor = castToType<double>(snapshotData['valor']);
    _user = snapshotData['user'] as DocumentReference?;
    _fonte = snapshotData['fonte'] as DocumentReference?;
    _missao = snapshotData['missao'] as DocumentReference?;
    _corrida = snapshotData['corrida'] as DocumentReference?;
    _requerimento = snapshotData['requerimento'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('movimentoCreditos');

  static Stream<MovimentoCreditosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MovimentoCreditosRecord.fromSnapshot(s));

  static Future<MovimentoCreditosRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => MovimentoCreditosRecord.fromSnapshot(s));

  static MovimentoCreditosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MovimentoCreditosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MovimentoCreditosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MovimentoCreditosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MovimentoCreditosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MovimentoCreditosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMovimentoCreditosRecordData({
  TipoMovimento? tipo,
  DateTime? dataMovimento,
  double? valor,
  DocumentReference? user,
  DocumentReference? fonte,
  DocumentReference? missao,
  DocumentReference? corrida,
  DocumentReference? requerimento,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'tipo': tipo,
      'dataMovimento': dataMovimento,
      'valor': valor,
      'user': user,
      'fonte': fonte,
      'missao': missao,
      'corrida': corrida,
      'requerimento': requerimento,
    }.withoutNulls,
  );

  return firestoreData;
}

class MovimentoCreditosRecordDocumentEquality
    implements Equality<MovimentoCreditosRecord> {
  const MovimentoCreditosRecordDocumentEquality();

  @override
  bool equals(MovimentoCreditosRecord? e1, MovimentoCreditosRecord? e2) {
    return e1?.tipo == e2?.tipo &&
        e1?.dataMovimento == e2?.dataMovimento &&
        e1?.valor == e2?.valor &&
        e1?.user == e2?.user &&
        e1?.fonte == e2?.fonte &&
        e1?.missao == e2?.missao &&
        e1?.corrida == e2?.corrida &&
        e1?.requerimento == e2?.requerimento;
  }

  @override
  int hash(MovimentoCreditosRecord? e) => const ListEquality().hash([
        e?.tipo,
        e?.dataMovimento,
        e?.valor,
        e?.user,
        e?.fonte,
        e?.missao,
        e?.corrida,
        e?.requerimento
      ]);

  @override
  bool isValidKey(Object? o) => o is MovimentoCreditosRecord;
}
