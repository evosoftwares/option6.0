import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RelatorioRecord extends FirestoreRecord {
  RelatorioRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "agenciaId" field.
  String? _agenciaId;
  String get agenciaId => _agenciaId ?? '';
  bool hasAgenciaId() => _agenciaId != null;

  // "promotorId" field.
  String? _promotorId;
  String get promotorId => _promotorId ?? '';
  bool hasPromotorId() => _promotorId != null;

  // "temProdutoVencido" field.
  bool? _temProdutoVencido;
  bool get temProdutoVencido => _temProdutoVencido ?? false;
  bool hasTemProdutoVencido() => _temProdutoVencido != null;

  // "dataEntrega" field.
  DateTime? _dataEntrega;
  DateTime? get dataEntrega => _dataEntrega;
  bool hasDataEntrega() => _dataEntrega != null;

  // "itensRelatorio" field.
  List<DadosProdutoStruct>? _itensRelatorio;
  List<DadosProdutoStruct> get itensRelatorio => _itensRelatorio ?? const [];
  bool hasItensRelatorio() => _itensRelatorio != null;

  // "itensProdutosVencidos" field.
  List<VencidoStruct>? _itensProdutosVencidos;
  List<VencidoStruct> get itensProdutosVencidos =>
      _itensProdutosVencidos ?? const [];
  bool hasItensProdutosVencidos() => _itensProdutosVencidos != null;

  // "relatorioId" field.
  String? _relatorioId;
  String get relatorioId => _relatorioId ?? '';
  bool hasRelatorioId() => _relatorioId != null;

  // "fotoAntes" field.
  List<String>? _fotoAntes;
  List<String> get fotoAntes => _fotoAntes ?? const [];
  bool hasFotoAntes() => _fotoAntes != null;

  // "fotoDepois" field.
  List<String>? _fotoDepois;
  List<String> get fotoDepois => _fotoDepois ?? const [];
  bool hasFotoDepois() => _fotoDepois != null;

  // "ordemId" field.
  String? _ordemId;
  String get ordemId => _ordemId ?? '';
  bool hasOrdemId() => _ordemId != null;

  // "idEnderecamento" field.
  List<DocumentReference>? _idEnderecamento;
  List<DocumentReference> get idEnderecamento => _idEnderecamento ?? const [];
  bool hasIdEnderecamento() => _idEnderecamento != null;

  // "checkIn" field.
  CheckInOutStruct? _checkIn;
  CheckInOutStruct get checkIn => _checkIn ?? CheckInOutStruct();
  bool hasCheckIn() => _checkIn != null;

  // "checkOut" field.
  CheckInOutStruct? _checkOut;
  CheckInOutStruct get checkOut => _checkOut ?? CheckInOutStruct();
  bool hasCheckOut() => _checkOut != null;

  // "status" field.
  StatusRelatorio? _status;
  StatusRelatorio? get status => _status;
  bool hasStatus() => _status != null;

  // "produtosId" field.
  List<String>? _produtosId;
  List<String> get produtosId => _produtosId ?? const [];
  bool hasProdutosId() => _produtosId != null;

  // "produtosJaRelatados" field.
  List<String>? _produtosJaRelatados;
  List<String> get produtosJaRelatados => _produtosJaRelatados ?? const [];
  bool hasProdutosJaRelatados() => _produtosJaRelatados != null;

  void _initializeFields() {
    _agenciaId = snapshotData['agenciaId'] as String?;
    _promotorId = snapshotData['promotorId'] as String?;
    _temProdutoVencido = snapshotData['temProdutoVencido'] as bool?;
    _dataEntrega = snapshotData['dataEntrega'] as DateTime?;
    _itensRelatorio = getStructList(
      snapshotData['itensRelatorio'],
      DadosProdutoStruct.fromMap,
    );
    _itensProdutosVencidos = getStructList(
      snapshotData['itensProdutosVencidos'],
      VencidoStruct.fromMap,
    );
    _relatorioId = snapshotData['relatorioId'] as String?;
    _fotoAntes = getDataList(snapshotData['fotoAntes']);
    _fotoDepois = getDataList(snapshotData['fotoDepois']);
    _ordemId = snapshotData['ordemId'] as String?;
    _idEnderecamento = getDataList(snapshotData['idEnderecamento']);
    _checkIn = snapshotData['checkIn'] is CheckInOutStruct
        ? snapshotData['checkIn']
        : CheckInOutStruct.maybeFromMap(snapshotData['checkIn']);
    _checkOut = snapshotData['checkOut'] is CheckInOutStruct
        ? snapshotData['checkOut']
        : CheckInOutStruct.maybeFromMap(snapshotData['checkOut']);
    _status = snapshotData['status'] is StatusRelatorio
        ? snapshotData['status']
        : deserializeEnum<StatusRelatorio>(snapshotData['status']);
    _produtosId = getDataList(snapshotData['produtosId']);
    _produtosJaRelatados = getDataList(snapshotData['produtosJaRelatados']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('relatorio');

  static Stream<RelatorioRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RelatorioRecord.fromSnapshot(s));

  static Future<RelatorioRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RelatorioRecord.fromSnapshot(s));

  static RelatorioRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RelatorioRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RelatorioRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RelatorioRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RelatorioRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RelatorioRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRelatorioRecordData({
  String? agenciaId,
  String? promotorId,
  bool? temProdutoVencido,
  DateTime? dataEntrega,
  String? relatorioId,
  String? ordemId,
  CheckInOutStruct? checkIn,
  CheckInOutStruct? checkOut,
  StatusRelatorio? status,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'agenciaId': agenciaId,
      'promotorId': promotorId,
      'temProdutoVencido': temProdutoVencido,
      'dataEntrega': dataEntrega,
      'relatorioId': relatorioId,
      'ordemId': ordemId,
      'checkIn': CheckInOutStruct().toMap(),
      'checkOut': CheckInOutStruct().toMap(),
      'status': status,
    }.withoutNulls,
  );

  // Handle nested data for "checkIn" field.
  addCheckInOutStructData(firestoreData, checkIn, 'checkIn');

  // Handle nested data for "checkOut" field.
  addCheckInOutStructData(firestoreData, checkOut, 'checkOut');

  return firestoreData;
}

