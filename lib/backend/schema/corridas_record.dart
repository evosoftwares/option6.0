import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CorridasRecord extends FirestoreRecord {
  CorridasRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idPassageiro" field.
  DocumentReference? _idPassageiro;
  DocumentReference? get idPassageiro => _idPassageiro;
  bool hasIdPassageiro() => _idPassageiro != null;

  // "idMotorista" field.
  DocumentReference? _idMotorista;
  DocumentReference? get idMotorista => _idMotorista;
  bool hasIdMotorista() => _idMotorista != null;

  // "origemEndereco" field.
  String? _origemEndereco;
  String get origemEndereco => _origemEndereco ?? '';
  bool hasOrigemEndereco() => _origemEndereco != null;

  // "origemGeopoint" field.
  LatLng? _origemGeopoint;
  LatLng? get origemGeopoint => _origemGeopoint;
  bool hasOrigemGeopoint() => _origemGeopoint != null;

  // "destinoEndereco" field.
  String? _destinoEndereco;
  String get destinoEndereco => _destinoEndereco ?? '';
  bool hasDestinoEndereco() => _destinoEndereco != null;

  // "destinoGeopoint" field.
  LatLng? _destinoGeopoint;
  LatLng? get destinoGeopoint => _destinoGeopoint;
  bool hasDestinoGeopoint() => _destinoGeopoint != null;

  // "status" field.
  StatusCorridas? _status;
  StatusCorridas? get status => _status;
  bool hasStatus() => _status != null;

  // "valorEstimado" field.
  double? _valorEstimado;
  double get valorEstimado => _valorEstimado ?? 0.0;
  bool hasValorEstimado() => _valorEstimado != null;

  // "valorFinal" field.
  double? _valorFinal;
  double get valorFinal => _valorFinal ?? 0.0;
  bool hasValorFinal() => _valorFinal != null;

  // "valorFinalRecebidoMotorista" field.
  double? _valorFinalRecebidoMotorista;
  double get valorFinalRecebidoMotorista => _valorFinalRecebidoMotorista ?? 0.0;
  bool hasValorFinalRecebidoMotorista() => _valorFinalRecebidoMotorista != null;

  // "criadoEm" field.
  DateTime? _criadoEm;
  DateTime? get criadoEm => _criadoEm;
  bool hasCriadoEm() => _criadoEm != null;

  // "localizacaoMotorista" field.
  LatLng? _localizacaoMotorista;
  LatLng? get localizacaoMotorista => _localizacaoMotorista;
  bool hasLocalizacaoMotorista() => _localizacaoMotorista != null;

  // "motoristasDisponiveis" field.
  List<DocumentReference>? _motoristasDisponiveis;
  List<DocumentReference> get motoristasDisponiveis =>
      _motoristasDisponiveis ?? const [];
  bool hasMotoristasDisponiveis() => _motoristasDisponiveis != null;

  // "categoria" field.
  DocumentReference? _categoria;
  DocumentReference? get categoria => _categoria;
  bool hasCategoria() => _categoria != null;

  // "marca" field.
  String? _marca;
  String get marca => _marca ?? '';
  bool hasMarca() => _marca != null;

  // "modelo" field.
  String? _modelo;
  String get modelo => _modelo ?? '';
  bool hasModelo() => _modelo != null;

  // "cor" field.
  String? _cor;
  String get cor => _cor ?? '';
  bool hasCor() => _cor != null;

  // "placa" field.
  String? _placa;
  String get placa => _placa ?? '';
  bool hasPlaca() => _placa != null;

  // "nomeMotorista" field.
  String? _nomeMotorista;
  String get nomeMotorista => _nomeMotorista ?? '';
  bool hasNomeMotorista() => _nomeMotorista != null;

  // "conversa" field.
  DocumentReference? _conversa;
  DocumentReference? get conversa => _conversa;
  bool hasConversa() => _conversa != null;

  // "pagarDinheiro" field.
  bool? _pagarDinheiro;
  bool get pagarDinheiro => _pagarDinheiro ?? false;
  bool hasPagarDinheiro() => _pagarDinheiro != null;

  void _initializeFields() {
    _idPassageiro = snapshotData['idPassageiro'] as DocumentReference?;
    _idMotorista = snapshotData['idMotorista'] as DocumentReference?;
    _origemEndereco = snapshotData['origemEndereco'] as String?;
    _origemGeopoint = snapshotData['origemGeopoint'] as LatLng?;
    _destinoEndereco = snapshotData['destinoEndereco'] as String?;
    _destinoGeopoint = snapshotData['destinoGeopoint'] as LatLng?;
    _status = snapshotData['status'] is StatusCorridas
        ? snapshotData['status']
        : deserializeEnum<StatusCorridas>(snapshotData['status']);
    _valorEstimado = castToType<double>(snapshotData['valorEstimado']);
    _valorFinal = castToType<double>(snapshotData['valorFinal']);
    _valorFinalRecebidoMotorista =
        castToType<double>(snapshotData['valorFinalRecebidoMotorista']);
    _criadoEm = snapshotData['criadoEm'] as DateTime?;
    _localizacaoMotorista = snapshotData['localizacaoMotorista'] as LatLng?;
    _motoristasDisponiveis = getDataList(snapshotData['motoristasDisponiveis']);
    _categoria = snapshotData['categoria'] as DocumentReference?;
    _marca = snapshotData['marca'] as String?;
    _modelo = snapshotData['modelo'] as String?;
    _cor = snapshotData['cor'] as String?;
    _placa = snapshotData['placa'] as String?;
    _nomeMotorista = snapshotData['nomeMotorista'] as String?;
    _conversa = snapshotData['conversa'] as DocumentReference?;
    _pagarDinheiro = snapshotData['pagarDinheiro'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('corridas');

  static Stream<CorridasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CorridasRecord.fromSnapshot(s));

  static Future<CorridasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CorridasRecord.fromSnapshot(s));

  static CorridasRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CorridasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CorridasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CorridasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CorridasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CorridasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCorridasRecordData({
  DocumentReference? idPassageiro,
  DocumentReference? idMotorista,
  String? origemEndereco,
  LatLng? origemGeopoint,
  String? destinoEndereco,
  LatLng? destinoGeopoint,
  StatusCorridas? status,
  double? valorEstimado,
  double? valorFinal,
  double? valorFinalRecebidoMotorista,
  DateTime? criadoEm,
  LatLng? localizacaoMotorista,
  DocumentReference? categoria,
  String? marca,
  String? modelo,
  String? cor,
  String? placa,
  String? nomeMotorista,
  DocumentReference? conversa,
  bool? pagarDinheiro,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idPassageiro': idPassageiro,
      'idMotorista': idMotorista,
      'origemEndereco': origemEndereco,
      'origemGeopoint': origemGeopoint,
      'destinoEndereco': destinoEndereco,
      'destinoGeopoint': destinoGeopoint,
      'status': status,
      'valorEstimado': valorEstimado,
      'valorFinal': valorFinal,
      'valorFinalRecebidoMotorista': valorFinalRecebidoMotorista,
      'criadoEm': criadoEm,
      'localizacaoMotorista': localizacaoMotorista,
      'categoria': categoria,
      'marca': marca,
      'modelo': modelo,
      'cor': cor,
      'placa': placa,
      'nomeMotorista': nomeMotorista,
      'conversa': conversa,
      'pagarDinheiro': pagarDinheiro,
    }.withoutNulls,
  );

  return firestoreData;
}

