import 'package:firebase_auth/firebase_auth.dart';
import '../base_auth_user_provider.dart';

class OptionFirebaseUser extends BaseAuthUser {
  OptionFirebaseUser(this.user);
  final User? user;

  @override
  bool get loggedIn => user != null;

  @override
  bool get emailVerified => user?.emailVerified ?? false;

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(
        uid: user?.uid,
        email: user?.email,
        displayName: user?.displayName,
        photoUrl: user?.photoURL,
        phoneNumber: user?.phoneNumber,
      );

  @override
  Future<void>? delete() => user?.delete();

  @override
  Future<void>? updateEmail(String email) => user?.updateEmail(email);

  @override
  Future<void>? updatePassword(String newPassword) => user?.updatePassword(newPassword);

  @override
  Future<void>? sendEmailVerification() => user?.sendEmailVerification();

  @override
  Future refreshUser() async {
    await user?.reload();
  }
}

Stream<OptionFirebaseUser> optionFirebaseUserStream() {
  return FirebaseAuth.instance.userChanges().map((u) {
    final wrapped = OptionFirebaseUser(u);
    currentUser = wrapped;
    return wrapped;
  });
}

Stream<BaseAuthUser> authenticatedUserStream =
    optionFirebaseUserStream().map((u) => u as BaseAuthUser);

Stream<String?> jwtTokenStream =
    FirebaseAuth.instance.idTokenChanges().asyncMap((u) => u?.getIdToken());

final Stream<String?> fcmTokenUserStream = Stream<String?>.empty();