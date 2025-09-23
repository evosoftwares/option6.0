import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RequerimentoRecord extends FirestoreRecord {
  RequerimentoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idRequerimento" field.
  DocumentReference? _idRequerimento;
  DocumentReference? get idRequerimento => _idRequerimento;
  bool hasIdRequerimento() => _idRequerimento != null;

  // "quantasPessoas" field.
  int? _quantasPessoas;
  int get quantasPessoas => _quantasPessoas ?? 0;
  bool hasQuantasPessoas() => _quantasPessoas != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  // "temCheckList" field.
  bool? _temCheckList;
  bool get temCheckList => _temCheckList ?? false;
  bool hasTemCheckList() => _temCheckList != null;

  // "tituloCheckList" field.
  String? _tituloCheckList;
  String get tituloCheckList => _tituloCheckList ?? '';
  bool hasTituloCheckList() => _tituloCheckList != null;

  // "itensCheckList" field.
  List<ChecklistItemStructStruct>? _itensCheckList;
  List<ChecklistItemStructStruct> get itensCheckList =>
      _itensCheckList ?? const [];
  bool hasItensCheckList() => _itensCheckList != null;

  // "enderecoCompleto" field.
  String? _enderecoCompleto;
  String get enderecoCompleto => _enderecoCompleto ?? '';
  bool hasEnderecoCompleto() => _enderecoCompleto != null;

  // "enderecoGeoPoint" field.
  LatLng? _enderecoGeoPoint;
  LatLng? get enderecoGeoPoint => _enderecoGeoPoint;
  bool hasEnderecoGeoPoint() => _enderecoGeoPoint != null;

  // "valorPagamento" field.
  double? _valorPagamento;
  double get valorPagamento => _valorPagamento ?? 0.0;
  bool hasValorPagamento() => _valorPagamento != null;

  // "status" field.
  StatusMissoes? _status;
  StatusMissoes? get status => _status;
  bool hasStatus() => _status != null;

  // "criadoPor" field.
  DocumentReference? _criadoPor;
  DocumentReference? get criadoPor => _criadoPor;
  bool hasCriadoPor() => _criadoPor != null;

  // "criadoEm" field.
  DateTime? _criadoEm;
  DateTime? get criadoEm => _criadoEm;
  bool hasCriadoEm() => _criadoEm != null;

  // "dataInicio" field.
  String? _dataInicio;
  String get dataInicio => _dataInicio ?? '';
  bool hasDataInicio() => _dataInicio != null;

  // "numerosCheckList" field.
  CheckListStruct? _numerosCheckList;
  CheckListStruct get numerosCheckList =>
      _numerosCheckList ?? CheckListStruct();
  bool hasNumerosCheckList() => _numerosCheckList != null;

  void _initializeFields() {
    _idRequerimento = snapshotData['idRequerimento'] as DocumentReference?;
    _quantasPessoas = castToType<int>(snapshotData['quantasPessoas']);
    _descricao = snapshotData['descricao'] as String?;
    _temCheckList = snapshotData['temCheckList'] as bool?;
    _tituloCheckList = snapshotData['tituloCheckList'] as String?;
    _itensCheckList = getStructList(
      snapshotData['itensCheckList'],
      ChecklistItemStructStruct.fromMap,
    );
    _enderecoCompleto = snapshotData['enderecoCompleto'] as String?;
    _enderecoGeoPoint = snapshotData['enderecoGeoPoint'] as LatLng?;
    _valorPagamento = castToType<double>(snapshotData['valorPagamento']);
    _status = snapshotData['status'] is StatusMissoes
        ? snapshotData['status']
        : deserializeEnum<StatusMissoes>(snapshotData['status']);
    _criadoPor = snapshotData['criadoPor'] as DocumentReference?;
    _criadoEm = snapshotData['criadoEm'] as DateTime?;
    _dataInicio = snapshotData['dataInicio'] as String?;
    _numerosCheckList = snapshotData['numerosCheckList'] is CheckListStruct
        ? snapshotData['numerosCheckList']
        : CheckListStruct.maybeFromMap(snapshotData['numerosCheckList']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('requerimento');

  static Stream<RequerimentoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RequerimentoRecord.fromSnapshot(s));

  static Future<RequerimentoRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RequerimentoRecord.fromSnapshot(s));

  static RequerimentoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RequerimentoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RequerimentoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RequerimentoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RequerimentoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RequerimentoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRequerimentoRecordData({
  DocumentReference? idRequerimento,
  int? quantasPessoas,
  String? descricao,
  bool? temCheckList,
  String? tituloCheckList,
  String? enderecoCompleto,
  LatLng? enderecoGeoPoint,
  double? valorPagamento,
  StatusMissoes? status,
  DocumentReference? criadoPor,
  DateTime? criadoEm,
  String? dataInicio,
  CheckListStruct? numerosCheckList,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idRequerimento': idRequerimento,
      'quantasPessoas': quantasPessoas,
      'descricao': descricao,
      'temCheckList': temCheckList,
      'tituloCheckList': tituloCheckList,
      'enderecoCompleto': enderecoCompleto,
      'enderecoGeoPoint': enderecoGeoPoint,
      'valorPagamento': valorPagamento,
      'status': status,
      'criadoPor': criadoPor,
      'criadoEm': criadoEm,
      'dataInicio': dataInicio,
      'numerosCheckList': CheckListStruct().toMap(),
    }.withoutNulls,
  );

  // Handle nested data for "numerosCheckList" field.
  addCheckListStructData(firestoreData, numerosCheckList, 'numerosCheckList');

  return firestoreData;
}

class RequerimentoRecordDocumentEquality
    implements Equality<RequerimentoRecord> {
  const RequerimentoRecordDocumentEquality();

  @override
  bool equals(RequerimentoRecord? e1, RequerimentoRecord? e2) {
    const listEquality = ListEquality();
    return e1?.idRequerimento == e2?.idRequerimento &&
        e1?.quantasPessoas == e2?.quantasPessoas &&
        e1?.descricao == e2?.descricao &&
        e1?.temCheckList == e2?.temCheckList &&
        e1?.tituloCheckList == e2?.tituloCheckList &&
        listEquality.equals(e1?.itensCheckList, e2?.itensCheckList) &&
        e1?.enderecoCompleto == e2?.enderecoCompleto &&
        e1?.enderecoGeoPoint == e2?.enderecoGeoPoint &&
        e1?.valorPagamento == e2?.valorPagamento &&
        e1?.status == e2?.status &&
        e1?.criadoPor == e2?.criadoPor &&
        e1?.criadoEm == e2?.criadoEm &&
        e1?.dataInicio == e2?.dataInicio &&
        e1?.numerosCheckList == e2?.numerosCheckList;
  }

  @override
  int hash(RequerimentoRecord? e) => const ListEquality().hash([
        e?.idRequerimento,
        e?.quantasPessoas,
        e?.descricao,
        e?.temCheckList,
        e?.tituloCheckList,
        e?.itensCheckList,
        e?.enderecoCompleto,
        e?.enderecoGeoPoint,
        e?.valorPagamento,
        e?.status,
        e?.criadoPor,
        e?.criadoEm,
        e?.dataInicio,
        e?.numerosCheckList
      ]);

  @override
  bool isValidKey(Object? o) => o is RequerimentoRecord;
}
