import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PerfisMotoristaRecord extends FirestoreRecord {
  PerfisMotoristaRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idUsuario" field.
  DocumentReference? _idUsuario;
  DocumentReference? get idUsuario => _idUsuario;
  bool hasIdUsuario() => _idUsuario != null;

  // "metricas" field.
  MetricasMotoristaStruct? _metricas;
  MetricasMotoristaStruct get metricas =>
      _metricas ?? MetricasMotoristaStruct();
  bool hasMetricas() => _metricas != null;

  // "avaliacoes" field.
  List<double>? _avaliacoes;
  List<double> get avaliacoes => _avaliacoes ?? const [];
  bool hasAvaliacoes() => _avaliacoes != null;

  // "veiculo" field.
  List<DocumentReference>? _veiculo;
  List<DocumentReference> get veiculo => _veiculo ?? const [];
  bool hasVeiculo() => _veiculo != null;

  // "cnhUrl" field.
  String? _cnhUrl;
  String get cnhUrl => _cnhUrl ?? '';
  bool hasCnhUrl() => _cnhUrl != null;

  // "cnhLiberada" field.
  bool? _cnhLiberada;
  bool get cnhLiberada => _cnhLiberada ?? false;
  bool hasCnhLiberada() => _cnhLiberada != null;

  // "cnhBloqueadaAdm" field.
  bool? _cnhBloqueadaAdm;
  bool get cnhBloqueadaAdm => _cnhBloqueadaAdm ?? false;
  bool hasCnhBloqueadaAdm() => _cnhBloqueadaAdm != null;

  // "statusAtual" field.
  bool? _statusAtual;
  bool get statusAtual => _statusAtual ?? false;
  bool hasStatusAtual() => _statusAtual != null;

  // "veiculoAtual" field.
  DocumentReference? _veiculoAtual;
  DocumentReference? get veiculoAtual => _veiculoAtual;
  bool hasVeiculoAtual() => _veiculoAtual != null;

  // "categoriasVeiculoAtual" field.
  List<DocumentReference>? _categoriasVeiculoAtual;
  List<DocumentReference> get categoriasVeiculoAtual =>
      _categoriasVeiculoAtual ?? const [];
  bool hasCategoriasVeiculoAtual() => _categoriasVeiculoAtual != null;

  // "aceitaDinheiro" field.
  bool? _aceitaDinheiro;
  bool get aceitaDinheiro => _aceitaDinheiro ?? false;
  bool hasAceitaDinheiro() => _aceitaDinheiro != null;

  void _initializeFields() {
    _idUsuario = snapshotData['idUsuario'] as DocumentReference?;
    _metricas = snapshotData['metricas'] is MetricasMotoristaStruct
        ? snapshotData['metricas']
        : MetricasMotoristaStruct.maybeFromMap(snapshotData['metricas']);
    _avaliacoes = getDataList(snapshotData['avaliacoes']);
    _veiculo = getDataList(snapshotData['veiculo']);
    _cnhUrl = snapshotData['cnhUrl'] as String?;
    _cnhLiberada = snapshotData['cnhLiberada'] as bool?;
    _cnhBloqueadaAdm = snapshotData['cnhBloqueadaAdm'] as bool?;
    _statusAtual = snapshotData['statusAtual'] as bool?;
    _veiculoAtual = snapshotData['veiculoAtual'] as DocumentReference?;
    _categoriasVeiculoAtual =
        getDataList(snapshotData['categoriasVeiculoAtual']);
    _aceitaDinheiro = snapshotData['aceitaDinheiro'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('perfisMotorista');

  static Stream<PerfisMotoristaRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PerfisMotoristaRecord.fromSnapshot(s));

  static Future<PerfisMotoristaRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PerfisMotoristaRecord.fromSnapshot(s));

  static PerfisMotoristaRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PerfisMotoristaRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PerfisMotoristaRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PerfisMotoristaRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PerfisMotoristaRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PerfisMotoristaRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPerfisMotoristaRecordData({
  DocumentReference? idUsuario,
  MetricasMotoristaStruct? metricas,
  String? cnhUrl,
  bool? cnhLiberada,
  bool? cnhBloqueadaAdm,
  bool? statusAtual,
  DocumentReference? veiculoAtual,
  bool? aceitaDinheiro,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idUsuario': idUsuario,
      'metricas': MetricasMotoristaStruct().toMap(),
      'cnhUrl': cnhUrl,
      'cnhLiberada': cnhLiberada,
      'cnhBloqueadaAdm': cnhBloqueadaAdm,
      'statusAtual': statusAtual,
      'veiculoAtual': veiculoAtual,
      'aceitaDinheiro': aceitaDinheiro,
    }.withoutNulls,
  );

  // Handle nested data for "metricas" field.
  addMetricasMotoristaStructData(firestoreData, metricas, 'metricas');

  return firestoreData;
}

class PerfisMotoristaRecordDocumentEquality
    implements Equality<PerfisMotoristaRecord> {
  const PerfisMotoristaRecordDocumentEquality();

  @override
  bool equals(PerfisMotoristaRecord? e1, PerfisMotoristaRecord? e2) {
    const listEquality = ListEquality();
    return e1?.idUsuario == e2?.idUsuario &&
        e1?.metricas == e2?.metricas &&
        listEquality.equals(e1?.avaliacoes, e2?.avaliacoes) &&
        listEquality.equals(e1?.veiculo, e2?.veiculo) &&
        e1?.cnhUrl == e2?.cnhUrl &&
        e1?.cnhLiberada == e2?.cnhLiberada &&
        e1?.cnhBloqueadaAdm == e2?.cnhBloqueadaAdm &&
        e1?.statusAtual == e2?.statusAtual &&
        e1?.veiculoAtual == e2?.veiculoAtual &&
        listEquality.equals(
            e1?.categoriasVeiculoAtual, e2?.categoriasVeiculoAtual) &&
        e1?.aceitaDinheiro == e2?.aceitaDinheiro;
  }

  @override
  int hash(PerfisMotoristaRecord? e) => const ListEquality().hash([
        e?.idUsuario,
        e?.metricas,
        e?.avaliacoes,
        e?.veiculo,
        e?.cnhUrl,
        e?.cnhLiberada,
        e?.cnhBloqueadaAdm,
        e?.statusAtual,
        e?.veiculoAtual,
        e?.categoriasVeiculoAtual,
        e?.aceitaDinheiro
      ]);

  @override
  bool isValidKey(Object? o) => o is PerfisMotoristaRecord;
}