class CorridasRecordDocumentEquality implements Equality<CorridasRecord> {
  const CorridasRecordDocumentEquality();

  @override
  bool equals(CorridasRecord? e1, CorridasRecord? e2) {
    const listEquality = ListEquality();
    return e1?.idPassageiro == e2?.idPassageiro &&
        e1?.idMotorista == e2?.idMotorista &&
        e1?.origemEndereco == e2?.origemEndereco &&
        e1?.origemGeopoint == e2?.origemGeopoint &&
        e1?.destinoEndereco == e2?.destinoEndereco &&
        e1?.destinoGeopoint == e2?.destinoGeopoint &&
        e1?.status == e2?.status &&
        e1?.valorEstimado == e2?.valorEstimado &&
        e1?.valorFinal == e2?.valorFinal &&
        e1?.valorFinalRecebidoMotorista == e2?.valorFinalRecebidoMotorista &&
        e1?.criadoEm == e2?.criadoEm &&
        e1?.localizacaoMotorista == e2?.localizacaoMotorista &&
        listEquality.equals(
            e1?.motoristasDisponiveis, e2?.motoristasDisponiveis) &&
        e1?.categoria == e2?.categoria &&
        e1?.marca == e2?.marca &&
        e1?.modelo == e2?.modelo &&
        e1?.cor == e2?.cor &&
        e1?.placa == e2?.placa &&
        e1?.nomeMotorista == e2?.nomeMotorista &&
        e1?.conversa == e2?.conversa &&
        e1?.pagarDinheiro == e2?.pagarDinheiro;
  }

  @override
  int hash(CorridasRecord? e) => const ListEquality().hash([
        e?.idPassageiro,
        e?.idMotorista,
        e?.origemEndereco,
        e?.origemGeopoint,
        e?.destinoEndereco,
        e?.destinoGeopoint,
        e?.status,
        e?.valorEstimado,
        e?.valorFinal,
        e?.valorFinalRecebidoMotorista,
        e?.criadoEm,
        e?.localizacaoMotorista,
        e?.motoristasDisponiveis,
        e?.categoria,
        e?.marca,
        e?.modelo,
        e?.cor,
        e?.placa,
        e?.nomeMotorista,
        e?.conversa,
        e?.pagarDinheiro
      ]);

  @override
  bool isValidKey(Object? o) => o is CorridasRecord;
}
