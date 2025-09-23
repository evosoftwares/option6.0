import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PerfisEmpresaRecord extends FirestoreRecord {
  PerfisEmpresaRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idUsuario" field.
  DocumentReference? _idUsuario;
  DocumentReference? get idUsuario => _idUsuario;
  bool hasIdUsuario() => _idUsuario != null;

  // "razaoSocial" field.
  String? _razaoSocial;
  String get razaoSocial => _razaoSocial ?? '';
  bool hasRazaoSocial() => _razaoSocial != null;

  // "nomeFantasia" field.
  String? _nomeFantasia;
  String get nomeFantasia => _nomeFantasia ?? '';
  bool hasNomeFantasia() => _nomeFantasia != null;

  // "enderecoComercial" field.
  EnderecoComercialStruct? _enderecoComercial;
  EnderecoComercialStruct get enderecoComercial =>
      _enderecoComercial ?? EnderecoComercialStruct();
  bool hasEnderecoComercial() => _enderecoComercial != null;

  // "responsavel" field.
  ResponsavelStruct? _responsavel;
  ResponsavelStruct get responsavel => _responsavel ?? ResponsavelStruct();
  bool hasResponsavel() => _responsavel != null;

  // "cnpj" field.
  String? _cnpj;
  String get cnpj => _cnpj ?? '';
  bool hasCnpj() => _cnpj != null;

  // "emailResponsavel" field.
  String? _emailResponsavel;
  String get emailResponsavel => _emailResponsavel ?? '';
  bool hasEmailResponsavel() => _emailResponsavel != null;

  // "idEmpresa" field.
  String? _idEmpresa;
  String get idEmpresa => _idEmpresa ?? '';
  bool hasIdEmpresa() => _idEmpresa != null;

  // "quantasMarcas" field.
  int? _quantasMarcas;
  int get quantasMarcas => _quantasMarcas ?? 0;
  bool hasQuantasMarcas() => _quantasMarcas != null;

  void _initializeFields() {
    _idUsuario = snapshotData['idUsuario'] as DocumentReference?;
    _razaoSocial = snapshotData['razaoSocial'] as String?;
    _nomeFantasia = snapshotData['nomeFantasia'] as String?;
    _enderecoComercial =
        snapshotData['enderecoComercial'] is EnderecoComercialStruct
            ? snapshotData['enderecoComercial']
            : EnderecoComercialStruct.maybeFromMap(
                snapshotData['enderecoComercial']);
    _responsavel = snapshotData['responsavel'] is ResponsavelStruct
        ? snapshotData['responsavel']
        : ResponsavelStruct.maybeFromMap(snapshotData['responsavel']);
    _cnpj = snapshotData['cnpj'] as String?;
    _emailResponsavel = snapshotData['emailResponsavel'] as String?;
    _idEmpresa = snapshotData['idEmpresa'] as String?;
    _quantasMarcas = castToType<int>(snapshotData['quantasMarcas']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('perfisEmpresa');

  static Stream<PerfisEmpresaRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PerfisEmpresaRecord.fromSnapshot(s));

  static Future<PerfisEmpresaRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PerfisEmpresaRecord.fromSnapshot(s));

  static PerfisEmpresaRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PerfisEmpresaRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PerfisEmpresaRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PerfisEmpresaRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PerfisEmpresaRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PerfisEmpresaRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPerfisEmpresaRecordData({
  DocumentReference? idUsuario,
  String? razaoSocial,
  String? nomeFantasia,
  EnderecoComercialStruct? enderecoComercial,
  ResponsavelStruct? responsavel,
  String? cnpj,
  String? emailResponsavel,
  String? idEmpresa,
  int? quantasMarcas,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idUsuario': idUsuario,
      'razaoSocial': razaoSocial,
      'nomeFantasia': nomeFantasia,
      'enderecoComercial': EnderecoComercialStruct().toMap(),
      'responsavel': ResponsavelStruct().toMap(),
      'cnpj': cnpj,
      'emailResponsavel': emailResponsavel,
      'idEmpresa': idEmpresa,
      'quantasMarcas': quantasMarcas,
    }.withoutNulls,
  );

  // Handle nested data for "enderecoComercial" field.
  addEnderecoComercialStructData(
      firestoreData, enderecoComercial, 'enderecoComercial');

  // Handle nested data for "responsavel" field.
  addResponsavelStructData(firestoreData, responsavel, 'responsavel');

  return firestoreData;
}

class PerfisEmpresaRecordDocumentEquality
    implements Equality<PerfisEmpresaRecord> {
  const PerfisEmpresaRecordDocumentEquality();

  @override
  bool equals(PerfisEmpresaRecord? e1, PerfisEmpresaRecord? e2) {
    return e1?.idUsuario == e2?.idUsuario &&
        e1?.razaoSocial == e2?.razaoSocial &&
        e1?.nomeFantasia == e2?.nomeFantasia &&
        e1?.enderecoComercial == e2?.enderecoComercial &&
        e1?.responsavel == e2?.responsavel &&
        e1?.cnpj == e2?.cnpj &&
        e1?.emailResponsavel == e2?.emailResponsavel &&
        e1?.idEmpresa == e2?.idEmpresa &&
        e1?.quantasMarcas == e2?.quantasMarcas;
  }

  @override
  int hash(PerfisEmpresaRecord? e) => const ListEquality().hash([
        e?.idUsuario,
        e?.razaoSocial,
        e?.nomeFantasia,
        e?.enderecoComercial,
        e?.responsavel,
        e?.cnpj,
        e?.emailResponsavel,
        e?.idEmpresa,
        e?.quantasMarcas
      ]);

  @override
  bool isValidKey(Object? o) => o is PerfisEmpresaRecord;
}
