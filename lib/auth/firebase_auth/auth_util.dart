import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:rxdart/rxdart.dart';

import '../auth_manager.dart' as base;
import '../base_auth_user_provider.dart' as auth_base;
import '../../backend/supabase/supabase.dart';

// --- Exports for compatibility ---
export '../base_auth_user_provider.dart' show loggedIn, BaseAuthUser;

// --- User Wrapper and Stream (Firebase based) ---

auth_base.BaseAuthUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;

class OptionAuthUser extends auth_base.BaseAuthUser {
  OptionAuthUser(this.user);
  final fb_auth.User? user;

  @override
  bool get loggedIn => user != null;

  @override
  String get uid => user?.uid ?? '';

  @override
  String get email => user?.email ?? '';

  @override
  bool get emailVerified => user?.emailVerified ?? false;
  
  @override
  auth_base.AuthUserInfo get authUserInfo => auth_base.AuthUserInfo(
        uid: user?.uid,
        email: user?.email,
        displayName: user?.displayName,
        photoUrl: user?.photoURL,
        phoneNumber: user?.phoneNumber,
      );

  @override
  Future? delete() => user?.delete();

  @override
  Future? updateEmail(String email) => user?.updateEmail(email);

  @override
  Future? updatePassword(String newPassword) => user?.updatePassword(newPassword);

  @override
  Future? sendEmailVerification() => user?.sendEmailVerification();

  @override
  Future refreshUser() async => await user?.reload();
}

Stream<auth_base.BaseAuthUser> optionFirebaseUserStream() {
  final userStream = fb_auth.FirebaseAuth.instance
      .authStateChanges()
      .debounce((user) => user == null && !loggedIn
          ? TimerStream(true, const Duration(seconds: 1))
          : Stream.value(user))
      .map<auth_base.BaseAuthUser>((user) {
    currentUser = OptionAuthUser(user);
    return currentUser!;
  });
  return userStream;
}

// Compat: mantém o nome esperado em partes do app que escutam mudanças de usuário
Stream<auth_base.BaseAuthUser> authenticatedUserStream = optionFirebaseUserStream();

// --- Auth Manager for Login (and other base methods) ---

class FirebaseAuthManager implements base.AuthManager, base.EmailSignInManager {
  @override
  Future<auth_base.BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final userCredential =
          await fb_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return OptionAuthUser(userCredential.user);
    } on fb_auth.FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Ocorreu um erro.')),
      );
      return null;
    }
  }

  @override
  Future<auth_base.BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) {
    // This is part of the mixin, but we use the standalone function below
    // for registration because we need to pass `fullName`.
    throw UnimplementedError(
        'Use the standalone createAccountWithEmail function for registration.');
  }

  @override
  Future signOut() async {
    await fb_auth.FirebaseAuth.instance.signOut();
  }

  @override
  Future deleteUser(BuildContext context) async {
    try {
      await currentUser?.delete();
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Sessão expirada. Faça login novamente antes de deletar a conta.')),
        );
      }
    }
  }

  @override
  Future resetPassword(
      {required String email, required BuildContext context}) async {
    try {
      await fb_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail de redefinição de senha enviado.')),
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Ocorreu um erro.')),
      );
    }
  }

  @override
  Future sendEmailVerification() => currentUser?.sendEmailVerification() ?? Future.value();

  @override
  Future updateEmail({required String email, required BuildContext context}) async {
    await currentUser?.updateEmail(email);
  }

  @override
  Future refreshUser() async => await currentUser?.refreshUser();
}

final FirebaseAuthManager authManager = FirebaseAuthManager();

// --- Standalone Registration Function ---

Future<auth_base.BaseAuthUser?> createAccountWithEmail(
  BuildContext context, {
  required String email,
  required String password,
  required String fullName,
}) async {
  fb_auth.UserCredential userCredential;
  try {
    userCredential =
        await fb_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on fb_auth.FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'Ocorreu um erro no cadastro.')),
    );
    return null;
  }

  final firebaseUser = userCredential.user;
  if (firebaseUser == null) {
    return null;
  }

  try {
    await SupaFlow.client.from('app_users').insert({
      'currentUser_UID_Firebase': firebaseUser.uid,
      'email': email,
      'full_name': fullName,
      'status': 'active',
      'profile_complete': false,
    });
  } catch (e) {
    debugPrint('CRITICAL: Failed to create Supabase app_user record. Rolling back Firebase user. Error: $e');
    await firebaseUser.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao criar perfil de usuário. Tente novamente.')),
    );
    return null;
  }

  if (fullName.isNotEmpty) {
    await firebaseUser.updateDisplayName(fullName);
  }

  return OptionAuthUser(firebaseUser);
}

// --- Global Helper Properties ---
String get currentUserUid => currentUser?.uid ?? '';
String get currentUserEmail => currentUser?.email ?? '';