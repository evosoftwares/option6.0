import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MissoesRecord extends FirestoreRecord {
  MissoesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "titulo" field.
  String? _titulo;
  String get titulo => _titulo ?? '';
  bool hasTitulo() => _titulo != null;

  // "tipo" field.
  TipoMissoes? _tipo;
  TipoMissoes? get tipo => _tipo;
  bool hasTipo() => _tipo != null;

  // "criadoPor" field.
  DocumentReference? _criadoPor;
  DocumentReference? get criadoPor => _criadoPor;
  bool hasCriadoPor() => _criadoPor != null;

  // "idEmpresa" field.
  DocumentReference? _idEmpresa;
  DocumentReference? get idEmpresa => _idEmpresa;
  bool hasIdEmpresa() => _idEmpresa != null;

  // "idParceiroAtribuido" field.
  DocumentReference? _idParceiroAtribuido;
  DocumentReference? get idParceiroAtribuido => _idParceiroAtribuido;
  bool hasIdParceiroAtribuido() => _idParceiroAtribuido != null;

  // "status" field.
  StatusMissoes? _status;
  StatusMissoes? get status => _status;
  bool hasStatus() => _status != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  // "valorPagamento" field.
  double? _valorPagamento;
  double get valorPagamento => _valorPagamento ?? 0.0;
  bool hasValorPagamento() => _valorPagamento != null;

  // "conversa" field.
  DocumentReference? _conversa;
  DocumentReference? get conversa => _conversa;
  bool hasConversa() => _conversa != null;

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

  // "criadoEm" field.
  DateTime? _criadoEm;
  DateTime? get criadoEm => _criadoEm;
  bool hasCriadoEm() => _criadoEm != null;

  // "dataInicio" field.
  String? _dataInicio;
  String get dataInicio => _dataInicio ?? '';
  bool hasDataInicio() => _dataInicio != null;

  // "missaoAvaliada" field.
  bool? _missaoAvaliada;
  bool get missaoAvaliada => _missaoAvaliada ?? false;
  bool hasMissaoAvaliada() => _missaoAvaliada != null;

  // "idRequerimento" field.
  DocumentReference? _idRequerimento;
  DocumentReference? get idRequerimento => _idRequerimento;
  bool hasIdRequerimento() => _idRequerimento != null;

  // "idAvaliacao" field.
  DocumentReference? _idAvaliacao;
  DocumentReference? get idAvaliacao => _idAvaliacao;
  bool hasIdAvaliacao() => _idAvaliacao != null;

  // "checkIn" field.
  DateTime? _checkIn;
  DateTime? get checkIn => _checkIn;
  bool hasCheckIn() => _checkIn != null;

  // "checkOut" field.
  DateTime? _checkOut;
  DateTime? get checkOut => _checkOut;
  bool hasCheckOut() => _checkOut != null;

  // "fotoAntes" field.
  List<String>? _fotoAntes;
  List<String> get fotoAntes => _fotoAntes ?? const [];
  bool hasFotoAntes() => _fotoAntes != null;

  // "fotoDepois" field.
  List<String>? _fotoDepois;
  List<String> get fotoDepois => _fotoDepois ?? const [];
  bool hasFotoDepois() => _fotoDepois != null;

  // "completo" field.
  bool? _completo;
  bool get completo => _completo ?? false;
  bool hasCompleto() => _completo != null;

  // "localizacao" field.
  LatLng? _localizacao;
  LatLng? get localizacao => _localizacao;
  bool hasLocalizacao() => _localizacao != null;

  void _initializeFields() {
    _titulo = snapshotData['titulo'] as String?;
    _tipo = snapshotData['tipo'] is TipoMissoes
        ? snapshotData['tipo']
        : deserializeEnum<TipoMissoes>(snapshotData['tipo']);
    _criadoPor = snapshotData['criadoPor'] as DocumentReference?;
    _idEmpresa = snapshotData['idEmpresa'] as DocumentReference?;
    _idParceiroAtribuido =
        snapshotData['idParceiroAtribuido'] as DocumentReference?;
    _status = snapshotData['status'] is StatusMissoes
        ? snapshotData['status']
        : deserializeEnum<StatusMissoes>(snapshotData['status']);
    _descricao = snapshotData['descricao'] as String?;
    _valorPagamento = castToType<double>(snapshotData['valorPagamento']);
    _conversa = snapshotData['conversa'] as DocumentReference?;
    _temCheckList = snapshotData['temCheckList'] as bool?;
    _tituloCheckList = snapshotData['tituloCheckList'] as String?;
    _itensCheckList = getStructList(
      snapshotData['itensCheckList'],
      ChecklistItemStructStruct.fromMap,
    );
    _enderecoCompleto = snapshotData['enderecoCompleto'] as String?;
    _enderecoGeoPoint = snapshotData['enderecoGeoPoint'] as LatLng?;
    _criadoEm = snapshotData['criadoEm'] as DateTime?;
    _dataInicio = snapshotData['dataInicio'] as String?;
    _missaoAvaliada = snapshotData['missaoAvaliada'] as bool?;
    _idRequerimento = snapshotData['idRequerimento'] as DocumentReference?;
    _idAvaliacao = snapshotData['idAvaliacao'] as DocumentReference?;
    _checkIn = snapshotData['checkIn'] as DateTime?;
    _checkOut = snapshotData['checkOut'] as DateTime?;
    _fotoAntes = getDataList(snapshotData['fotoAntes']);
    _fotoDepois = getDataList(snapshotData['fotoDepois']);
    _completo = snapshotData['completo'] as bool?;
    _localizacao = snapshotData['localizacao'] as LatLng?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('missoes');

  static Stream<MissoesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MissoesRecord.fromSnapshot(s));

  static Future<MissoesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MissoesRecord.fromSnapshot(s));

  static MissoesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MissoesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MissoesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MissoesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MissoesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MissoesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMissoesRecordData({
  String? titulo,
  TipoMissoes? tipo,
  DocumentReference? criadoPor,
  DocumentReference? idEmpresa,
  DocumentReference? idParceiroAtribuido,
  StatusMissoes? status,
  String? descricao,
  double? valorPagamento,
  DocumentReference? conversa,
  bool? temCheckList,
  String? tituloCheckList,
  String? enderecoCompleto,
  LatLng? enderecoGeoPoint,
  DateTime? criadoEm,
  String? dataInicio,
  bool? missaoAvaliada,
  DocumentReference? idRequerimento,
  DocumentReference? idAvaliacao,
  DateTime? checkIn,
  DateTime? checkOut,
  bool? completo,
  LatLng? localizacao,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'titulo': titulo,
      'tipo': tipo,
      'criadoPor': criadoPor,
      'idEmpresa': idEmpresa,
      'idParceiroAtribuido': idParceiroAtribuido,
      'status': status,
      'descricao': descricao,
      'valorPagamento': valorPagamento,
      'conversa': conversa,
      'temCheckList': temCheckList,
      'tituloCheckList': tituloCheckList,
      'enderecoCompleto': enderecoCompleto,
      'enderecoGeoPoint': enderecoGeoPoint,
      'criadoEm': criadoEm,
      'dataInicio': dataInicio,
      'missaoAvaliada': missaoAvaliada,
      'idRequerimento': idRequerimento,
      'idAvaliacao': idAvaliacao,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'completo': completo,
      'localizacao': localizacao,
    }.withoutNulls,
  );

  return firestoreData;
}

