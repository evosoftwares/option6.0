import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PerfilPromotorRecord extends FirestoreRecord {
  PerfilPromotorRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "lider" field.
  bool? _lider;
  bool get lider => _lider ?? false;
  bool hasLider() => _lider != null;

  // "idPromotor" field.
  String? _idPromotor;
  String get idPromotor => _idPromotor ?? '';
  bool hasIdPromotor() => _idPromotor != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "empresaId" field.
  String? _empresaId;
  String get empresaId => _empresaId ?? '';
  bool hasEmpresaId() => _empresaId != null;

  // "idUser" field.
  String? _idUser;
  String get idUser => _idUser ?? '';
  bool hasIdUser() => _idUser != null;

  // "idAgencias" field.
  List<String>? _idAgencias;
  List<String> get idAgencias => _idAgencias ?? const [];
  bool hasIdAgencias() => _idAgencias != null;

  // "status" field.
  StatusPromotor? _status;
  StatusPromotor? get status => _status;
  bool hasStatus() => _status != null;

  void _initializeFields() {
    _lider = snapshotData['lider'] as bool?;
    _idPromotor = snapshotData['idPromotor'] as String?;
    _email = snapshotData['email'] as String?;
    _empresaId = snapshotData['empresaId'] as String?;
    _idUser = snapshotData['idUser'] as String?;
    _idAgencias = getDataList(snapshotData['idAgencias']);
    _status = snapshotData['status'] is StatusPromotor
        ? snapshotData['status']
        : deserializeEnum<StatusPromotor>(snapshotData['status']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('perfilPromotor');

  static Stream<PerfilPromotorRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PerfilPromotorRecord.fromSnapshot(s));

  static Future<PerfilPromotorRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PerfilPromotorRecord.fromSnapshot(s));

  static PerfilPromotorRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PerfilPromotorRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PerfilPromotorRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PerfilPromotorRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PerfilPromotorRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PerfilPromotorRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPerfilPromotorRecordData({
  bool? lider,
  String? idPromotor,
  String? email,
  String? empresaId,
  String? idUser,
  StatusPromotor? status,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'lider': lider,
      'idPromotor': idPromotor,
      'email': email,
      'empresaId': empresaId,
      'idUser': idUser,
      'status': status,
    }.withoutNulls,
  );

  return firestoreData;
}

class PerfilPromotorRecordDocumentEquality
    implements Equality<PerfilPromotorRecord> {
  const PerfilPromotorRecordDocumentEquality();

  @override
  bool equals(PerfilPromotorRecord? e1, PerfilPromotorRecord? e2) {
    const listEquality = ListEquality();
    return e1?.lider == e2?.lider &&
        e1?.idPromotor == e2?.idPromotor &&
        e1?.email == e2?.email &&
        e1?.empresaId == e2?.empresaId &&
        e1?.idUser == e2?.idUser &&
        listEquality.equals(e1?.idAgencias, e2?.idAgencias) &&
        e1?.status == e2?.status;
  }

  @override
  int hash(PerfilPromotorRecord? e) => const ListEquality().hash([
        e?.lider,
        e?.idPromotor,
        e?.email,
        e?.empresaId,
        e?.idUser,
        e?.idAgencias,
        e?.status
      ]);

  @override
  bool isValidKey(Object? o) => o is PerfilPromotorRecord;
}
