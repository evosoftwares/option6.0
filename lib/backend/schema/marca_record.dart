import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MarcaRecord extends FirestoreRecord {
  MarcaRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  bool hasNome() => _nome != null;

  // "fotoMarca" field.
  String? _fotoMarca;
  String get fotoMarca => _fotoMarca ?? '';
  bool hasFotoMarca() => _fotoMarca != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  // "idMarca" field.
  String? _idMarca;
  String get idMarca => _idMarca ?? '';
  bool hasIdMarca() => _idMarca != null;

  // "idEmpresa" field.
  String? _idEmpresa;
  String get idEmpresa => _idEmpresa ?? '';
  bool hasIdEmpresa() => _idEmpresa != null;

  // "idProdutos" field.
  List<String>? _idProdutos;
  List<String> get idProdutos => _idProdutos ?? const [];
  bool hasIdProdutos() => _idProdutos != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _fotoMarca = snapshotData['fotoMarca'] as String?;
    _descricao = snapshotData['descricao'] as String?;
    _idMarca = snapshotData['idMarca'] as String?;
    _idEmpresa = snapshotData['idEmpresa'] as String?;
    _idProdutos = getDataList(snapshotData['idProdutos']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('marca');

  static Stream<MarcaRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MarcaRecord.fromSnapshot(s));

  static Future<MarcaRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MarcaRecord.fromSnapshot(s));

  static MarcaRecord fromSnapshot(DocumentSnapshot snapshot) => MarcaRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MarcaRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MarcaRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MarcaRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MarcaRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMarcaRecordData({
  String? nome,
  String? fotoMarca,
  String? descricao,
  String? idMarca,
  String? idEmpresa,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'fotoMarca': fotoMarca,
      'descricao': descricao,
      'idMarca': idMarca,
      'idEmpresa': idEmpresa,
    }.withoutNulls,
  );

  return firestoreData;
}

class MarcaRecordDocumentEquality implements Equality<MarcaRecord> {
  const MarcaRecordDocumentEquality();

  @override
  bool equals(MarcaRecord? e1, MarcaRecord? e2) {
    const listEquality = ListEquality();
    return e1?.nome == e2?.nome &&
        e1?.fotoMarca == e2?.fotoMarca &&
        e1?.descricao == e2?.descricao &&
        e1?.idMarca == e2?.idMarca &&
        e1?.idEmpresa == e2?.idEmpresa &&
        listEquality.equals(e1?.idProdutos, e2?.idProdutos);
  }

  @override
  int hash(MarcaRecord? e) => const ListEquality().hash([
        e?.nome,
        e?.fotoMarca,
        e?.descricao,
        e?.idMarca,
        e?.idEmpresa,
        e?.idProdutos
      ]);

  @override
  bool isValidKey(Object? o) => o is MarcaRecord;
}
