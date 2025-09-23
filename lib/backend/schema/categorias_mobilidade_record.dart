import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CategoriasMobilidadeRecord extends FirestoreRecord {
  CategoriasMobilidadeRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  bool hasNome() => _nome != null;

  // "statusAtivo" field.
  bool? _statusAtivo;
  bool get statusAtivo => _statusAtivo ?? false;
  bool hasStatusAtivo() => _statusAtivo != null;

  // "fatorMultiplicador" field.
  double? _fatorMultiplicador;
  double get fatorMultiplicador => _fatorMultiplicador ?? 0.0;
  bool hasFatorMultiplicador() => _fatorMultiplicador != null;

  // "foto" field.
  String? _foto;
  String get foto => _foto ?? '';
  bool hasFoto() => _foto != null;

  // "apenasEntrega" field.
  bool? _apenasEntrega;
  bool get apenasEntrega => _apenasEntrega ?? false;
  bool hasApenasEntrega() => _apenasEntrega != null;

  // "anoMinimoCategoria" field.
  int? _anoMinimoCategoria;
  int get anoMinimoCategoria => _anoMinimoCategoria ?? 0;
  bool hasAnoMinimoCategoria() => _anoMinimoCategoria != null;

  // "tiposPermitidos" field.
  List<TipoVeiculoEnum>? _tiposPermitidos;
  List<TipoVeiculoEnum> get tiposPermitidos => _tiposPermitidos ?? const [];
  bool hasTiposPermitidos() => _tiposPermitidos != null;

  // "tem4Portas" field.
  bool? _tem4Portas;
  bool get tem4Portas => _tem4Portas ?? false;
  bool hasTem4Portas() => _tem4Portas != null;

  // "bancosDeCouro" field.
  bool? _bancosDeCouro;
  bool get bancosDeCouro => _bancosDeCouro ?? false;
  bool hasBancosDeCouro() => _bancosDeCouro != null;

  // "arCondicionado" field.
  bool? _arCondicionado;
  bool get arCondicionado => _arCondicionado ?? false;
  bool hasArCondicionado() => _arCondicionado != null;

  // "descricaoBreve" field.
  String? _descricaoBreve;
  String get descricaoBreve => _descricaoBreve ?? '';
  bool hasDescricaoBreve() => _descricaoBreve != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _statusAtivo = snapshotData['statusAtivo'] as bool?;
    _fatorMultiplicador =
        castToType<double>(snapshotData['fatorMultiplicador']);
    _foto = snapshotData['foto'] as String?;
    _apenasEntrega = snapshotData['apenasEntrega'] as bool?;
    _anoMinimoCategoria = castToType<int>(snapshotData['anoMinimoCategoria']);
    _tiposPermitidos =
        getEnumList<TipoVeiculoEnum>(snapshotData['tiposPermitidos']);
    _tem4Portas = snapshotData['tem4Portas'] as bool?;
    _bancosDeCouro = snapshotData['bancosDeCouro'] as bool?;
    _arCondicionado = snapshotData['arCondicionado'] as bool?;
    _descricaoBreve = snapshotData['descricaoBreve'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('categoriasMobilidade');

  static Stream<CategoriasMobilidadeRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => CategoriasMobilidadeRecord.fromSnapshot(s));

  static Future<CategoriasMobilidadeRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => CategoriasMobilidadeRecord.fromSnapshot(s));

  static CategoriasMobilidadeRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CategoriasMobilidadeRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CategoriasMobilidadeRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CategoriasMobilidadeRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CategoriasMobilidadeRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CategoriasMobilidadeRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCategoriasMobilidadeRecordData({
  String? nome,
  bool? statusAtivo,
  double? fatorMultiplicador,
  String? foto,
  bool? apenasEntrega,
  int? anoMinimoCategoria,
  bool? tem4Portas,
  bool? bancosDeCouro,
  bool? arCondicionado,
  String? descricaoBreve,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'statusAtivo': statusAtivo,
      'fatorMultiplicador': fatorMultiplicador,
      'foto': foto,
      'apenasEntrega': apenasEntrega,
      'anoMinimoCategoria': anoMinimoCategoria,
      'tem4Portas': tem4Portas,
      'bancosDeCouro': bancosDeCouro,
      'arCondicionado': arCondicionado,
      'descricaoBreve': descricaoBreve,
    }.withoutNulls,
  );

  return firestoreData;
}

class CategoriasMobilidadeRecordDocumentEquality
    implements Equality<CategoriasMobilidadeRecord> {
  const CategoriasMobilidadeRecordDocumentEquality();

  @override
  bool equals(CategoriasMobilidadeRecord? e1, CategoriasMobilidadeRecord? e2) {
    const listEquality = ListEquality();
    return e1?.nome == e2?.nome &&
        e1?.statusAtivo == e2?.statusAtivo &&
        e1?.fatorMultiplicador == e2?.fatorMultiplicador &&
        e1?.foto == e2?.foto &&
        e1?.apenasEntrega == e2?.apenasEntrega &&
        e1?.anoMinimoCategoria == e2?.anoMinimoCategoria &&
        listEquality.equals(e1?.tiposPermitidos, e2?.tiposPermitidos) &&
        e1?.tem4Portas == e2?.tem4Portas &&
        e1?.bancosDeCouro == e2?.bancosDeCouro &&
        e1?.arCondicionado == e2?.arCondicionado &&
        e1?.descricaoBreve == e2?.descricaoBreve;
  }

  @override
  int hash(CategoriasMobilidadeRecord? e) => const ListEquality().hash([
        e?.nome,
        e?.statusAtivo,
        e?.fatorMultiplicador,
        e?.foto,
        e?.apenasEntrega,
        e?.anoMinimoCategoria,
        e?.tiposPermitidos,
        e?.tem4Portas,
        e?.bancosDeCouro,
        e?.arCondicionado,
        e?.descricaoBreve
      ]);

  @override
  bool isValidKey(Object? o) => o is CategoriasMobilidadeRecord;
}
