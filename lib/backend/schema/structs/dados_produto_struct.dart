// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DadosProdutoStruct extends FFFirebaseStruct {
  DadosProdutoStruct({
    List<String>? fotoAntes,
    DocumentReference? produto,
    List<String>? fotoDepois,
    String? validade,
    String? lote,
    EndereamentoStruct? localizacao,
    int? quantidade,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _fotoAntes = fotoAntes,
        _produto = produto,
        _fotoDepois = fotoDepois,
        _validade = validade,
        _lote = lote,
        _localizacao = localizacao,
        _quantidade = quantidade,
        super(firestoreUtilData);

  // "fotoAntes" field.
  List<String>? _fotoAntes;
  List<String> get fotoAntes => _fotoAntes ?? const [];
  set fotoAntes(List<String>? val) => _fotoAntes = val;

  void updateFotoAntes(Function(List<String>) updateFn) {
    updateFn(_fotoAntes ??= []);
  }

  bool hasFotoAntes() => _fotoAntes != null;

  // "produto" field.
  DocumentReference? _produto;
  DocumentReference? get produto => _produto;
  set produto(DocumentReference? val) => _produto = val;

  bool hasProduto() => _produto != null;

  // "fotoDepois" field.
  List<String>? _fotoDepois;
  List<String> get fotoDepois => _fotoDepois ?? const [];
  set fotoDepois(List<String>? val) => _fotoDepois = val;

  void updateFotoDepois(Function(List<String>) updateFn) {
    updateFn(_fotoDepois ??= []);
  }

  bool hasFotoDepois() => _fotoDepois != null;

  // "validade" field.
  String? _validade;
  String get validade => _validade ?? '';
  set validade(String? val) => _validade = val;

  bool hasValidade() => _validade != null;

  // "lote" field.
  String? _lote;
  String get lote => _lote ?? '';
  set lote(String? val) => _lote = val;

  bool hasLote() => _lote != null;

  // "localizacao" field.
  EndereamentoStruct? _localizacao;
  EndereamentoStruct get localizacao => _localizacao ?? EndereamentoStruct();
  set localizacao(EndereamentoStruct? val) => _localizacao = val;

  void updateLocalizacao(Function(EndereamentoStruct) updateFn) {
    updateFn(_localizacao ??= EndereamentoStruct());
  }

  bool hasLocalizacao() => _localizacao != null;

  // "quantidade" field.
  int? _quantidade;
  int get quantidade => _quantidade ?? 0;
  set quantidade(int? val) => _quantidade = val;

  void incrementQuantidade(int amount) => quantidade = quantidade + amount;

  bool hasQuantidade() => _quantidade != null;

  static DadosProdutoStruct fromMap(Map<String, dynamic> data) =>
      DadosProdutoStruct(
        fotoAntes: getDataList(data['fotoAntes']),
        produto: data['produto'] as DocumentReference?,
        fotoDepois: getDataList(data['fotoDepois']),
        validade: data['validade'] as String?,
        lote: data['lote'] as String?,
        localizacao: data['localizacao'] is EndereamentoStruct
            ? data['localizacao']
            : EndereamentoStruct.maybeFromMap(data['localizacao']),
        quantidade: castToType<int>(data['quantidade']),
      );

  static DadosProdutoStruct? maybeFromMap(dynamic data) => data is Map
      ? DadosProdutoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'fotoAntes': _fotoAntes,
        'produto': _produto,
        'fotoDepois': _fotoDepois,
        'validade': _validade,
        'lote': _lote,
        'localizacao': _localizacao?.toMap(),
        'quantidade': _quantidade,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'fotoAntes': serializeParam(
          _fotoAntes,
          ParamType.String,
          isList: true,
        ),
        'produto': serializeParam(
          _produto,
          ParamType.DocumentReference,
        ),
        'fotoDepois': serializeParam(
          _fotoDepois,
          ParamType.String,
          isList: true,
        ),
        'validade': serializeParam(
          _validade,
          ParamType.String,
        ),
        'lote': serializeParam(
          _lote,
          ParamType.String,
        ),
        'localizacao': serializeParam(
          _localizacao,
          ParamType.DataStruct,
        ),
        'quantidade': serializeParam(
          _quantidade,
          ParamType.int,
        ),
      }.withoutNulls;

  static DadosProdutoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DadosProdutoStruct(
        fotoAntes: deserializeParam<String>(
          data['fotoAntes'],
          ParamType.String,
          true,
        ),
        produto: deserializeParam(
          data['produto'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['produto'],
        ),
        fotoDepois: deserializeParam<String>(
          data['fotoDepois'],
          ParamType.String,
          true,
        ),
        validade: deserializeParam(
          data['validade'],
          ParamType.String,
          false,
        ),
        lote: deserializeParam(
          data['lote'],
          ParamType.String,
          false,
        ),
        localizacao: deserializeStructParam(
          data['localizacao'],
          ParamType.DataStruct,
          false,
          structBuilder: EndereamentoStruct.fromSerializableMap,
        ),
        quantidade: deserializeParam(
          data['quantidade'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DadosProdutoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is DadosProdutoStruct &&
        listEquality.equals(fotoAntes, other.fotoAntes) &&
        produto == other.produto &&
        listEquality.equals(fotoDepois, other.fotoDepois) &&
        validade == other.validade &&
        lote == other.lote &&
        localizacao == other.localizacao &&
        quantidade == other.quantidade;
  }

  @override
  int get hashCode => const ListEquality().hash([
        fotoAntes,
        produto,
        fotoDepois,
        validade,
        lote,
        localizacao,
        quantidade
      ]);
}

DadosProdutoStruct createDadosProdutoStruct({
  DocumentReference? produto,
  String? validade,
  String? lote,
  EndereamentoStruct? localizacao,
  int? quantidade,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DadosProdutoStruct(
      produto: produto,
      validade: validade,
      lote: lote,
      localizacao:
          localizacao ?? (clearUnsetFields ? EndereamentoStruct() : null),
      quantidade: quantidade,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DadosProdutoStruct? updateDadosProdutoStruct(
  DadosProdutoStruct? dadosProduto, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dadosProduto
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDadosProdutoStructData(
  Map<String, dynamic> firestoreData,
  DadosProdutoStruct? dadosProduto,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dadosProduto == null) {
    return;
  }
  if (dadosProduto.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && dadosProduto.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dadosProdutoData =
      getDadosProdutoFirestoreData(dadosProduto, forFieldValue);
  final nestedData =
      dadosProdutoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = dadosProduto.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDadosProdutoFirestoreData(
  DadosProdutoStruct? dadosProduto, [
  bool forFieldValue = false,
]) {
  if (dadosProduto == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dadosProduto.toMap());

  // Handle nested data for "localizacao" field.
  addEndereamentoStructData(
    firestoreData,
    dadosProduto.hasLocalizacao() ? dadosProduto.localizacao : null,
    'localizacao',
    forFieldValue,
  );

  // Add any Firestore field values
  dadosProduto.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDadosProdutoListFirestoreData(
  List<DadosProdutoStruct>? dadosProdutos,
) =>
    dadosProdutos?.map((e) => getDadosProdutoFirestoreData(e, true)).toList() ??
    [];
