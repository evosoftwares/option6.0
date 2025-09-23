import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MensagensRecord extends FirestoreRecord {
  MensagensRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "mensagem" field.
  String? _mensagem;
  String get mensagem => _mensagem ?? '';
  bool hasMensagem() => _mensagem != null;

  // "conversaID" field.
  DocumentReference? _conversaID;
  DocumentReference? get conversaID => _conversaID;
  bool hasConversaID() => _conversaID != null;

  // "enviadoPor" field.
  DocumentReference? _enviadoPor;
  DocumentReference? get enviadoPor => _enviadoPor;
  bool hasEnviadoPor() => _enviadoPor != null;

  // "mensagensId" field.
  String? _mensagensId;
  String get mensagensId => _mensagensId ?? '';
  bool hasMensagensId() => _mensagensId != null;

  // "fotoChat" field.
  String? _fotoChat;
  String get fotoChat => _fotoChat ?? '';
  bool hasFotoChat() => _fotoChat != null;

  // "ehMensagem" field.
  bool? _ehMensagem;
  bool get ehMensagem => _ehMensagem ?? false;
  bool hasEhMensagem() => _ehMensagem != null;

  void _initializeFields() {
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _mensagem = snapshotData['mensagem'] as String?;
    _conversaID = snapshotData['conversaID'] as DocumentReference?;
    _enviadoPor = snapshotData['enviadoPor'] as DocumentReference?;
    _mensagensId = snapshotData['mensagensId'] as String?;
    _fotoChat = snapshotData['fotoChat'] as String?;
    _ehMensagem = snapshotData['ehMensagem'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Mensagens');

  static Stream<MensagensRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MensagensRecord.fromSnapshot(s));

  static Future<MensagensRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MensagensRecord.fromSnapshot(s));

  static MensagensRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MensagensRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MensagensRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MensagensRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MensagensRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MensagensRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMensagensRecordData({
  DateTime? createdAt,
  String? mensagem,
  DocumentReference? conversaID,
  DocumentReference? enviadoPor,
  String? mensagensId,
  String? fotoChat,
  bool? ehMensagem,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'createdAt': createdAt,
      'mensagem': mensagem,
      'conversaID': conversaID,
      'enviadoPor': enviadoPor,
      'mensagensId': mensagensId,
      'fotoChat': fotoChat,
      'ehMensagem': ehMensagem,
    }.withoutNulls,
  );

  return firestoreData;
}

class MensagensRecordDocumentEquality implements Equality<MensagensRecord> {
  const MensagensRecordDocumentEquality();

  @override
  bool equals(MensagensRecord? e1, MensagensRecord? e2) {
    return e1?.createdAt == e2?.createdAt &&
        e1?.mensagem == e2?.mensagem &&
        e1?.conversaID == e2?.conversaID &&
        e1?.enviadoPor == e2?.enviadoPor &&
        e1?.mensagensId == e2?.mensagensId &&
        e1?.fotoChat == e2?.fotoChat &&
        e1?.ehMensagem == e2?.ehMensagem;
  }

  @override
  int hash(MensagensRecord? e) => const ListEquality().hash([
        e?.createdAt,
        e?.mensagem,
        e?.conversaID,
        e?.enviadoPor,
        e?.mensagensId,
        e?.fotoChat,
        e?.ehMensagem
      ]);

  @override
  bool isValidKey(Object? o) => o is MensagensRecord;
}
