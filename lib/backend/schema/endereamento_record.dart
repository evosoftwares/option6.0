import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EndereamentoRecord extends FirestoreRecord {
  EndereamentoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idAgencia" field.
  String? _idAgencia;
  String get idAgencia => _idAgencia ?? '';
  bool hasIdAgencia() => _idAgencia != null;

  // "idProdutos" field.
  List<String>? _idProdutos;
  List<String> get idProdutos => _idProdutos ?? const [];
  bool hasIdProdutos() => _idProdutos != null;

  // "idEnderecamento" field.
  String? _idEnderecamento;
  String get idEnderecamento => _idEnderecamento ?? '';
  bool hasIdEnderecamento() => _idEnderecamento != null;

  // "refrigerado" field.
  bool? _refrigerado;
  bool get refrigerado => _refrigerado ?? false;
  bool hasRefrigerado() => _refrigerado != null;

  // "observacao" field.
  String? _observacao;
  String get observacao => _observacao ?? '';
  bool hasObservacao() => _observacao != null;

  // "cdigo" field.
  String? _cdigo;
  String get cdigo => _cdigo ?? '';
  bool hasCdigo() => _cdigo != null;

  // "endereamento" field.
  EndereamentoStruct? _endereamento;
  EndereamentoStruct get endereamento => _endereamento ?? EndereamentoStruct();
  bool hasEndereamento() => _endereamento != null;

  void _initializeFields() {
    _idAgencia = snapshotData['idAgencia'] as String?;
    _idProdutos = getDataList(snapshotData['idProdutos']);
    _idEnderecamento = snapshotData['idEnderecamento'] as String?;
    _refrigerado = snapshotData['refrigerado'] as bool?;
    _observacao = snapshotData['observacao'] as String?;
    _cdigo = snapshotData['cdigo'] as String?;
    _endereamento = snapshotData['endereamento'] is EndereamentoStruct
        ? snapshotData['endereamento']
        : EndereamentoStruct.maybeFromMap(snapshotData['endereamento']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('endereamento');

  static Stream<EndereamentoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EndereamentoRecord.fromSnapshot(s));

  static Future<EndereamentoRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EndereamentoRecord.fromSnapshot(s));

  static EndereamentoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      EndereamentoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EndereamentoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EndereamentoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EndereamentoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EndereamentoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEndereamentoRecordData({
  String? idAgencia,
  String? idEnderecamento,
  bool? refrigerado,
  String? observacao,
  String? cdigo,
  EndereamentoStruct? endereamento,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idAgencia': idAgencia,
      'idEnderecamento': idEnderecamento,
      'refrigerado': refrigerado,
      'observacao': observacao,
      'cdigo': cdigo,
      'endereamento': EndereamentoStruct().toMap(),
    }.withoutNulls,
  );

  // Handle nested data for "endereamento" field.
  addEndereamentoStructData(firestoreData, endereamento, 'endereamento');

  return firestoreData;
}

class EndereamentoRecordDocumentEquality
    implements Equality<EndereamentoRecord> {
  const EndereamentoRecordDocumentEquality();

  @override
  bool equals(EndereamentoRecord? e1, EndereamentoRecord? e2) {
    const listEquality = ListEquality();
    return e1?.idAgencia == e2?.idAgencia &&
        listEquality.equals(e1?.idProdutos, e2?.idProdutos) &&
        e1?.idEnderecamento == e2?.idEnderecamento &&
        e1?.refrigerado == e2?.refrigerado &&
        e1?.observacao == e2?.observacao &&
        e1?.cdigo == e2?.cdigo &&
        e1?.endereamento == e2?.endereamento;
  }

  @override
  int hash(EndereamentoRecord? e) => const ListEquality().hash([
        e?.idAgencia,
        e?.idProdutos,
        e?.idEnderecamento,
        e?.refrigerado,
        e?.observacao,
        e?.cdigo,
        e?.endereamento
      ]);

  @override
  bool isValidKey(Object? o) => o is EndereamentoRecord;
}
