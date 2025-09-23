import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConversasRecord extends FirestoreRecord {
  ConversasRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "quemLeu" field.
  List<DocumentReference>? _quemLeu;
  List<DocumentReference> get quemLeu => _quemLeu ?? const [];
  bool hasQuemLeu() => _quemLeu != null;

  // "participantes" field.
  List<DocumentReference>? _participantes;
  List<DocumentReference> get participantes => _participantes ?? const [];
  bool hasParticipantes() => _participantes != null;

  // "ultimaMensagem" field.
  DocumentReference? _ultimaMensagem;
  DocumentReference? get ultimaMensagem => _ultimaMensagem;
  bool hasUltimaMensagem() => _ultimaMensagem != null;

  // "conversaId" field.
  String? _conversaId;
  String get conversaId => _conversaId ?? '';
  bool hasConversaId() => _conversaId != null;

  // "statusConversa" field.
  StatusConversaPeloStatusServico? _statusConversa;
  StatusConversaPeloStatusServico? get statusConversa => _statusConversa;
  bool hasStatusConversa() => _statusConversa != null;

  void _initializeFields() {
    _quemLeu = getDataList(snapshotData['quemLeu']);
    _participantes = getDataList(snapshotData['participantes']);
    _ultimaMensagem = snapshotData['ultimaMensagem'] as DocumentReference?;
    _conversaId = snapshotData['conversaId'] as String?;
    _statusConversa =
        snapshotData['statusConversa'] is StatusConversaPeloStatusServico
            ? snapshotData['statusConversa']
            : deserializeEnum<StatusConversaPeloStatusServico>(
                snapshotData['statusConversa']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Conversas');

  static Stream<ConversasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ConversasRecord.fromSnapshot(s));

  static Future<ConversasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ConversasRecord.fromSnapshot(s));

  static ConversasRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ConversasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ConversasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ConversasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ConversasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ConversasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createConversasRecordData({
  DocumentReference? ultimaMensagem,
  String? conversaId,
  StatusConversaPeloStatusServico? statusConversa,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'ultimaMensagem': ultimaMensagem,
      'conversaId': conversaId,
      'statusConversa': statusConversa,
    }.withoutNulls,
  );

  return firestoreData;
}

class ConversasRecordDocumentEquality implements Equality<ConversasRecord> {
  const ConversasRecordDocumentEquality();

  @override
  bool equals(ConversasRecord? e1, ConversasRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.quemLeu, e2?.quemLeu) &&
        listEquality.equals(e1?.participantes, e2?.participantes) &&
        e1?.ultimaMensagem == e2?.ultimaMensagem &&
        e1?.conversaId == e2?.conversaId &&
        e1?.statusConversa == e2?.statusConversa;
  }

  @override
  int hash(ConversasRecord? e) => const ListEquality().hash([
        e?.quemLeu,
        e?.participantes,
        e?.ultimaMensagem,
        e?.conversaId,
        e?.statusConversa
      ]);

  @override
  bool isValidKey(Object? o) => o is ConversasRecord;
}
