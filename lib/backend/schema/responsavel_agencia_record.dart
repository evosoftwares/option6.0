import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ResponsavelAgenciaRecord extends FirestoreRecord {
  ResponsavelAgenciaRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  bool hasNome() => _nome != null;

  // "idUsuario" field.
  DocumentReference? _idUsuario;
  DocumentReference? get idUsuario => _idUsuario;
  bool hasIdUsuario() => _idUsuario != null;

  // "conversaId" field.
  DocumentReference? _conversaId;
  DocumentReference? get conversaId => _conversaId;
  bool hasConversaId() => _conversaId != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _idUsuario = snapshotData['idUsuario'] as DocumentReference?;
    _conversaId = snapshotData['conversaId'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('responsavelAgencia');

  static Stream<ResponsavelAgenciaRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ResponsavelAgenciaRecord.fromSnapshot(s));

  static Future<ResponsavelAgenciaRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ResponsavelAgenciaRecord.fromSnapshot(s));

  static ResponsavelAgenciaRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ResponsavelAgenciaRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ResponsavelAgenciaRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ResponsavelAgenciaRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ResponsavelAgenciaRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ResponsavelAgenciaRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createResponsavelAgenciaRecordData({
  String? nome,
  DocumentReference? idUsuario,
  DocumentReference? conversaId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'idUsuario': idUsuario,
      'conversaId': conversaId,
    }.withoutNulls,
  );

  return firestoreData;
}

class ResponsavelAgenciaRecordDocumentEquality
    implements Equality<ResponsavelAgenciaRecord> {
  const ResponsavelAgenciaRecordDocumentEquality();

  @override
  bool equals(ResponsavelAgenciaRecord? e1, ResponsavelAgenciaRecord? e2) {
    return e1?.nome == e2?.nome &&
        e1?.idUsuario == e2?.idUsuario &&
        e1?.conversaId == e2?.conversaId;
  }

  @override
  int hash(ResponsavelAgenciaRecord? e) =>
      const ListEquality().hash([e?.nome, e?.idUsuario, e?.conversaId]);

  @override
  bool isValidKey(Object? o) => o is ResponsavelAgenciaRecord;
}
