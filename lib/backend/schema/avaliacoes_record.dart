import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AvaliacoesRecord extends FirestoreRecord {
  AvaliacoesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "comentario" field.
  String? _comentario;
  String get comentario => _comentario ?? '';
  bool hasComentario() => _comentario != null;

  // "motoristaId" field.
  DocumentReference? _motoristaId;
  DocumentReference? get motoristaId => _motoristaId;
  bool hasMotoristaId() => _motoristaId != null;

  // "usuarioId" field.
  DocumentReference? _usuarioId;
  DocumentReference? get usuarioId => _usuarioId;
  bool hasUsuarioId() => _usuarioId != null;

  // "nota" field.
  double? _nota;
  double get nota => _nota ?? 0.0;
  bool hasNota() => _nota != null;

  // "idAvaliacao" field.
  DocumentReference? _idAvaliacao;
  DocumentReference? get idAvaliacao => _idAvaliacao;
  bool hasIdAvaliacao() => _idAvaliacao != null;

  void _initializeFields() {
    _comentario = snapshotData['comentario'] as String?;
    _motoristaId = snapshotData['motoristaId'] as DocumentReference?;
    _usuarioId = snapshotData['usuarioId'] as DocumentReference?;
    _nota = castToType<double>(snapshotData['nota']);
    _idAvaliacao = snapshotData['idAvaliacao'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('avaliacoes');

  static Stream<AvaliacoesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AvaliacoesRecord.fromSnapshot(s));

  static Future<AvaliacoesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AvaliacoesRecord.fromSnapshot(s));

  static AvaliacoesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AvaliacoesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AvaliacoesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AvaliacoesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AvaliacoesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AvaliacoesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAvaliacoesRecordData({
  String? comentario,
  DocumentReference? motoristaId,
  DocumentReference? usuarioId,
  double? nota,
  DocumentReference? idAvaliacao,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'comentario': comentario,
      'motoristaId': motoristaId,
      'usuarioId': usuarioId,
      'nota': nota,
      'idAvaliacao': idAvaliacao,
    }.withoutNulls,
  );

  return firestoreData;
}

class AvaliacoesRecordDocumentEquality implements Equality<AvaliacoesRecord> {
  const AvaliacoesRecordDocumentEquality();

  @override
  bool equals(AvaliacoesRecord? e1, AvaliacoesRecord? e2) {
    return e1?.comentario == e2?.comentario &&
        e1?.motoristaId == e2?.motoristaId &&
        e1?.usuarioId == e2?.usuarioId &&
        e1?.nota == e2?.nota &&
        e1?.idAvaliacao == e2?.idAvaliacao;
  }

  @override
  int hash(AvaliacoesRecord? e) => const ListEquality().hash(
      [e?.comentario, e?.motoristaId, e?.usuarioId, e?.nota, e?.idAvaliacao]);

  @override
  bool isValidKey(Object? o) => o is AvaliacoesRecord;
}
