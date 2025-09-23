// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class VencidoStruct extends FFFirebaseStruct {
  VencidoStruct({
    String? data,
    String? foto,
    int? quantidade,
    DocumentReference? produto,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _data = data,
        _foto = foto,
        _quantidade = quantidade,
        _produto = produto,
        super(firestoreUtilData);

  // "data" field.
  String? _data;
  String get data => _data ?? '';
  set data(String? val) => _data = val;

  bool hasData() => _data != null;

  // "foto" field.
  String? _foto;
  String get foto => _foto ?? '';
  set foto(String? val) => _foto = val;

  bool hasFoto() => _foto != null;

  // "quantidade" field.
  int? _quantidade;
  int get quantidade => _quantidade ?? 0;
  set quantidade(int? val) => _quantidade = val;

  void incrementQuantidade(int amount) => quantidade = quantidade + amount;

  bool hasQuantidade() => _quantidade != null;

  // "produto" field.
  DocumentReference? _produto;
  DocumentReference? get produto => _produto;
  set produto(DocumentReference? val) => _produto = val;

  bool hasProduto() => _produto != null;

  static VencidoStruct fromMap(Map<String, dynamic> data) => VencidoStruct(
        data: data['data'] as String?,
        foto: data['foto'] as String?,
        quantidade: castToType<int>(data['quantidade']),
        produto: data['produto'] as DocumentReference?,
      );

  static VencidoStruct? maybeFromMap(dynamic data) =>
      data is Map ? VencidoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'data': _data,
        'foto': _foto,
        'quantidade': _quantidade,
        'produto': _produto,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'data': serializeParam(
          _data,
          ParamType.String,
        ),
        'foto': serializeParam(
          _foto,
          ParamType.String,
        ),
        'quantidade': serializeParam(
          _quantidade,
          ParamType.int,
        ),
        'produto': serializeParam(
          _produto,
          ParamType.DocumentReference,
        ),
      }.withoutNulls;

  static VencidoStruct fromSerializableMap(Map<String, dynamic> data) =>
      VencidoStruct(
        data: deserializeParam(
          data['data'],
          ParamType.String,
          false,
        ),
        foto: deserializeParam(
          data['foto'],
          ParamType.String,
          false,
        ),
        quantidade: deserializeParam(
          data['quantidade'],
          ParamType.int,
          false,
        ),
        produto: deserializeParam(
          data['produto'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['produto'],
        ),
      );

  @override
  String toString() => 'VencidoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VencidoStruct &&
        data == other.data &&
        foto == other.foto &&
        quantidade == other.quantidade &&
        produto == other.produto;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([data, foto, quantidade, produto]);
}

VencidoStruct createVencidoStruct({
  String? data,
  String? foto,
  int? quantidade,
  DocumentReference? produto,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    VencidoStruct(
      data: data,
      foto: foto,
      quantidade: quantidade,
      produto: produto,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

VencidoStruct? updateVencidoStruct(
  VencidoStruct? vencido, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    vencido
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addVencidoStructData(
  Map<String, dynamic> firestoreData,
  VencidoStruct? vencido,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (vencido == null) {
    return;
  }
  if (vencido.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && vencido.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final vencidoData = getVencidoFirestoreData(vencido, forFieldValue);
  final nestedData = vencidoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = vencido.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getVencidoFirestoreData(
  VencidoStruct? vencido, [
  bool forFieldValue = false,
]) {
  if (vencido == null) {
    return {};
  }
  final firestoreData = mapToFirestore(vencido.toMap());

  // Add any Firestore field values
  vencido.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getVencidoListFirestoreData(
  List<VencidoStruct>? vencidos,
) =>
    vencidos?.map((e) => getVencidoFirestoreData(e, true)).toList() ?? [];
