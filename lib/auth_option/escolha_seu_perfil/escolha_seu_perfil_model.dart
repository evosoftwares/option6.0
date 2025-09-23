import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import 'escolha_seu_perfil_widget.dart' show EscolhaSeuPerfilWidget;
import 'package:flutter/material.dart';
import 'dart:async';

class EscolhaSeuPerfilModel extends FlutterFlowModel<EscolhaSeuPerfilWidget> {
  /// Controle de estado para prevenir race conditions
  bool isDriverCreationInProgress = false;
  bool isPassengerCreationInProgress = false;

  /// Controle de validação de app_user
  bool isValidatingUser = false;
  bool hasValidAppUser = false;
  AppUsersRow? currentAppUser;
  Timer? _validationTimer;
  VoidCallback? updateUI;

  @override
  void initState(BuildContext context) {
    print('=== INICIALIZANDO EscolhaSeuPerfilModel ===');
    print('Estado inicial - isDriverCreationInProgress: $isDriverCreationInProgress');
    print('Estado inicial - isPassengerCreationInProgress: $isPassengerCreationInProgress');

    // Iniciar validação de app_user
    _startAppUserValidation();
  }

  @override
  void dispose() {
    print('=== DESTRUINDO EscolhaSeuPerfilModel ===');
    print('Estado final - isDriverCreationInProgress: $isDriverCreationInProgress');
    print('Estado final - isPassengerCreationInProgress: $isPassengerCreationInProgress');

    // Cancelar timer de validação
    _validationTimer?.cancel();
  }

  /// Inicia validação periódica de app_user
  void _startAppUserValidation() {
    print('🔍 [VALIDATION] Iniciando validação periódica de app_user');

    // Validação inicial
    _validateAppUser();

    // Configurar validação periódica a cada 3 segundos
    _validationTimer = Timer.periodic(Duration(seconds: 3), (_) {
      _validateAppUser();
    });
  }

  /// Valida se o usuário atual tem user_type preenchido na tabela app_users
  Future<void> _validateAppUser() async {
    if (isValidatingUser) return; // Evitar validações simultâneas

    try {
      isValidatingUser = true;
      print('🔍 [VALIDATION] Validando user_type para currentUserUid: $currentUserUid');

      if (currentUserUid.isEmpty) {
        print('⚠️ [VALIDATION] currentUserUid vazio - user_type inválido');
        hasValidAppUser = false;
        currentAppUser = null;
        return;
      }

      // Buscar por email primeiro
      List<AppUsersRow> appUsers = [];
      if (currentUserEmail.trim().isNotEmpty) {
        appUsers = await AppUsersTable().queryRows(
          queryFn: (q) => q.eq('email', currentUserEmail.trim()).limit(1),
        );
      }

      // Se não encontrou por email, buscar por Firebase UID (coluna correta)
      if (appUsers.isEmpty) {
        appUsers = await AppUsersTable().queryRows(
          queryFn: (q) => q.eq('currentUser_UID_Firebase', currentUserUid).limit(1),
        );
      }

      // Fallback legado: buscar por fcm_token igual ao Firebase UID (para compatibilidade)
      if (appUsers.isEmpty) {
        appUsers = await AppUsersTable().queryRows(
          queryFn: (q) => q.eq('fcm_token', currentUserUid).limit(1),
        );
      }

      if (appUsers.isNotEmpty) {
        currentAppUser = appUsers.first;

        // Verificar especificamente se user_type está preenchido
        String? userType = currentAppUser?.userType;
        bool isUserTypeValid = userType?.trim().isNotEmpty == true &&
                               (userType == 'driver' || userType == 'passenger');

        hasValidAppUser = isUserTypeValid;

        if (isUserTypeValid) {
          print('✅ [VALIDATION] user_type válido encontrado: $userType');
          print('🆔 [VALIDATION] app_user.id: ${currentAppUser?.id}');
        } else {
          print('❌ [VALIDATION] user_type inválido ou vazio: "$userType"');
          print('🆔 [VALIDATION] app_user existe, mas user_type não está preenchido corretamente');
        }
      } else {
        hasValidAppUser = false;
        currentAppUser = null;
        print('❌ [VALIDATION] Nenhum app_user encontrado - user_type não pode ser validado');
      }

    } catch (e) {
      print('💥 [VALIDATION] Erro ao validar app_user: $e');
      hasValidAppUser = false;
      currentAppUser = null;
    } finally {
      isValidatingUser = false;
      updateUI?.call(); // Atualizar UI se callback disponível
    }
  }

  /// Verifica se o usuário pode sair desta tela (baseado especificamente em user_type)
  bool canLeaveScreen() {
    print('🚪 [CAN_LEAVE] Verificando se pode sair da tela baseado em user_type');
    print('🚪 [CAN_LEAVE] hasValidAppUser: $hasValidAppUser');
    print('🚪 [CAN_LEAVE] currentAppUser existe: ${currentAppUser != null}');
    print('🚪 [CAN_LEAVE] user_type atual: "${currentAppUser?.userType}"');

    // Verificação específica da coluna user_type
    String? userType = currentAppUser?.userType;
    bool hasValidUserType = userType?.trim().isNotEmpty == true &&
                           (userType == 'driver' || userType == 'passenger');

    bool canLeave = hasValidAppUser &&
                    currentAppUser != null &&
                    hasValidUserType;

    print('🚪 [CAN_LEAVE] pode sair: $canLeave');
    return canLeave;
  }

  /// Para a validação periódica (usado quando perfil é criado com sucesso)
  void stopValidation() {
    print('⏹️ [VALIDATION] Parando validação periódica');
    _validationTimer?.cancel();
    _validationTimer = null;
  }

  /// Força uma revalidação imediata
  Future<void> forceValidation() async {
    print('🔄 [VALIDATION] Forçando revalidação imediata');
    await _validateAppUser();
  }
}
