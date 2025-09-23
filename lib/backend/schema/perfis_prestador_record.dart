import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PerfisPrestadorRecord extends FirestoreRecord {
  PerfisPrestadorRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idUsuario" field.
  DocumentReference? _idUsuario;
  DocumentReference? get idUsuario => _idUsuario;
  bool hasIdUsuario() => _idUsuario != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  // "formacao" field.
  String? _formacao;
  String get formacao => _formacao ?? '';
  bool hasFormacao() => _formacao != null;

  // "experiencia" field.
  String? _experiencia;
  String get experiencia => _experiencia ?? '';
  bool hasExperiencia() => _experiencia != null;

  // "profissao" field.
  String? _profissao;
  String get profissao => _profissao ?? '';
  bool hasProfissao() => _profissao != null;

  // "categorias" field.
  List<DocumentReference>? _categorias;
  List<DocumentReference> get categorias => _categorias ?? const [];
  bool hasCategorias() => _categorias != null;

  // "chave_pix" field.
  String? _chavePix;
  String get chavePix => _chavePix ?? '';
  bool hasChavePix() => _chavePix != null;

  // "reputacao" field.
  ReputacaoStruct? _reputacao;
  ReputacaoStruct get reputacao => _reputacao ?? ReputacaoStruct();
  bool hasReputacao() => _reputacao != null;

  // "disponivel" field.
  bool? _disponivel;
  bool get disponivel => _disponivel ?? false;
  bool hasDisponivel() => _disponivel != null;

  // "gamificacao" field.
  GamificacaoStruct? _gamificacao;
  GamificacaoStruct get gamificacao => _gamificacao ?? GamificacaoStruct();
  bool hasGamificacao() => _gamificacao != null;

  // "metricas" field.
  MetricasStruct? _metricas;
  MetricasStruct get metricas => _metricas ?? MetricasStruct();
  bool hasMetricas() => _metricas != null;

  // "areasCidades" field.
  List<String>? _areasCidades;
  List<String> get areasCidades => _areasCidades ?? const [];
  bool hasAreasCidades() => _areasCidades != null;

  // "areasAtuacao" field.
  List<AreaAtuacaoStruct>? _areasAtuacao;
  List<AreaAtuacaoStruct> get areasAtuacao => _areasAtuacao ?? const [];
  bool hasAreasAtuacao() => _areasAtuacao != null;

  // "online" field.
  bool? _online;
  bool get online => _online ?? false;
  bool hasOnline() => _online != null;

  // "avaliacoes" field.
  List<DocumentReference>? _avaliacoes;
  List<DocumentReference> get avaliacoes => _avaliacoes ?? const [];
  bool hasAvaliacoes() => _avaliacoes != null;

  // "idPrestador" field.
  DocumentReference? _idPrestador;
  DocumentReference? get idPrestador => _idPrestador;
  bool hasIdPrestador() => _idPrestador != null;

  void _initializeFields() {
    _idUsuario = snapshotData['idUsuario'] as DocumentReference?;
    _descricao = snapshotData['descricao'] as String?;
    _formacao = snapshotData['formacao'] as String?;
    _experiencia = snapshotData['experiencia'] as String?;
    _profissao = snapshotData['profissao'] as String?;
    _categorias = getDataList(snapshotData['categorias']);
    _chavePix = snapshotData['chave_pix'] as String?;
    _reputacao = snapshotData['reputacao'] is ReputacaoStruct
        ? snapshotData['reputacao']
        : ReputacaoStruct.maybeFromMap(snapshotData['reputacao']);
    _disponivel = snapshotData['disponivel'] as bool?;
    _gamificacao = snapshotData['gamificacao'] is GamificacaoStruct
        ? snapshotData['gamificacao']
        : GamificacaoStruct.maybeFromMap(snapshotData['gamificacao']);
    _metricas = snapshotData['metricas'] is MetricasStruct
        ? snapshotData['metricas']
        : MetricasStruct.maybeFromMap(snapshotData['metricas']);
    _areasCidades = getDataList(snapshotData['areasCidades']);
    _areasAtuacao = getStructList(
      snapshotData['areasAtuacao'],
      AreaAtuacaoStruct.fromMap,
    );
    _online = snapshotData['online'] as bool?;
    _avaliacoes = getDataList(snapshotData['avaliacoes']);
    _idPrestador = snapshotData['idPrestador'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('perfisPrestador');

  static Stream<PerfisPrestadorRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PerfisPrestadorRecord.fromSnapshot(s));

  static Future<PerfisPrestadorRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PerfisPrestadorRecord.fromSnapshot(s));

  static PerfisPrestadorRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PerfisPrestadorRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PerfisPrestadorRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PerfisPrestadorRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PerfisPrestadorRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PerfisPrestadorRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPerfisPrestadorRecordData({
  DocumentReference? idUsuario,
  String? descricao,
  String? formacao,
  String? experiencia,
  String? profissao,
  String? chavePix,
  ReputacaoStruct? reputacao,
  bool? disponivel,
  GamificacaoStruct? gamificacao,
  MetricasStruct? metricas,
  bool? online,
  DocumentReference? idPrestador,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idUsuario': idUsuario,
      'descricao': descricao,
      'formacao': formacao,
      'experiencia': experiencia,
      'profissao': profissao,
      'chave_pix': chavePix,
      'reputacao': ReputacaoStruct().toMap(),
      'disponivel': disponivel,
      'gamificacao': GamificacaoStruct().toMap(),
      'metricas': MetricasStruct().toMap(),
      'online': online,
      'idPrestador': idPrestador,
    }.withoutNulls,
  );

  // Handle nested data for "reputacao" field.
  addReputacaoStructData(firestoreData, reputacao, 'reputacao');

  // Handle nested data for "gamificacao" field.
  addGamificacaoStructData(firestoreData, gamificacao, 'gamificacao');

  // Handle nested data for "metricas" field.
  addMetricasStructData(firestoreData, metricas, 'metricas');

  return firestoreData;
}

