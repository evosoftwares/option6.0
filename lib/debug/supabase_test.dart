import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/user_id_converter.dart';

/// Classe para testar conectividade básica com Supabase
class SupabaseConnectivityTest {
  
  /// Testa conectividade básica com uma consulta simples
  static Future<Map<String, dynamic>> testBasicConnectivity() async {
    final result = <String, dynamic>{
      'success': false,
      'error': null,
      'details': {},
    };

    try {
      debugPrint('🔍 [SUPABASE_TEST] Iniciando teste de conectividade...');
      
      // Teste 1: Consulta simples na tabela trips
      final tripsQuery = await TripsTable().queryRows(
        queryFn: (q) => q.limit(1),
      );
      
      result['details']['trips_query'] = {
        'success': true,
        'count': tripsQuery.length,
      };
      debugPrint('✅ [SUPABASE_TEST] Consulta trips: ${tripsQuery.length} registros');

      // Teste 2: Consulta na tabela app_users
      final usersQuery = await AppUsersTable().queryRows(
        queryFn: (q) => q.limit(1),
      );
      
      result['details']['app_users_query'] = {
        'success': true,
        'count': usersQuery.length,
      };
      debugPrint('✅ [SUPABASE_TEST] Consulta app_users: ${usersQuery.length} registros');

      // Teste 3: Consulta na tabela passengers
      final passengersQuery = await PassengersTable().queryRows(
        queryFn: (q) => q.limit(1),
      );
      
      result['details']['passengers_query'] = {
        'success': true,
        'count': passengersQuery.length,
      };
      debugPrint('✅ [SUPABASE_TEST] Consulta passengers: ${passengersQuery.length} registros');

      result['success'] = true;
      debugPrint('🎉 [SUPABASE_TEST] Todos os testes de conectividade passaram!');
      
    } catch (e) {
      result['error'] = e.toString();
      debugPrint('❌ [SUPABASE_TEST] Erro de conectividade: $e');
    }

    return result;
  }

  /// Testa o fluxo completo de conversão Firebase UID -> app_users.id
  static Future<Map<String, dynamic>> testUserIdConversion(String firebaseUid) async {
    final result = <String, dynamic>{
      'success': false,
      'error': null,
      'firebase_uid': firebaseUid,
      'app_user_id': null,
      'user_type': null,
      'profile_found': false,
    };

    try {
      debugPrint('🔍 [USER_ID_TEST] Testando conversão para UID: $firebaseUid');
      
      // Teste 1: Conversão Firebase UID -> app_users.id
      final appUserId = await UserIdConverter.getAppUserIdFromFirebaseUid(firebaseUid);
      if (appUserId == null) {
        result['error'] = 'Firebase UID não encontrado em app_users';
        return result;
      }
      
      result['app_user_id'] = appUserId;
      debugPrint('✅ [USER_ID_TEST] app_users.id encontrado: $appUserId');

      // Teste 2: Buscar dados do usuário
      final appUserQuery = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('id', appUserId).limit(1),
      );
      
      if (appUserQuery.isEmpty) {
        result['error'] = 'Registro app_users não encontrado';
        return result;
      }

      final appUser = appUserQuery.first;
      result['user_type'] = appUser.userType;
      debugPrint('✅ [USER_ID_TEST] Tipo de usuário: ${appUser.userType}');

      // Teste 3: Verificar perfil específico
      final userType = appUser.userType?.toLowerCase();
      if (userType == 'passenger' || userType == 'passageiro') {
        final passengerQuery = await PassengersTable().queryRows(
          queryFn: (q) => q.eq('user_id', appUserId).limit(1),
        );
        result['profile_found'] = passengerQuery.isNotEmpty;
        debugPrint('✅ [USER_ID_TEST] Perfil passenger encontrado: ${passengerQuery.isNotEmpty}');
      } else if (userType == 'driver' || userType == 'motorista') {
        final driverQuery = await DriversTable().queryRows(
          queryFn: (q) => q.eq('user_id', appUserId).limit(1),
        );
        result['profile_found'] = driverQuery.isNotEmpty;
        debugPrint('✅ [USER_ID_TEST] Perfil driver encontrado: ${driverQuery.isNotEmpty}');
      }

      result['success'] = true;
      debugPrint('🎉 [USER_ID_TEST] Teste de conversão concluído com sucesso!');
      
    } catch (e) {
      result['error'] = e.toString();
      debugPrint('❌ [USER_ID_TEST] Erro no teste: $e');
    }

    return result;
  }
}