class MissoesRecordDocumentEquality implements Equality<MissoesRecord> {
  const MissoesRecordDocumentEquality();

  @override
  bool equals(MissoesRecord? e1, MissoesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.titulo == e2?.titulo &&
        e1?.tipo == e2?.tipo &&
        e1?.criadoPor == e2?.criadoPor &&
        e1?.idEmpresa == e2?.idEmpresa &&
        e1?.idParceiroAtribuido == e2?.idParceiroAtribuido &&
        e1?.status == e2?.status &&
        e1?.descricao == e2?.descricao &&
        e1?.valorPagamento == e2?.valorPagamento &&
        e1?.conversa == e2?.conversa &&
        e1?.temCheckList == e2?.temCheckList &&
        e1?.tituloCheckList == e2?.tituloCheckList &&
        listEquality.equals(e1?.itensCheckList, e2?.itensCheckList) &&
        e1?.enderecoCompleto == e2?.enderecoCompleto &&
        e1?.enderecoGeoPoint == e2?.enderecoGeoPoint &&
        e1?.criadoEm == e2?.criadoEm &&
        e1?.dataInicio == e2?.dataInicio &&
        e1?.missaoAvaliada == e2?.missaoAvaliada &&
        e1?.idRequerimento == e2?.idRequerimento &&
        e1?.idAvaliacao == e2?.idAvaliacao &&
        e1?.checkIn == e2?.checkIn &&
        e1?.checkOut == e2?.checkOut &&
        listEquality.equals(e1?.fotoAntes, e2?.fotoAntes) &&
        listEquality.equals(e1?.fotoDepois, e2?.fotoDepois) &&
        e1?.completo == e2?.completo &&
        e1?.localizacao == e2?.localizacao;
  }

  @override
  int hash(MissoesRecord? e) => const ListEquality().hash([
        e?.titulo,
        e?.tipo,
        e?.criadoPor,
        e?.idEmpresa,
        e?.idParceiroAtribuido,
        e?.status,
        e?.descricao,
        e?.valorPagamento,
        e?.conversa,
        e?.temCheckList,
        e?.tituloCheckList,
        e?.itensCheckList,
        e?.enderecoCompleto,
        e?.enderecoGeoPoint,
        e?.criadoEm,
        e?.dataInicio,
        e?.missaoAvaliada,
        e?.idRequerimento,
        e?.idAvaliacao,
        e?.checkIn,
        e?.checkOut,
        e?.fotoAntes,
        e?.fotoDepois,
        e?.completo,
        e?.localizacao
      ]);

  @override
  bool isValidKey(Object? o) => o is MissoesRecord;
}