class PerfisPrestadorRecordDocumentEquality
    implements Equality<PerfisPrestadorRecord> {
  const PerfisPrestadorRecordDocumentEquality();

  @override
  bool equals(PerfisPrestadorRecord? e1, PerfisPrestadorRecord? e2) {
    const listEquality = ListEquality();
    return e1?.idUsuario == e2?.idUsuario &&
        e1?.descricao == e2?.descricao &&
        e1?.formacao == e2?.formacao &&
        e1?.experiencia == e2?.experiencia &&
        e1?.profissao == e2?.profissao &&
        listEquality.equals(e1?.categorias, e2?.categorias) &&
        e1?.chavePix == e2?.chavePix &&
        e1?.reputacao == e2?.reputacao &&
        e1?.disponivel == e2?.disponivel &&
        e1?.gamificacao == e2?.gamificacao &&
        e1?.metricas == e2?.metricas &&
        listEquality.equals(e1?.areasCidades, e2?.areasCidades) &&
        listEquality.equals(e1?.areasAtuacao, e2?.areasAtuacao) &&
        e1?.online == e2?.online &&
        listEquality.equals(e1?.avaliacoes, e2?.avaliacoes) &&
        e1?.idPrestador == e2?.idPrestador;
  }

  @override
  int hash(PerfisPrestadorRecord? e) => const ListEquality().hash([
        e?.idUsuario,
        e?.descricao,
        e?.formacao,
        e?.experiencia,
        e?.profissao,
        e?.categorias,
        e?.chavePix,
        e?.reputacao,
        e?.disponivel,
        e?.gamificacao,
        e?.metricas,
        e?.areasCidades,
        e?.areasAtuacao,
        e?.online,
        e?.avaliacoes,
        e?.idPrestador
      ]);

  @override
  bool isValidKey(Object? o) => o is PerfisPrestadorRecord;
}
