import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'supabase_auth_manager.dart';

export '../../../auth/base_auth_user_provider.dart';

class SupabaseUserProvider extends ChangeNotifier {
  final SupabaseAuthManager _authManager = SupabaseAuthManager.instance;
  
  BaseAuthUser? get currentUser => _authManager.currentUser;
  bool get loggedIn => _authManager.loggedIn;
  
  SupabaseUserProvider() {
    _authManager.userStream.listen((user) {
      notifyListeners();
    });
  }
  
  static SupabaseUserProvider of(BuildContext context) {
    return Provider.of<SupabaseUserProvider>(context, listen: false);
  }
}

class SupabaseUser extends BaseAuthUser {
  final AuthUserInfo _authUserInfo;
  final bool _loggedIn;
  final bool _emailVerified;

  SupabaseUser({
    required AuthUserInfo authUserInfo,
    required bool loggedIn,
    required bool emailVerified,
  }) : _authUserInfo = authUserInfo,
       _loggedIn = loggedIn,
       _emailVerified = emailVerified;

  @override
  bool get loggedIn => _loggedIn;

  @override
  bool get emailVerified => _emailVerified;

  @override
  AuthUserInfo get authUserInfo => _authUserInfo;

  @override
  Future? delete() async {
    // Implementar se necessário
    return null;
  }

  @override
  Future? sendEmailVerification() async {
    // Supabase envia verificação automaticamente no cadastro
    return null;
  }

  @override
  Future? updateEmail(String email) async {
    // Implementar se necessário
    return null;
  }

  @override
  Future? updatePassword(String password) async {
    // Implementar se necessário
    return null;
  }
}