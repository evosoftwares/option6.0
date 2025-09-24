import '/auth/firebase_auth/auth_util.dart';
import '/custom_code/actions/fcm_service_completo.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/supabase/supabase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Realiza logout seguro do usuário
/// Limpa todos os tokens de autenticação, FCM tokens e dados locais
/// Redireciona para a tela de login
Future<Map<String, dynamic>> logoutSeguro(BuildContext context) async {
  try {
    print('🚪 Iniciando logout seguro...');
    
    final currentUserId = currentUserUid;
    
    // 1. DESABILITAR FCM E LIMPAR TOKENS
    if (currentUserId.isNotEmpty) {
      print('🔕 Desabilitando FCM e limpando tokens...');
      
      try {
        // Desabilitar FCM Service
        await FCMServiceCompleto.instance.desabilitarFCM();
        
        // Marcar dispositivos como inativos no Supabase
        final devices = await UserDevicesTable().queryRows(
          queryFn: (q) => q.eq('user_id', currentUserId).eq('is_active', true),
        );
        
        for (var device in devices) {
          await UserDevicesTable().update(
            data: {
              'is_active': false,
              'logged_out_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            },
            matchingRows: (rows) => rows.eq('id', device.id),
          );
        }
        
        // Limpar FCM token da tabela drivers
        final driverQuery = await DriversTable().queryRows(
          queryFn: (q) => q.eq('user_id', currentUserId),
        );
        
        if (driverQuery.isNotEmpty) {
          await DriversTable().update(
            data: {
              'fcm_token': null,
              'is_online': false,
              'updated_at': DateTime.now().toIso8601String(),
            },
            matchingRows: (rows) => rows.eq('user_id', currentUserId),
          );
        }
        
        // Limpar FCM token da tabela app_users
        await AppUsersTable().update(
          data: {
            'fcm_token': null,
            'last_logout': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
          matchingRows: (rows) => rows.eq('currentUser_UID_Firebase', currentUserId),
        );
        
        print('✅ Tokens FCM limpos do Supabase');
      } catch (e) {
        print('⚠️ Erro ao limpar tokens FCM: $e');
        // Continua com o logout mesmo se houver erro na limpeza dos tokens
      }
    }
    
    // 2. LIMPAR DADOS LOCAIS
    print('🧹 Limpando dados locais...');
    
    try {
      // Limpar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Limpar FlutterSecureStorage (exceto configurações do app)
      const secureStorage = FlutterSecureStorage();
      
      // Manter apenas configurações essenciais do app
      final supabaseUrl = await secureStorage.read(key: 'ff_supabaseUrl');
      final supabaseKey = await secureStorage.read(key: 'ff_supabaseAnnonkey');
      
      // Limpar tudo
      await secureStorage.deleteAll();
      
      // Restaurar configurações essenciais
      if (supabaseUrl != null) {
        await secureStorage.write(key: 'ff_supabaseUrl', value: supabaseUrl);
      }
      if (supabaseKey != null) {
        await secureStorage.write(key: 'ff_supabaseAnnonkey', value: supabaseKey);
      }
      
      print('✅ Dados locais limpos');
    } catch (e) {
      print('⚠️ Erro ao limpar dados locais: $e');
      // Continua com o logout mesmo se houver erro na limpeza local
    }
    
    // 3. PREPARAR EVENTO DE AUTENTICAÇÃO
    print('🔄 Preparando logout do Firebase...');
    GoRouter.of(context).prepareAuthEvent();
    
    // 4. FAZER LOGOUT DO FIREBASE
    await authManager.signOut();
    print('✅ Logout do Firebase realizado');
    
    // 5. LIMPAR REDIRECIONAMENTOS
    GoRouter.of(context).clearRedirectLocation();
    
    // 6. REDIRECIONAR PARA LOGIN
    print('🏠 Redirecionando para login...');
    
    if (context.mounted) {
      context.goNamedAuth('login', context.mounted);
    }
    
    print('✅ Logout seguro concluído com sucesso');
    
    return {
      'sucesso': true,
      'mensagem': 'Logout realizado com sucesso',
      'timestamp': DateTime.now().toIso8601String(),
    };
    
  } catch (e) {
    print('❌ Erro durante logout seguro: $e');
    
    // Mesmo com erro, tentar fazer logout básico do Firebase
    try {
      GoRouter.of(context).prepareAuthEvent();
      await authManager.signOut();
      GoRouter.of(context).clearRedirectLocation();
      
      if (context.mounted) {
        context.goNamedAuth('login', context.mounted);
      }
    } catch (fallbackError) {
      print('❌ Erro no logout de fallback: $fallbackError');
    }
    
    return {
      'sucesso': false,
      'erro': 'Erro durante logout: ${e.toString()}',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

/// Verifica se o usuário está realmente deslogado
Future<bool> verificarStatusLogout() async {
  try {
    // Verificar se não há usuário autenticado
    final isLoggedOut = !loggedIn;
    
    // Verificar se FCM está desabilitado
    final fcmDesabilitado = !FCMServiceCompleto.instance.isInitialized;
    
    // Verificar se não há token FCM ativo
    final semTokenFCM = FCMServiceCompleto.instance.tokenFCM == null;
    
    final logoutCompleto = isLoggedOut && fcmDesabilitado && semTokenFCM;
    
    print('📊 Status do logout:');
    print('   - Usuário deslogado: $isLoggedOut');
    print('   - FCM desabilitado: $fcmDesabilitado');
    print('   - Sem token FCM: $semTokenFCM');
    print('   - Logout completo: $logoutCompleto');
    
    return logoutCompleto;
  } catch (e) {
    print('❌ Erro ao verificar status do logout: $e');
    return false;
  }
}

/// Força logout em caso de emergência (sem limpeza de dados)
Future<void> forceLogout(BuildContext context) async {
  try {
    print('🚨 Executando logout forçado...');
    
    GoRouter.of(context).prepareAuthEvent();
    await authManager.signOut();
    GoRouter.of(context).clearRedirectLocation();
    
    if (context.mounted) {
      context.goNamedAuth('login', context.mounted);
    }
    
    print('✅ Logout forçado concluído');
  } catch (e) {
    print('❌ Erro no logout forçado: $e');
    // Em último caso, navegar diretamente para login
    if (context.mounted) {
      context.go('/login');
    }
  }
}