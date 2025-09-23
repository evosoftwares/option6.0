import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "cpf_Cnpj" field.
  String? _cpfCnpj;
  String get cpfCnpj => _cpfCnpj ?? '';
  bool hasCpfCnpj() => _cpfCnpj != null;

  // "chave_pix" field.
  String? _chavePix;
  String get chavePix => _chavePix ?? '';
  bool hasChavePix() => _chavePix != null;

  // "meusIndicados" field.
  List<String>? _meusIndicados;
  List<String> get meusIndicados => _meusIndicados ?? const [];
  bool hasMeusIndicados() => _meusIndicados != null;

  // "tipoChave" field.
  String? _tipoChave;
  String get tipoChave => _tipoChave ?? '';
  bool hasTipoChave() => _tipoChave != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "enderecoPessoal" field.
  EnderecoPessoalStruct? _enderecoPessoal;
  EnderecoPessoalStruct get enderecoPessoal =>
      _enderecoPessoal ?? EnderecoPessoalStruct();
  bool hasEnderecoPessoal() => _enderecoPessoal != null;

  // "papeisUsuario" field.
  List<Permissao>? _papeisUsuario;
  List<Permissao> get papeisUsuario => _papeisUsuario ?? const [];
  bool hasPapeisUsuario() => _papeisUsuario != null;

  // "idViagem" field.
  DocumentReference? _idViagem;
  DocumentReference? get idViagem => _idViagem;
  bool hasIdViagem() => _idViagem != null;

  // "notificacaoPendente" field.
  bool? _notificacaoPendente;
  bool get notificacaoPendente => _notificacaoPendente ?? false;
  bool hasNotificacaoPendente() => _notificacaoPendente != null;

  // "notificaoViagem" field.
  bool? _notificaoViagem;
  bool get notificaoViagem => _notificaoViagem ?? false;
  bool hasNotificaoViagem() => _notificaoViagem != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _uid = snapshotData['uid'] as String?;
    _cpfCnpj = snapshotData['cpf_Cnpj'] as String?;
    _chavePix = snapshotData['chave_pix'] as String?;
    _meusIndicados = getDataList(snapshotData['meusIndicados']);
    _tipoChave = snapshotData['tipoChave'] as String?;
    _status = snapshotData['status'] as String?;
    _enderecoPessoal = snapshotData['enderecoPessoal'] is EnderecoPessoalStruct
        ? snapshotData['enderecoPessoal']
        : EnderecoPessoalStruct.maybeFromMap(snapshotData['enderecoPessoal']);
    _papeisUsuario = getEnumList<Permissao>(snapshotData['papeisUsuario']);
    _idViagem = snapshotData['idViagem'] as DocumentReference?;
    _notificacaoPendente = snapshotData['notificacaoPendente'] as bool?;
    _notificaoViagem = snapshotData['notificaoViagem'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  DateTime? createdTime,
  String? phoneNumber,
  String? uid,
  String? cpfCnpj,
  String? chavePix,
  String? tipoChave,
  String? status,
  EnderecoPessoalStruct? enderecoPessoal,
  DocumentReference? idViagem,
  bool? notificacaoPendente,
  bool? notificaoViagem,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'uid': uid,
      'cpf_Cnpj': cpfCnpj,
      'chave_pix': chavePix,
      'tipoChave': tipoChave,
      'status': status,
      'enderecoPessoal': EnderecoPessoalStruct().toMap(),
      'idViagem': idViagem,
      'notificacaoPendente': notificacaoPendente,
      'notificaoViagem': notificaoViagem,
    }.withoutNulls,
  );

  // Handle nested data for "enderecoPessoal" field.
  addEnderecoPessoalStructData(
      firestoreData, enderecoPessoal, 'enderecoPessoal');

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.uid == e2?.uid &&
        e1?.cpfCnpj == e2?.cpfCnpj &&
        e1?.chavePix == e2?.chavePix &&
        listEquality.equals(e1?.meusIndicados, e2?.meusIndicados) &&
        e1?.tipoChave == e2?.tipoChave &&
        e1?.status == e2?.status &&
        e1?.enderecoPessoal == e2?.enderecoPessoal &&
        listEquality.equals(e1?.papeisUsuario, e2?.papeisUsuario) &&
        e1?.idViagem == e2?.idViagem &&
        e1?.notificacaoPendente == e2?.notificacaoPendente &&
        e1?.notificaoViagem == e2?.notificaoViagem;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.createdTime,
        e?.phoneNumber,
        e?.uid,
        e?.cpfCnpj,
        e?.chavePix,
        e?.meusIndicados,
        e?.tipoChave,
        e?.status,
        e?.enderecoPessoal,
        e?.papeisUsuario,
        e?.idViagem,
        e?.notificacaoPendente,
        e?.notificaoViagem
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
