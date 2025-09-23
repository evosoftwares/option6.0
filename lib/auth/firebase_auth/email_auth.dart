import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential?> emailSignInFunc(
  String email,
  String password,
) =>
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.trim(), password: password);

Future<UserCredential?> emailCreateAccountFunc(
  String email,
  String password,
) async {
  try {
    print('emailCreateAccountFunc: Iniciando criação de conta');
    print('emailCreateAccountFunc: Email: $email');
    print('emailCreateAccountFunc: Senha length: ${password.length}');

    final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    print('emailCreateAccountFunc: Conta criada com sucesso: ${result.user?.uid}');
    return result;
  } catch (e) {
    print('emailCreateAccountFunc: Erro ao criar conta: $e');
    rethrow;
  }
}
