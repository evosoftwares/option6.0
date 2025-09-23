import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AgenciaRecord extends FirestoreRecord {
  AgenciaRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idAgencia" field.
  String? _idAgencia;
  String get idAgencia => _idAgencia ?? '';
  bool hasIdAgencia() => _idAgencia != null;

  // "idEmpresa" field.
  String? _idEmpresa;
  String get idEmpresa => _idEmpresa ?? '';
  bool hasIdEmpresa() => _idEmpresa != null;

  // "idPromotores" field.
  List<String>? _idPromotores;
  List<String> get idPromotores => _idPromotores ?? const [];
  bool hasIdPromotores() => _idPromotores != null;

  // "endereco" field.
  EnderecoComercialStruct? _endereco;
  EnderecoComercialStruct get endereco =>
      _endereco ?? EnderecoComercialStruct();
  bool hasEndereco() => _endereco != null;

  // "idMarcas" field.
  List<String>? _idMarcas;
  List<String> get idMarcas => _idMarcas ?? const [];
  bool hasIdMarcas() => _idMarcas != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  bool hasNome() => _nome != null;

  // "idProdutos" field.
  List<String>? _idProdutos;
  List<String> get idProdutos => _idProdutos ?? const [];
  bool hasIdProdutos() => _idProdutos != null;

  // "lideres" field.
  List<String>? _lideres;
  List<String> get lideres => _lideres ?? const [];
  bool hasLideres() => _lideres != null;

  void _initializeFields() {
    _idAgencia = snapshotData['idAgencia'] as String?;
    _idEmpresa = snapshotData['idEmpresa'] as String?;
    _idPromotores = getDataList(snapshotData['idPromotores']);
    _endereco = snapshotData['endereco'] is EnderecoComercialStruct
        ? snapshotData['endereco']
        : EnderecoComercialStruct.maybeFromMap(snapshotData['endereco']);
    _idMarcas = getDataList(snapshotData['idMarcas']);
    _nome = snapshotData['nome'] as String?;
    _idProdutos = getDataList(snapshotData['idProdutos']);
    _lideres = getDataList(snapshotData['lideres']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('agencia');

  static Stream<AgenciaRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AgenciaRecord.fromSnapshot(s));

  static Future<AgenciaRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AgenciaRecord.fromSnapshot(s));

  static AgenciaRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AgenciaRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AgenciaRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AgenciaRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AgenciaRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AgenciaRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAgenciaRecordData({
  String? idAgencia,
  String? idEmpresa,
  EnderecoComercialStruct? endereco,
  String? nome,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idAgencia': idAgencia,
      'idEmpresa': idEmpresa,
      'endereco': EnderecoComercialStruct().toMap(),
      'nome': nome,
    }.withoutNulls,
  );

  // Handle nested data for "endereco" field.
  addEnderecoComercialStructData(firestoreData, endereco, 'endereco');

  return firestoreData;
}

class AgenciaRecordDocumentEquality implements Equality<AgenciaRecord> {
  const AgenciaRecordDocumentEquality();

  @override
  bool equals(AgenciaRecord? e1, AgenciaRecord? e2) {
    const listEquality = ListEquality();
    return e1?.idAgencia == e2?.idAgencia &&
        e1?.idEmpresa == e2?.idEmpresa &&
        listEquality.equals(e1?.idPromotores, e2?.idPromotores) &&
        e1?.endereco == e2?.endereco &&
        listEquality.equals(e1?.idMarcas, e2?.idMarcas) &&
        e1?.nome == e2?.nome &&
        listEquality.equals(e1?.idProdutos, e2?.idProdutos) &&
        listEquality.equals(e1?.lideres, e2?.lideres);
  }

  @override
  int hash(AgenciaRecord? e) => const ListEquality().hash([
        e?.idAgencia,
        e?.idEmpresa,
        e?.idPromotores,
        e?.endereco,
        e?.idMarcas,
        e?.nome,
        e?.idProdutos,
        e?.lideres
      ]);

  @override
  bool isValidKey(Object? o) => o is AgenciaRecord;
}
