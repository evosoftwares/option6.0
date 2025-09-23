// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class VeiculoStruct extends FFFirebaseStruct {
  VeiculoStruct({
    String? marca,
    String? modelo,
    int? ano,
    String? cor,
    String? placa,
    String? fotoVeiculo,
    DocumentReference? categoria,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _marca = marca,
        _modelo = modelo,
        _ano = ano,
        _cor = cor,
        _placa = placa,
        _fotoVeiculo = fotoVeiculo,
        _categoria = categoria,
        super(firestoreUtilData);

  // "marca" field.
  String? _marca;
  String get marca => _marca ?? '';
  set marca(String? val) => _marca = val;

  bool hasMarca() => _marca != null;

  // "modelo" field.
  String? _modelo;
  String get modelo => _modelo ?? '';
  set modelo(String? val) => _modelo = val;

  bool hasModelo() => _modelo != null;

  // "ano" field.
  int? _ano;
  int get ano => _ano ?? 0;
  set ano(int? val) => _ano = val;

  void incrementAno(int amount) => ano = ano + amount;

  bool hasAno() => _ano != null;

  // "cor" field.
  String? _cor;
  String get cor => _cor ?? '';
  set cor(String? val) => _cor = val;

  bool hasCor() => _cor != null;

  // "placa" field.
  String? _placa;
  String get placa => _placa ?? '';
  set placa(String? val) => _placa = val;

  bool hasPlaca() => _placa != null;

  // "fotoVeiculo" field.
  String? _fotoVeiculo;
  String get fotoVeiculo => _fotoVeiculo ?? '';
  set fotoVeiculo(String? val) => _fotoVeiculo = val;

  bool hasFotoVeiculo() => _fotoVeiculo != null;

  // "categoria" field.
  DocumentReference? _categoria;
  DocumentReference? get categoria => _categoria;
  set categoria(DocumentReference? val) => _categoria = val;

  bool hasCategoria() => _categoria != null;

  static VeiculoStruct fromMap(Map<String, dynamic> data) => VeiculoStruct(
        marca: data['marca'] as String?,
        modelo: data['modelo'] as String?,
        ano: castToType<int>(data['ano']),
        cor: data['cor'] as String?,
        placa: data['placa'] as String?,
        fotoVeiculo: data['fotoVeiculo'] as String?,
        categoria: data['categoria'] as DocumentReference?,
      );

  static VeiculoStruct? maybeFromMap(dynamic data) =>
      data is Map ? VeiculoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'marca': _marca,
        'modelo': _modelo,
        'ano': _ano,
        'cor': _cor,
        'placa': _placa,
        'fotoVeiculo': _fotoVeiculo,
        'categoria': _categoria,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'marca': serializeParam(
          _marca,
          ParamType.String,
        ),
        'modelo': serializeParam(
          _modelo,
          ParamType.String,
        ),
        'ano': serializeParam(
          _ano,
          ParamType.int,
        ),
        'cor': serializeParam(
          _cor,
          ParamType.String,
        ),
        'placa': serializeParam(
          _placa,
          ParamType.String,
        ),
        'fotoVeiculo': serializeParam(
          _fotoVeiculo,
          ParamType.String,
        ),
        'categoria': serializeParam(
          _categoria,
          ParamType.DocumentReference,
        ),
      }.withoutNulls;

  static VeiculoStruct fromSerializableMap(Map<String, dynamic> data) =>
      VeiculoStruct(
        marca: deserializeParam(
          data['marca'],
          ParamType.String,
          false,
        ),
        modelo: deserializeParam(
          data['modelo'],
          ParamType.String,
          false,
        ),
        ano: deserializeParam(
          data['ano'],
          ParamType.int,
          false,
        ),
        cor: deserializeParam(
          data['cor'],
          ParamType.String,
          false,
        ),
        placa: deserializeParam(
          data['placa'],
          ParamType.String,
          false,
        ),
        fotoVeiculo: deserializeParam(
          data['fotoVeiculo'],
          ParamType.String,
          false,
        ),
        categoria: deserializeParam(
          data['categoria'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['categoriasMobilidade'],
        ),
      );

  @override
  String toString() => 'VeiculoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VeiculoStruct &&
        marca == other.marca &&
        modelo == other.modelo &&
        ano == other.ano &&
        cor == other.cor &&
        placa == other.placa &&
        fotoVeiculo == other.fotoVeiculo &&
        categoria == other.categoria;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([marca, modelo, ano, cor, placa, fotoVeiculo, categoria]);
}

VeiculoStruct createVeiculoStruct({
  String? marca,
  String? modelo,
  int? ano,
  String? cor,
  String? placa,
  String? fotoVeiculo,
  DocumentReference? categoria,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    VeiculoStruct(
      marca: marca,
      modelo: modelo,
      ano: ano,
      cor: cor,
      placa: placa,
      fotoVeiculo: fotoVeiculo,
      categoria: categoria,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

VeiculoStruct? updateVeiculoStruct(
  VeiculoStruct? veiculo, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    veiculo
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addVeiculoStructData(
  Map<String, dynamic> firestoreData,
  VeiculoStruct? veiculo,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (veiculo == null) {
    return;
  }
  if (veiculo.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && veiculo.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final veiculoData = getVeiculoFirestoreData(veiculo, forFieldValue);
  final nestedData = veiculoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = veiculo.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getVeiculoFirestoreData(
  VeiculoStruct? veiculo, [
  bool forFieldValue = false,
]) {
  if (veiculo == null) {
    return {};
  }
  final firestoreData = mapToFirestore(veiculo.toMap());

  // Add any Firestore field values
  veiculo.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getVeiculoListFirestoreData(
  List<VeiculoStruct>? veiculos,
) =>
    veiculos?.map((e) => getVeiculoFirestoreData(e, true)).toList() ?? [];
