import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrdemDeServicoEmpresaRecord extends FirestoreRecord {
  OrdemDeServicoEmpresaRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idAgencia" field.
  String? _idAgencia;
  String get idAgencia => _idAgencia ?? '';
  bool hasIdAgencia() => _idAgencia != null;

  // "idPromotor" field.
  String? _idPromotor;
  String get idPromotor => _idPromotor ?? '';
  bool hasIdPromotor() => _idPromotor != null;

  // "recorrente" field.
  bool? _recorrente;
  bool get recorrente => _recorrente ?? false;
  bool hasRecorrente() => _recorrente != null;

  // "status" field.
  StatusServico? _status;
  StatusServico? get status => _status;
  bool hasStatus() => _status != null;

  // "produtos" field.
  List<String>? _produtos;
  List<String> get produtos => _produtos ?? const [];
  bool hasProdutos() => _produtos != null;

  // "data" field.
  String? _data;
  String get data => _data ?? '';
  bool hasData() => _data != null;

  // "hora" field.
  String? _hora;
  String get hora => _hora ?? '';
  bool hasHora() => _hora != null;

  // "criadoEm" field.
  DateTime? _criadoEm;
  DateTime? get criadoEm => _criadoEm;
  bool hasCriadoEm() => _criadoEm != null;

  // "frequencia" field.
  RepeticaoServico? _frequencia;
  RepeticaoServico? get frequencia => _frequencia;
  bool hasFrequencia() => _frequencia != null;

  // "idRelatorio" field.
  String? _idRelatorio;
  String get idRelatorio => _idRelatorio ?? '';
  bool hasIdRelatorio() => _idRelatorio != null;

  // "idOrdem" field.
  String? _idOrdem;
  String get idOrdem => _idOrdem ?? '';
  bool hasIdOrdem() => _idOrdem != null;

  // "idEmprea" field.
  String? _idEmprea;
  String get idEmprea => _idEmprea ?? '';
  bool hasIdEmprea() => _idEmprea != null;

  // "marcas" field.
  List<DocumentReference>? _marcas;
  List<DocumentReference> get marcas => _marcas ?? const [];
  bool hasMarcas() => _marcas != null;

  // "relatando" field.
  bool? _relatando;
  bool get relatando => _relatando ?? false;
  bool hasRelatando() => _relatando != null;

  void _initializeFields() {
    _idAgencia = snapshotData['idAgencia'] as String?;
    _idPromotor = snapshotData['idPromotor'] as String?;
    _recorrente = snapshotData['recorrente'] as bool?;
    _status = snapshotData['status'] is StatusServico
        ? snapshotData['status']
        : deserializeEnum<StatusServico>(snapshotData['status']);
    _produtos = getDataList(snapshotData['produtos']);
    _data = snapshotData['data'] as String?;
    _hora = snapshotData['hora'] as String?;
    _criadoEm = snapshotData['criadoEm'] as DateTime?;
    _frequencia = snapshotData['frequencia'] is RepeticaoServico
        ? snapshotData['frequencia']
        : deserializeEnum<RepeticaoServico>(snapshotData['frequencia']);
    _idRelatorio = snapshotData['idRelatorio'] as String?;
    _idOrdem = snapshotData['idOrdem'] as String?;
    _idEmprea = snapshotData['idEmprea'] as String?;
    _marcas = getDataList(snapshotData['marcas']);
    _relatando = snapshotData['relatando'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('ordemDeServicoEmpresa');

  static Stream<OrdemDeServicoEmpresaRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => OrdemDeServicoEmpresaRecord.fromSnapshot(s));

  static Future<OrdemDeServicoEmpresaRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => OrdemDeServicoEmpresaRecord.fromSnapshot(s));

  static OrdemDeServicoEmpresaRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OrdemDeServicoEmpresaRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrdemDeServicoEmpresaRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrdemDeServicoEmpresaRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrdemDeServicoEmpresaRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrdemDeServicoEmpresaRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrdemDeServicoEmpresaRecordData({
  String? idAgencia,
  String? idPromotor,
  bool? recorrente,
  StatusServico? status,
  String? data,
  String? hora,
  DateTime? criadoEm,
  RepeticaoServico? frequencia,
  String? idRelatorio,
  String? idOrdem,
  String? idEmprea,
  bool? relatando,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idAgencia': idAgencia,
      'idPromotor': idPromotor,
      'recorrente': recorrente,
      'status': status,
      'data': data,
      'hora': hora,
      'criadoEm': criadoEm,
      'frequencia': frequencia,
      'idRelatorio': idRelatorio,
      'idOrdem': idOrdem,
      'idEmprea': idEmprea,
      'relatando': relatando,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrdemDeServicoEmpresaRecordDocumentEquality
    implements Equality<OrdemDeServicoEmpresaRecord> {
  const OrdemDeServicoEmpresaRecordDocumentEquality();

  @override
  bool equals(
      OrdemDeServicoEmpresaRecord? e1, OrdemDeServicoEmpresaRecord? e2) {
    const listEquality = ListEquality();
    return e1?.idAgencia == e2?.idAgencia &&
        e1?.idPromotor == e2?.idPromotor &&
        e1?.recorrente == e2?.recorrente &&
        e1?.status == e2?.status &&
        listEquality.equals(e1?.produtos, e2?.produtos) &&
        e1?.data == e2?.data &&
        e1?.hora == e2?.hora &&
        e1?.criadoEm == e2?.criadoEm &&
        e1?.frequencia == e2?.frequencia &&
        e1?.idRelatorio == e2?.idRelatorio &&
        e1?.idOrdem == e2?.idOrdem &&
        e1?.idEmprea == e2?.idEmprea &&
        listEquality.equals(e1?.marcas, e2?.marcas) &&
        e1?.relatando == e2?.relatando;
  }

  @override
  int hash(OrdemDeServicoEmpresaRecord? e) => const ListEquality().hash([
        e?.idAgencia,
        e?.idPromotor,
        e?.recorrente,
        e?.status,
        e?.produtos,
        e?.data,
        e?.hora,
        e?.criadoEm,
        e?.frequencia,
        e?.idRelatorio,
        e?.idOrdem,
        e?.idEmprea,
        e?.marcas,
        e?.relatando
      ]);

  @override
  bool isValidKey(Object? o) => o is OrdemDeServicoEmpresaRecord;
}
