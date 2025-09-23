import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ContratosEmpresaPrestadorRecord extends FirestoreRecord {
  ContratosEmpresaPrestadorRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idEmpresa" field.
  DocumentReference? _idEmpresa;
  DocumentReference? get idEmpresa => _idEmpresa;
  bool hasIdEmpresa() => _idEmpresa != null;

  // "idPrestador" field.
  DocumentReference? _idPrestador;
  DocumentReference? get idPrestador => _idPrestador;
  bool hasIdPrestador() => _idPrestador != null;

  // "status" field.
  StatuscontratosEmpresaPrestador? _status;
  StatuscontratosEmpresaPrestador? get status => _status;
  bool hasStatus() => _status != null;

  // "criadoEm" field.
  DateTime? _criadoEm;
  DateTime? get criadoEm => _criadoEm;
  bool hasCriadoEm() => _criadoEm != null;

  void _initializeFields() {
    _idEmpresa = snapshotData['idEmpresa'] as DocumentReference?;
    _idPrestador = snapshotData['idPrestador'] as DocumentReference?;
    _status = snapshotData['status'] is StatuscontratosEmpresaPrestador
        ? snapshotData['status']
        : deserializeEnum<StatuscontratosEmpresaPrestador>(
            snapshotData['status']);
    _criadoEm = snapshotData['criadoEm'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('contratosEmpresaPrestador');

  static Stream<ContratosEmpresaPrestadorRecord> getDocument(
          DocumentReference ref) =>
      ref
          .snapshots()
          .map((s) => ContratosEmpresaPrestadorRecord.fromSnapshot(s));

  static Future<ContratosEmpresaPrestadorRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ContratosEmpresaPrestadorRecord.fromSnapshot(s));

  static ContratosEmpresaPrestadorRecord fromSnapshot(
          DocumentSnapshot snapshot) =>
      ContratosEmpresaPrestadorRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ContratosEmpresaPrestadorRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ContratosEmpresaPrestadorRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ContratosEmpresaPrestadorRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ContratosEmpresaPrestadorRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createContratosEmpresaPrestadorRecordData({
  DocumentReference? idEmpresa,
  DocumentReference? idPrestador,
  StatuscontratosEmpresaPrestador? status,
  DateTime? criadoEm,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idEmpresa': idEmpresa,
      'idPrestador': idPrestador,
      'status': status,
      'criadoEm': criadoEm,
    }.withoutNulls,
  );

  return firestoreData;
}

class ContratosEmpresaPrestadorRecordDocumentEquality
    implements Equality<ContratosEmpresaPrestadorRecord> {
  const ContratosEmpresaPrestadorRecordDocumentEquality();

  @override
  bool equals(ContratosEmpresaPrestadorRecord? e1,
      ContratosEmpresaPrestadorRecord? e2) {
    return e1?.idEmpresa == e2?.idEmpresa &&
        e1?.idPrestador == e2?.idPrestador &&
        e1?.status == e2?.status &&
        e1?.criadoEm == e2?.criadoEm;
  }

  @override
  int hash(ContratosEmpresaPrestadorRecord? e) => const ListEquality()
      .hash([e?.idEmpresa, e?.idPrestador, e?.status, e?.criadoEm]);

  @override
  bool isValidKey(Object? o) => o is ContratosEmpresaPrestadorRecord;
}
