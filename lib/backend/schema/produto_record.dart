import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProdutoRecord extends FirestoreRecord {
  ProdutoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  bool hasNome() => _nome != null;

  // "fotoProduto" field.
  String? _fotoProduto;
  String get fotoProduto => _fotoProduto ?? '';
  bool hasFotoProduto() => _fotoProduto != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  // "pertenceMarca" field.
  String? _pertenceMarca;
  String get pertenceMarca => _pertenceMarca ?? '';
  bool hasPertenceMarca() => _pertenceMarca != null;

  // "ondeGuardar" field.
  TipoProduto? _ondeGuardar;
  TipoProduto? get ondeGuardar => _ondeGuardar;
  bool hasOndeGuardar() => _ondeGuardar != null;

  // "idEmpresa" field.
  String? _idEmpresa;
  String get idEmpresa => _idEmpresa ?? '';
  bool hasIdEmpresa() => _idEmpresa != null;

  // "idProduto" field.
  String? _idProduto;
  String get idProduto => _idProduto ?? '';
  bool hasIdProduto() => _idProduto != null;

  // "quantidade" field.
  int? _quantidade;
  int get quantidade => _quantidade ?? 0;
  bool hasQuantidade() => _quantidade != null;

  // "enderecamento" field.
  EndereamentoStruct? _enderecamento;
  EndereamentoStruct get enderecamento =>
      _enderecamento ?? EndereamentoStruct();
  bool hasEnderecamento() => _enderecamento != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _fotoProduto = snapshotData['fotoProduto'] as String?;
    _descricao = snapshotData['descricao'] as String?;
    _pertenceMarca = snapshotData['pertenceMarca'] as String?;
    _ondeGuardar = snapshotData['ondeGuardar'] is TipoProduto
        ? snapshotData['ondeGuardar']
        : deserializeEnum<TipoProduto>(snapshotData['ondeGuardar']);
    _idEmpresa = snapshotData['idEmpresa'] as String?;
    _idProduto = snapshotData['idProduto'] as String?;
    _quantidade = castToType<int>(snapshotData['quantidade']);
    _enderecamento = snapshotData['enderecamento'] is EndereamentoStruct
        ? snapshotData['enderecamento']
        : EndereamentoStruct.maybeFromMap(snapshotData['enderecamento']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('produto');

  static Stream<ProdutoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProdutoRecord.fromSnapshot(s));

  static Future<ProdutoRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProdutoRecord.fromSnapshot(s));

  static ProdutoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProdutoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProdutoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProdutoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProdutoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProdutoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProdutoRecordData({
  String? nome,
  String? fotoProduto,
  String? descricao,
  String? pertenceMarca,
  TipoProduto? ondeGuardar,
  String? idEmpresa,
  String? idProduto,
  int? quantidade,
  EndereamentoStruct? enderecamento,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'fotoProduto': fotoProduto,
      'descricao': descricao,
      'pertenceMarca': pertenceMarca,
      'ondeGuardar': ondeGuardar,
      'idEmpresa': idEmpresa,
      'idProduto': idProduto,
      'quantidade': quantidade,
      'enderecamento': EndereamentoStruct().toMap(),
    }.withoutNulls,
  );

  // Handle nested data for "enderecamento" field.
  addEndereamentoStructData(firestoreData, enderecamento, 'enderecamento');

  return firestoreData;
}

class ProdutoRecordDocumentEquality implements Equality<ProdutoRecord> {
  const ProdutoRecordDocumentEquality();

  @override
  bool equals(ProdutoRecord? e1, ProdutoRecord? e2) {
    return e1?.nome == e2?.nome &&
        e1?.fotoProduto == e2?.fotoProduto &&
        e1?.descricao == e2?.descricao &&
        e1?.pertenceMarca == e2?.pertenceMarca &&
        e1?.ondeGuardar == e2?.ondeGuardar &&
        e1?.idEmpresa == e2?.idEmpresa &&
        e1?.idProduto == e2?.idProduto &&
        e1?.quantidade == e2?.quantidade &&
        e1?.enderecamento == e2?.enderecamento;
  }

  @override
  int hash(ProdutoRecord? e) => const ListEquality().hash([
        e?.nome,
        e?.fotoProduto,
        e?.descricao,
        e?.pertenceMarca,
        e?.ondeGuardar,
        e?.idEmpresa,
        e?.idProduto,
        e?.quantidade,
        e?.enderecamento
      ]);

  @override
  bool isValidKey(Object? o) => o is ProdutoRecord;
}
