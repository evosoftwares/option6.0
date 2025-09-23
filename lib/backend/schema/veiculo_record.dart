import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VeiculoRecord extends FirestoreRecord {
  VeiculoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "marca" field.
  String? _marca;
  String get marca => _marca ?? '';
  bool hasMarca() => _marca != null;

  // "modelo" field.
  String? _modelo;
  String get modelo => _modelo ?? '';
  bool hasModelo() => _modelo != null;

  // "ano" field.
  int? _ano;
  int get ano => _ano ?? 0;
  bool hasAno() => _ano != null;

  // "cor" field.
  String? _cor;
  String get cor => _cor ?? '';
  bool hasCor() => _cor != null;

  // "placa" field.
  String? _placa;
  String get placa => _placa ?? '';
  bool hasPlaca() => _placa != null;

  // "fotoVeiculo" field.
  String? _fotoVeiculo;
  String get fotoVeiculo => _fotoVeiculo ?? '';
  bool hasFotoVeiculo() => _fotoVeiculo != null;

  // "userMotoristaId" field.
  DocumentReference? _userMotoristaId;
  DocumentReference? get userMotoristaId => _userMotoristaId;
  bool hasUserMotoristaId() => _userMotoristaId != null;

  // "statusAtivo" field.
  bool? _statusAtivo;
  bool get statusAtivo => _statusAtivo ?? false;
  bool hasStatusAtivo() => _statusAtivo != null;

  // "motoristaId" field.
  DocumentReference? _motoristaId;
  DocumentReference? get motoristaId => _motoristaId;
  bool hasMotoristaId() => _motoristaId != null;

  // "crlvUrl" field.
  String? _crlvUrl;
  String get crlvUrl => _crlvUrl ?? '';
  bool hasCrlvUrl() => _crlvUrl != null;

  // "categoria" field.
  List<DocumentReference>? _categoria;
  List<DocumentReference> get categoria => _categoria ?? const [];
  bool hasCategoria() => _categoria != null;

  // "bancosDeCouro" field.
  bool? _bancosDeCouro;
  bool get bancosDeCouro => _bancosDeCouro ?? false;
  bool hasBancosDeCouro() => _bancosDeCouro != null;

  // "tem4Portas" field.
  bool? _tem4Portas;
  bool get tem4Portas => _tem4Portas ?? false;
  bool hasTem4Portas() => _tem4Portas != null;

  // "arCondicionado" field.
  bool? _arCondicionado;
  bool get arCondicionado => _arCondicionado ?? false;
  bool hasArCondicionado() => _arCondicionado != null;

  // "tipoVeiculo" field.
  TipoVeiculoEnum? _tipoVeiculo;
  TipoVeiculoEnum? get tipoVeiculo => _tipoVeiculo;
  bool hasTipoVeiculo() => _tipoVeiculo != null;

  void _initializeFields() {
    _marca = snapshotData['marca'] as String?;
    _modelo = snapshotData['modelo'] as String?;
    _ano = castToType<int>(snapshotData['ano']);
    _cor = snapshotData['cor'] as String?;
    _placa = snapshotData['placa'] as String?;
    _fotoVeiculo = snapshotData['fotoVeiculo'] as String?;
    _userMotoristaId = snapshotData['userMotoristaId'] as DocumentReference?;
    _statusAtivo = snapshotData['statusAtivo'] as bool?;
    _motoristaId = snapshotData['motoristaId'] as DocumentReference?;
    _crlvUrl = snapshotData['crlvUrl'] as String?;
    _categoria = getDataList(snapshotData['categoria']);
    _bancosDeCouro = snapshotData['bancosDeCouro'] as bool?;
    _tem4Portas = snapshotData['tem4Portas'] as bool?;
    _arCondicionado = snapshotData['arCondicionado'] as bool?;
    _tipoVeiculo = snapshotData['tipoVeiculo'] is TipoVeiculoEnum
        ? snapshotData['tipoVeiculo']
        : deserializeEnum<TipoVeiculoEnum>(snapshotData['tipoVeiculo']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('veiculo');

  static Stream<VeiculoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => VeiculoRecord.fromSnapshot(s));

  static Future<VeiculoRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => VeiculoRecord.fromSnapshot(s));

  static VeiculoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      VeiculoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static VeiculoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      VeiculoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'VeiculoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is VeiculoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createVeiculoRecordData({
  String? marca,
  String? modelo,
  int? ano,
  String? cor,
  String? placa,
  String? fotoVeiculo,
  DocumentReference? userMotoristaId,
  bool? statusAtivo,
  DocumentReference? motoristaId,
  String? crlvUrl,
  bool? bancosDeCouro,
  bool? tem4Portas,
  bool? arCondicionado,
  TipoVeiculoEnum? tipoVeiculo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'cor': cor,
      'placa': placa,
      'fotoVeiculo': fotoVeiculo,
      'userMotoristaId': userMotoristaId,
      'statusAtivo': statusAtivo,
      'motoristaId': motoristaId,
      'crlvUrl': crlvUrl,
      'bancosDeCouro': bancosDeCouro,
      'tem4Portas': tem4Portas,
      'arCondicionado': arCondicionado,
      'tipoVeiculo': tipoVeiculo,
    }.withoutNulls,
  );

  return firestoreData;
}

class VeiculoRecordDocumentEquality implements Equality<VeiculoRecord> {
  const VeiculoRecordDocumentEquality();

  @override
  bool equals(VeiculoRecord? e1, VeiculoRecord? e2) {
    const listEquality = ListEquality();
    return e1?.marca == e2?.marca &&
        e1?.modelo == e2?.modelo &&
        e1?.ano == e2?.ano &&
        e1?.cor == e2?.cor &&
        e1?.placa == e2?.placa &&
        e1?.fotoVeiculo == e2?.fotoVeiculo &&
        e1?.userMotoristaId == e2?.userMotoristaId &&
        e1?.statusAtivo == e2?.statusAtivo &&
        e1?.motoristaId == e2?.motoristaId &&
        e1?.crlvUrl == e2?.crlvUrl &&
        listEquality.equals(e1?.categoria, e2?.categoria) &&
        e1?.bancosDeCouro == e2?.bancosDeCouro &&
        e1?.tem4Portas == e2?.tem4Portas &&
        e1?.arCondicionado == e2?.arCondicionado &&
        e1?.tipoVeiculo == e2?.tipoVeiculo;
  }

  @override
  int hash(VeiculoRecord? e) => const ListEquality().hash([
        e?.marca,
        e?.modelo,
        e?.ano,
        e?.cor,
        e?.placa,
        e?.fotoVeiculo,
        e?.userMotoristaId,
        e?.statusAtivo,
        e?.motoristaId,
        e?.crlvUrl,
        e?.categoria,
        e?.bancosDeCouro,
        e?.tem4Portas,
        e?.arCondicionado,
        e?.tipoVeiculo
      ]);

  @override
  bool isValidKey(Object? o) => o is VeiculoRecord;
}
