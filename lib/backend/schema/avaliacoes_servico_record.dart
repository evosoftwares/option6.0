import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AvaliacoesServicoRecord extends FirestoreRecord {
  AvaliacoesServicoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "comentario" field.
  String? _comentario;
  String get comentario => _comentario ?? '';
  bool hasComentario() => _comentario != null;

  // "usuarioId" field.
  DocumentReference? _usuarioId;
  DocumentReference? get usuarioId => _usuarioId;
  bool hasUsuarioId() => _usuarioId != null;

  // "nota" field.
  double? _nota;
  double get nota => _nota ?? 0.0;
  bool hasNota() => _nota != null;

  // "prestadorId" field.
  DocumentReference? _prestadorId;
  DocumentReference? get prestadorId => _prestadorId;
  bool hasPrestadorId() => _prestadorId != null;

  // "idAvaliacao" field.
  DocumentReference? _idAvaliacao;
  DocumentReference? get idAvaliacao => _idAvaliacao;
  bool hasIdAvaliacao() => _idAvaliacao != null;

  // "idMissao" field.
  DocumentReference? _idMissao;
  DocumentReference? get idMissao => _idMissao;
  bool hasIdMissao() => _idMissao != null;

  void _initializeFields() {
    _comentario = snapshotData['comentario'] as String?;
    _usuarioId = snapshotData['usuarioId'] as DocumentReference?;
    _nota = castToType<double>(snapshotData['nota']);
    _prestadorId = snapshotData['prestadorId'] as DocumentReference?;
    _idAvaliacao = snapshotData['idAvaliacao'] as DocumentReference?;
    _idMissao = snapshotData['idMissao'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('avaliacoesServico');

  static Stream<AvaliacoesServicoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AvaliacoesServicoRecord.fromSnapshot(s));

  static Future<AvaliacoesServicoRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => AvaliacoesServicoRecord.fromSnapshot(s));

  static AvaliacoesServicoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AvaliacoesServicoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AvaliacoesServicoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AvaliacoesServicoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AvaliacoesServicoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AvaliacoesServicoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAvaliacoesServicoRecordData({
  String? comentario,
  DocumentReference? usuarioId,
  double? nota,
  DocumentReference? prestadorId,
  DocumentReference? idAvaliacao,
  DocumentReference? idMissao,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'comentario': comentario,
      'usuarioId': usuarioId,
      'nota': nota,
      'prestadorId': prestadorId,
      'idAvaliacao': idAvaliacao,
      'idMissao': idMissao,
    }.withoutNulls,
  );

  return firestoreData;
}

class AvaliacoesServicoRecordDocumentEquality
    implements Equality<AvaliacoesServicoRecord> {
  const AvaliacoesServicoRecordDocumentEquality();

  @override
  bool equals(AvaliacoesServicoRecord? e1, AvaliacoesServicoRecord? e2) {
    return e1?.comentario == e2?.comentario &&
        e1?.usuarioId == e2?.usuarioId &&
        e1?.nota == e2?.nota &&
        e1?.prestadorId == e2?.prestadorId &&
        e1?.idAvaliacao == e2?.idAvaliacao &&
        e1?.idMissao == e2?.idMissao;
  }

  @override
  int hash(AvaliacoesServicoRecord? e) => const ListEquality().hash([
        e?.comentario,
        e?.usuarioId,
        e?.nota,
        e?.prestadorId,
        e?.idAvaliacao,
        e?.idMissao
      ]);

  @override
  bool isValidKey(Object? o) => o is AvaliacoesServicoRecord;
}