class RelatorioRecordDocumentEquality implements Equality<RelatorioRecord> {
  const RelatorioRecordDocumentEquality();

  @override
  bool equals(RelatorioRecord? e1, RelatorioRecord? e2) {
    const listEquality = ListEquality();
    return e1?.agenciaId == e2?.agenciaId &&
        e1?.promotorId == e2?.promotorId &&
        e1?.temProdutoVencido == e2?.temProdutoVencido &&
        e1?.dataEntrega == e2?.dataEntrega &&
        listEquality.equals(e1?.itensRelatorio, e2?.itensRelatorio) &&
        listEquality.equals(
            e1?.itensProdutosVencidos, e2?.itensProdutosVencidos) &&
        e1?.relatorioId == e2?.relatorioId &&
        listEquality.equals(e1?.fotoAntes, e2?.fotoAntes) &&
        listEquality.equals(e1?.fotoDepois, e2?.fotoDepois) &&
        e1?.ordemId == e2?.ordemId &&
        listEquality.equals(e1?.idEnderecamento, e2?.idEnderecamento) &&
        e1?.checkIn == e2?.checkIn &&
        e1?.checkOut == e2?.checkOut &&
        e1?.status == e2?.status &&
        listEquality.equals(e1?.produtosId, e2?.produtosId) &&
        listEquality.equals(e1?.produtosJaRelatados, e2?.produtosJaRelatados);
  }

  @override
  int hash(RelatorioRecord? e) => const ListEquality().hash([
        e?.agenciaId,
        e?.promotorId,
        e?.temProdutoVencido,
        e?.dataEntrega,
        e?.itensRelatorio,
        e?.itensProdutosVencidos,
        e?.relatorioId,
        e?.fotoAntes,
        e?.fotoDepois,
        e?.ordemId,
        e?.idEnderecamento,
        e?.checkIn,
        e?.checkOut,
        e?.status,
        e?.produtosId,
        e?.produtosJaRelatados
      ]);

  @override
  bool isValidKey(Object? o) => o is RelatorioRecord;
}
