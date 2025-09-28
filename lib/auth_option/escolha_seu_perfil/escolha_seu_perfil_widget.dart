import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart' hide loggedIn;
import '/custom_code/actions/onesignal_service_completo.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'escolha_seu_perfil_model.dart';
export 'escolha_seu_perfil_model.dart';
import 'dart:async';

class EscolhaSeuPerfilWidget extends StatefulWidget {
  const EscolhaSeuPerfilWidget({super.key});

  static String routeName = 'escolhaSeuPerfil';
  static String routePath = '/escolhaSeuPerfil';

  @override
  State<EscolhaSeuPerfilWidget> createState() => _EscolhaSeuPerfilWidgetState();
}

class _EscolhaSeuPerfilWidgetState extends State<EscolhaSeuPerfilWidget> {
  late EscolhaSeuPerfilModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print('📱 [INIT] ====== INICIANDO TELA ESCOLHA SEU PERFIL ======');
    print('🔑 [INIT] currentUserUid: $currentUserUid');
    print('📧 [INIT] currentUserEmail: $currentUserEmail');
    print('👤 [INIT] currentUserDisplayName: $currentUserDisplayName');
    print('🔐 [INIT] isLoggedIn: ${loggedIn}');
    print('⏰ [INIT] Timestamp inicialização: ${DateTime.now()}');
    _model = createModel(context, () => EscolhaSeuPerfilModel());
    print('✅ [INIT] Model criado com sucesso');
  }

  @override
  void dispose() {
    print('🗑️ [DISPOSE] ====== LIMPANDO TELA ESCOLHA SEU PERFIL ======');
    print('⏰ [DISPOSE] Timestamp dispose: ${DateTime.now()}');
    _model.dispose();
    print('✅ [DISPOSE] Model disposed com sucesso');
    super.dispose();
    print('✅ [DISPOSE] Dispose completo');
  }

  // Widget helper para mensagens informativas padronizadas
  Widget _buildInfoMessage({
    required IconData icon,
    required String message,
    required Color color,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: 8),
            trailing,
          ],
        ],
      ),
    );
  }

  // Widget para mostrar o estado de validação do usuário
  Widget _buildValidationMessage() {
    if (_model.isValidatingUser) {
      return _buildInfoMessage(
        icon: Icons.refresh,
        message: 'Verificando informações...',
        color: Colors.blue,
        trailing: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    } else if (_model.hasValidAppUser && _model.currentAppUser != null) {
      return _buildInfoMessage(
        icon: Icons.check_circle,
        message:
            'Perfil definido: ${_model.currentAppUser?.userType == 'driver' ? 'Motorista' : _model.currentAppUser?.userType == 'passenger' ? 'Passageiro' : 'Inválido'}',
        color: Colors.green,
      );
    } else if (_model.currentAppUser != null && !_model.hasValidAppUser) {
      return _buildInfoMessage(
        icon: Icons.info_outline,
        message:
            'Olá! Para continuar, preciso saber como você quer usar o app. Escolha uma das opções abaixo:',
        color: Colors.blue,
      );
    } else {
      final msg = _model.lastValidationError?.contains('Failed host lookup') ==
              true
          ? 'Sem conexão com o servidor. Escolha um perfil para criarmos quando a conexão voltar.'
          : 'Escolha uma das opções abaixo para começar:';
      return _buildInfoMessage(
        icon: Icons.info_outline,
        message: msg,
        color: Colors.blue,
      );
    }
  }

  // Widget helper para SnackBars informativos padronizados
  void _showInfoSnackBar(String message, {Color? backgroundColor}) {
    _showSnackBar(
        message, Icons.info_outline, backgroundColor ?? Colors.blue[600]!);
  }

  // Widget helper para SnackBars de erro
  void _showErrorSnackBar(String message) {
    _showSnackBar(message, Icons.error_outline, Colors.red[600]!);
  }

  // Widget helper para SnackBars de aviso
  void _showWarningSnackBar(String message) {
    _showSnackBar(message, Icons.warning_amber_outlined, Colors.orange[600]!);
  }

  // Base helper para SnackBars padronizados
  void _showSnackBar(String message, IconData icon, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  /// Busca ou cria um app_user de forma robusta
  Future<AppUsersRow> _getOrCreateAppUser(String userType) async {
    final transactionId = DateTime.now().millisecondsSinceEpoch.toString();
    final startTimestamp = DateTime.now();

    print(
        '🔍 [GET_OR_CREATE_USER][TXN:$transactionId] ====== INICIANDO TRANSAÇÃO ======');
    print(
        '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] START_TIME: ${startTimestamp.toIso8601String()}');
    print(
        '🆔 [GET_OR_CREATE_USER][TXN:$transactionId] TRANSACTION_ID: $transactionId');
    print('👥 [GET_OR_CREATE_USER][TXN:$transactionId] userType: $userType');
    print(
        '🔑 [GET_OR_CREATE_USER][TXN:$transactionId] currentUserUid: $currentUserUid');
    print(
        '📧 [GET_OR_CREATE_USER][TXN:$transactionId] currentUserEmail: $currentUserEmail');
    print(
        '👤 [GET_OR_CREATE_USER][TXN:$transactionId] currentUserDisplayName: $currentUserDisplayName');
    print(
        '🔌 [GET_OR_CREATE_USER][TXN:$transactionId] Supabase Client Hash: ${SupaFlow.client.hashCode}');

    try {
      // PHASE 1: Buscar por EMAIL primeiro
      final phase1Start = DateTime.now();
      print(
          '📊 [GET_OR_CREATE_USER][TXN:$transactionId] ===== PHASE 1: EMAIL LOOKUP =====');
      print(
          '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE1_START: ${phase1Start.toIso8601String()}');

      if (currentUserEmail.trim().isNotEmpty) {
        print(
            '🔍 [GET_OR_CREATE_USER][TXN:$transactionId] Iniciando busca por EMAIL...');
        print(
            '📧 [GET_OR_CREATE_USER][TXN:$transactionId] Email alvo: "$currentUserEmail"');

        final emailQueryStart = DateTime.now();
        print(
            '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] EMAIL_QUERY_START: ${emailQueryStart.toIso8601String()}');

        final byEmailPrim = await AppUsersTable().queryRows(
          queryFn: (q) => q.eq('email', currentUserEmail).limit(1),
        );

        final emailQueryEnd = DateTime.now();
        final emailQueryDuration = emailQueryEnd.difference(emailQueryStart);
        print(
            '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] EMAIL_QUERY_END: ${emailQueryEnd.toIso8601String()}');
        print(
            '⚡ [GET_OR_CREATE_USER][TXN:$transactionId] EMAIL_QUERY_DURATION: ${emailQueryDuration.inMilliseconds}ms');
        print(
            '📊 [GET_OR_CREATE_USER][TXN:$transactionId] EMAIL_RESULTS_COUNT: ${byEmailPrim.length}');

        if (byEmailPrim.isNotEmpty) {
          final existingUser = byEmailPrim.first;
          // Garantir que user_type seja atualizado de acordo com a seleção atual
          final currentType = (existingUser.userType ?? '').trim();
          final desiredType = userType.trim();
          if (currentType != desiredType) {
            print(
                '🔄 [GET_OR_CREATE_USER][TXN:$transactionId] Atualizando user_type de "$currentType" para "$desiredType" para usuário: ${existingUser.id}');
            await AppUsersTable().update(
              data: {'user_type': desiredType},
              matchingRows: (rows) => rows.eq('id', existingUser.id),
            );
            print(
                '✅ [GET_OR_CREATE_USER][TXN:$transactionId] user_type atualizado com sucesso!');
          }

          // HÍBRIDO: tentar atualizar mapeamentos de identidade
          try {
            final supabaseUserId = SupaFlow.client.auth.currentUser?.id;
            final updates = <String, dynamic>{};
            if ((existingUser.email ?? '').isNotEmpty && (existingUser.userType ?? '').isNotEmpty) {
              // Garantir que Firebase UID esteja persistido
              if ((existingUser.currentUserUidFirebase ?? '').isEmpty && currentUserUid.trim().isNotEmpty) {
                updates['currentUser_UID_Firebase'] = currentUserUid.trim();
              }
            }
            if (supabaseUserId != null && supabaseUserId.isNotEmpty) {
              // Atualiza coluna híbrida se existir no esquema
              updates['auth_user_id'] = supabaseUserId;
            }
            if (updates.isNotEmpty) {
              print('🧭 [GET_OR_CREATE_USER][TXN:$transactionId] Atualizando mapeamentos híbridos: ${updates.keys.join(', ')}');
              await AppUsersTable().update(
                data: updates,
                matchingRows: (rows) => rows.eq('id', existingUser.id),
              );
              print('✅ [GET_OR_CREATE_USER][TXN:$transactionId] Mapeamentos híbridos atualizados com sucesso.');
            } else {
              print('ℹ️ [GET_OR_CREATE_USER][TXN:$transactionId] Nenhum mapeamento híbrido necessário para este usuário.');
            }
          } catch (e) {
            print('⚠️ [GET_OR_CREATE_USER][TXN:$transactionId] Falha ao atualizar mapeamentos híbridos (tabela sem coluna auth_user_id? sessão supabase ausente?): $e');
          }

          final phase1End = DateTime.now();
          final phase1Duration = phase1End.difference(phase1Start);
          print(
              '✅ [GET_OR_CREATE_USER][TXN:$transactionId] SUCESSO: Usuário encontrado por EMAIL!');
          print(
              '🆔 [GET_OR_CREATE_USER][TXN:$transactionId] USER_ID_FOUND: ${existingUser.id}');
          print(
              '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE1_END: ${phase1End.toIso8601String()}');
          print(
              '⚡ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE1_DURATION: ${phase1Duration.inMilliseconds}ms');
          print(
              '🏁 [GET_OR_CREATE_USER][TXN:$transactionId] RETORNANDO USER POR EMAIL');
          return existingUser;
        } else {
          print(
              '⚠️ [GET_OR_CREATE_USER][TXN:$transactionId] Nenhum usuário encontrado por EMAIL: "$currentUserEmail"');
        }
      } else {
        print(
            '⚠️ [GET_OR_CREATE_USER][TXN:$transactionId] Email vazio - pulando busca por EMAIL');
      }

      final phase1End = DateTime.now();
      final phase1Duration = phase1End.difference(phase1Start);
      print(
          '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE1_END: ${phase1End.toIso8601String()}');
      print(
          '⚡ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE1_DURATION: ${phase1Duration.inMilliseconds}ms');
      // PHASE 2: Buscar por Firebase UID (fallback)
      final phase2Start = DateTime.now();
      print(
          '📊 [GET_OR_CREATE_USER][TXN:$transactionId] ===== PHASE 2: FIREBASE UID LOOKUP =====');
      print(
          '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE2_START: ${phase2Start.toIso8601String()}');
      print(
          '📡 [GET_OR_CREATE_USER][TXN:$transactionId] Conectando com Supabase...');
      print('🎯 [GET_OR_CREATE_USER][TXN:$transactionId] Tabela: app_users');
      print(
          '🔍 [GET_OR_CREATE_USER][TXN:$transactionId] Query: SELECT * FROM app_users WHERE "currentUser_UID_Firebase" = \'$currentUserUid\' LIMIT 1');
      print('📊 [GET_OR_CREATE_USER][TXN:$transactionId] Parâmetros:');
      print('   - currentUser_UID_Firebase: "$currentUserUid"');
      print('   - limit: 1');
      print(
          '🔌 [GET_OR_CREATE_USER][TXN:$transactionId] Connection Hash: ${SupaFlow.client.hashCode}');
      print(
          '⏳ [GET_OR_CREATE_USER][TXN:$transactionId] Executando query Supabase...');

      final firebaseUidQueryStartTime = DateTime.now();
      print(
          '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] FIREBASE_UID_QUERY_START: ${firebaseUidQueryStartTime.toIso8601String()}');

      final byFirebaseUid = await AppUsersTable().queryRows(
        queryFn: (q) =>
            q.eq('currentUser_UID_Firebase', currentUserUid).limit(1),
      );

      final firebaseUidQueryEndTime = DateTime.now();
      final firebaseUidQueryDuration =
          firebaseUidQueryEndTime.difference(firebaseUidQueryStartTime);
      print(
          '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] FIREBASE_UID_QUERY_END: ${firebaseUidQueryEndTime.toIso8601String()}');
      print(
          '⚡ [GET_OR_CREATE_USER][TXN:$transactionId] FIREBASE_UID_QUERY_DURATION: ${firebaseUidQueryDuration.inMilliseconds}ms');
      print(
          '📊 [GET_OR_CREATE_USER][TXN:$transactionId] FIREBASE_UID_RESULTS_COUNT: ${byFirebaseUid.length}');
      print(
          '🔍 [GET_OR_CREATE_USER][TXN:$transactionId] FIREBASE_UID_RESULT_TYPE: ${byFirebaseUid.runtimeType}');

      if (byFirebaseUid.isNotEmpty) {
        final existingUser = byFirebaseUid.first;
        // Garantir que user_type seja atualizado de acordo com a seleção atual
        final currentType = (existingUser.userType ?? '').trim();
        final desiredType = userType.trim();
        if (currentType != desiredType) {
          print(
              '🔄 [GET_OR_CREATE_USER][TXN:$transactionId] Atualizando user_type de "$currentType" para "$desiredType" para usuário: ${existingUser.id}');
          await AppUsersTable().update(
            data: {'user_type': desiredType},
            matchingRows: (rows) => rows.eq('id', existingUser.id),
          );
          print(
              '✅ [GET_OR_CREATE_USER][TXN:$transactionId] user_type atualizado com sucesso!');
        }

        // HÍBRIDO: tentar atualizar mapeamentos de identidade
        try {
          final supabaseUserId = SupaFlow.client.auth.currentUser?.id;
          final updates = <String, dynamic>{};
          if ((existingUser.currentUserUidFirebase ?? '').isEmpty && currentUserUid.trim().isNotEmpty) {
            updates['currentUser_UID_Firebase'] = currentUserUid.trim();
          }
          if (supabaseUserId != null && supabaseUserId.isNotEmpty) {
            updates['auth_user_id'] = supabaseUserId;
          }
          if (updates.isNotEmpty) {
            print('🧭 [GET_OR_CREATE_USER][TXN:$transactionId] Atualizando mapeamentos híbridos: ${updates.keys.join(', ')}');
            await AppUsersTable().update(
              data: updates,
              matchingRows: (rows) => rows.eq('id', existingUser.id),
            );
            print('✅ [GET_OR_CREATE_USER][TXN:$transactionId] Mapeamentos híbridos atualizados com sucesso.');
          } else {
            print('ℹ️ [GET_OR_CREATE_USER][TXN:$transactionId] Nenhum mapeamento híbrido necessário para este usuário.');
          }
        } catch (e) {
          print('⚠️ [GET_OR_CREATE_USER][TXN:$transactionId] Falha ao atualizar mapeamentos híbridos (tabela sem coluna auth_user_id? sessão supabase ausente?): $e');
        }

        final phase2End = DateTime.now();
        final phase2Duration = phase2End.difference(phase2Start);
        print(
            '✅ [GET_OR_CREATE_USER][TXN:$transactionId] SUCESSO: Usuário encontrado por Firebase UID!');
        print(
            '🆔 [GET_OR_CREATE_USER][TXN:$transactionId] USER_ID_FOUND: ${existingUser.id}');
        print(
            '📧 [GET_OR_CREATE_USER][TXN:$transactionId] USER_EMAIL: ${existingUser.email}');
        print(
            '👥 [GET_OR_CREATE_USER][TXN:$transactionId] USER_TYPE: ${existingUser.userType}');
        print(
            '✅ [GET_OR_CREATE_USER][TXN:$transactionId] USER_STATUS: ${existingUser.status}');
        print(
            '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] USER_CREATED_AT: ${existingUser.createdAt}');
        print(
            '🔄 [GET_OR_CREATE_USER][TXN:$transactionId] USER_UPDATED_AT: ${existingUser.updatedAt}');
        print(
            '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE2_END: ${phase2End.toIso8601String()}');
        print(
            '⚡ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE2_DURATION: ${phase2Duration.inMilliseconds}ms');
        print(
            '🏁 [GET_OR_CREATE_USER][TXN:$transactionId] RETORNANDO USER POR FIREBASE UID');
        return existingUser;
      } else {
        print(
            '⚠️ [GET_OR_CREATE_USER][TXN:$transactionId] Firebase UID query retornou lista vazia');
        print(
            '🔍 [GET_OR_CREATE_USER][TXN:$transactionId] Nenhum usuário encontrado com Firebase UID: "$currentUserUid"');
      }

      final phase2End = DateTime.now();
      final phase2Duration = phase2End.difference(phase2Start);
      print(
          '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE2_END: ${phase2End.toIso8601String()}');
      print(
          '⚡ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE2_DURATION: ${phase2Duration.inMilliseconds}ms');

      // PHASE 3: Criação de novo usuário
      final phase3Start = DateTime.now();
      print(
          '📊 [GET_OR_CREATE_USER][TXN:$transactionId] ===== PHASE 3: USER CREATION =====');
      print(
          '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE3_START: ${phase3Start.toIso8601String()}');
      print(
          '⚠️ [GET_OR_CREATE_USER][TXN:$transactionId] Usuário não encontrado - iniciando criação');
      print(
          '📡 [GET_OR_CREATE_USER][TXN:$transactionId] Preparando inserção no Supabase...');
      print('🎯 [GET_OR_CREATE_USER][TXN:$transactionId] Tabela: app_users');
      print(
          '🔌 [GET_OR_CREATE_USER][TXN:$transactionId] Connection Hash: ${SupaFlow.client.hashCode}');

      // Obter o FCM token real do serviço
      String? realFcmToken;
      try {
        realFcmToken = OneSignalServiceCompleto.instance.playerId;
        print(
            '📱 [GET_OR_CREATE_USER][TXN:$transactionId] FCM Token obtido: ${realFcmToken?.substring(0, 20)}...');
      } catch (e) {
        print(
            '⚠️ [GET_OR_CREATE_USER][TXN:$transactionId] Erro ao obter FCM token: $e');
        realFcmToken = null;
      }

      final newUserData = {
        'email': currentUserEmail,
        'full_name': currentUserDisplayName,
        'phone': '',
        'photo_url': '',
        'user_type': userType,
        'status': 'active',
        'fcm_token': realFcmToken, // FCM token real para push notifications
        'device_id': '',
        'device_platform': '',
        'profile_complete': false,
        'onesignal_player_id': '',
        'currentUser_UID_Firebase':
            currentUserUid, // Firebase UID único e permanente
      };

      print(
          '📝 [GET_OR_CREATE_USER] ===== DADOS PARA INSERÇÃO NO SUPABASE =====');
      print('📧 [GET_OR_CREATE_USER] email: "${newUserData['email']}"');
      print('👤 [GET_OR_CREATE_USER] full_name: "${newUserData['full_name']}"');
      print('📞 [GET_OR_CREATE_USER] phone: "${newUserData['phone']}"');
      print(
          '🖼️ [GET_OR_CREATE_USER] photo_url: "${newUserData['photo_url']}"');
      print('👥 [GET_OR_CREATE_USER] user_type: "${newUserData['user_type']}"');
      print('✅ [GET_OR_CREATE_USER] status: "${newUserData['status']}"');
      print('📱 [GET_OR_CREATE_USER] fcm_token: "${newUserData['fcm_token']}"');
      print('📱 [GET_OR_CREATE_USER] device_id: "${newUserData['device_id']}"');
      print(
          '🌍 [GET_OR_CREATE_USER] device_platform: "${newUserData['device_platform']}"');
      print(
          '🎯 [GET_OR_CREATE_USER] profile_complete: ${newUserData['profile_complete']}');
      print(
          '🔔 [GET_OR_CREATE_USER] onesignal_player_id: "${newUserData['onesignal_player_id']}"');
      print('📊 [GET_OR_CREATE_USER] Total de campos: ${newUserData.length}');
      print(
          '🔍 [GET_OR_CREATE_USER] SQL equivalente: INSERT INTO app_users (${newUserData.keys.join(', ')}) VALUES (...)');
      print(
          '⏳ [GET_OR_CREATE_USER][TXN:$transactionId] Executando INSERT no Supabase...');

      final insertStartTime = DateTime.now();
      print(
          '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] INSERT_START: ${insertStartTime.toIso8601String()}');
      print(
          '🔌 [GET_OR_CREATE_USER][TXN:$transactionId] Pre-Insert Connection Hash: ${SupaFlow.client.hashCode}');

      final newUser = await AppUsersTable().insert(newUserData);

      final insertEndTime = DateTime.now();
      final insertDuration = insertEndTime.difference(insertStartTime);
      print(
          '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] INSERT_END: ${insertEndTime.toIso8601String()}');
      print(
          '⚡ [GET_OR_CREATE_USER][TXN:$transactionId] INSERT_DURATION: ${insertDuration.inMilliseconds}ms');
      print(
          '📊 [GET_OR_CREATE_USER][TXN:$transactionId] INSERT_RESULT: SUCESSO');
      print(
          '🔍 [GET_OR_CREATE_USER][TXN:$transactionId] INSERT_RETURN_TYPE: ${newUser.runtimeType}');
      print(
          '🔌 [GET_OR_CREATE_USER][TXN:$transactionId] Post-Insert Connection Hash: ${SupaFlow.client.hashCode}');

      // O currentUser_UID_Firebase já foi definido corretamente na inserção
      print(
          '✅ [GET_OR_CREATE_USER][TXN:$transactionId] currentUser_UID_Firebase já configurado: ${currentUserUid}');

      final phase3End = DateTime.now();
      final phase3Duration = phase3End.difference(phase3Start);
      final totalDuration = phase3End.difference(startTimestamp);

      print(
          '✅ [GET_OR_CREATE_USER][TXN:$transactionId] USUÁRIO CRIADO COM SUCESSO!');
      print(
          '🆔 [GET_OR_CREATE_USER][TXN:$transactionId] NEW_USER_ID: ${newUser.id}');
      print(
          '📧 [GET_OR_CREATE_USER][TXN:$transactionId] NEW_USER_EMAIL: ${newUser.email}');
      print(
          '👥 [GET_OR_CREATE_USER][TXN:$transactionId] NEW_USER_TYPE: ${newUser.userType}');
      print(
          '⏰ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE3_END: ${phase3End.toIso8601String()}');
      print(
          '⚡ [GET_OR_CREATE_USER][TXN:$transactionId] PHASE3_DURATION: ${phase3Duration.inMilliseconds}ms');
      print(
          '⚡ [GET_OR_CREATE_USER][TXN:$transactionId] TOTAL_TRANSACTION_DURATION: ${totalDuration.inMilliseconds}ms');
      print(
          '🏁 [GET_OR_CREATE_USER][TXN:$transactionId] ====== TRANSAÇÃO FINALIZADA COM SUCESSO ======');

      return newUser;
    } catch (e, st) {
      print('❌ [GET_OR_CREATE_USER][TXN:$transactionId] ERRO: $e');
      print('🧵 [GET_OR_CREATE_USER][TXN:$transactionId] STACK: $st');
      rethrow;
    }
  }

  /// Cria perfil de passageiro no Supabase
  Future<String?> _createPassengerProfile(String appUserId) async {
    final transactionId =
        DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    print(
        '🚀 [CREATE_PASSENGER][TXN:$transactionId] ====== INICIANDO CRIAÇÃO DE PERFIL DE PASSAGEIRO ======');
    print(
        '🆔 [CREATE_PASSENGER][TXN:$transactionId] app_user_id: "$appUserId"');
    print(
        '⏰ [CREATE_PASSENGER][TXN:$transactionId] Timestamp: ${DateTime.now().toIso8601String()}');

    try {
      // Buscar dados do app_user para obter email
      print(
          '🔍 [CREATE_PASSENGER][TXN:$transactionId] Buscando dados do app_user...');
      final appUserQuery = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('id', appUserId).limit(1),
      );

      if (appUserQuery.isEmpty) {
        print(
            '❌ [CREATE_PASSENGER][TXN:$transactionId] app_user não encontrado com id: $appUserId');
        return null;
      }

      final appUser = appUserQuery.first;
      print(
          '✅ [CREATE_PASSENGER][TXN:$transactionId] app_user encontrado: ${appUser.email}');

      // Verificar se já existe passenger para este user_id
      print(
          '🔍 [CREATE_PASSENGER][TXN:$transactionId] Verificando se passenger já existe...');
      final existingPassenger = await PassengersTable().queryRows(
        queryFn: (q) => q.eq('user_id', appUserId).limit(1),
      );

      if (existingPassenger.isNotEmpty) {
        print(
            '✅ [CREATE_PASSENGER][TXN:$transactionId] Passenger já existe: ${existingPassenger.first.id}');
        return existingPassenger.first.id;
      }

      // Criar novo passenger
      print(
          '📝 [CREATE_PASSENGER][TXN:$transactionId] Criando novo passenger...');

      // Convert string UUID to proper UUID format for Supabase
      final userIdUuid =
          appUserId; // Already a UUID string from UserIdConverter

      final passengerData = {
        'user_id': userIdUuid, // UUID do app_user (proper format)
        'email': appUser.email,
        'consecutive_cancellations': 0,
        'total_trips': 0,
        'average_rating': 5.0, // Changed from 0.0 to 5.0 to match logs
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      print('🔍 [CREATE_PASSENGER][TXN:$transactionId] UUID validation:');
      print('   - appUserId type: ${appUserId.runtimeType}');
      print('   - appUserId value: "$appUserId"');
      print(
          '   - UUID format check: ${RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$').hasMatch(appUserId)}');

      print('📊 [CREATE_PASSENGER][TXN:$transactionId] Dados para inserção:');
      passengerData.forEach((key, value) => print('   - $key: $value'));

      // Try direct Supabase client with explicit UUID casting
      late PassengersRow newPassenger;
      try {
        print(
            '🔄 [CREATE_PASSENGER][TXN:$transactionId] Tentativa com casting UUID explícito...');
        final result = await SupaFlow.client
            .from('passengers')
            .insert({
              'user_id': appUserId, // Let Supabase handle the UUID conversion
              'email': appUser.email,
              'consecutive_cancellations': 0,
              'total_trips': 0,
              'average_rating': 5.0,
            })
            .select()
            .single();

        newPassenger = PassengersRow(result);
        print(
            '✅ [CREATE_PASSENGER][TXN:$transactionId] Passenger criado com sucesso via client direto!');
      } catch (directError) {
        print(
            '⚠️ [CREATE_PASSENGER][TXN:$transactionId] Erro com client direto: $directError');
        print(
            '🔄 [CREATE_PASSENGER][TXN:$transactionId] Tentando com PassengersTable()...');
        newPassenger = await PassengersTable().insert(passengerData);
      }

      print(
          '✅ [CREATE_PASSENGER][TXN:$transactionId] Passenger criado com sucesso!');
      print(
          '🆔 [CREATE_PASSENGER][TXN:$transactionId] passenger.id: ${newPassenger.id}');
      print(
          '🔗 [CREATE_PASSENGER][TXN:$transactionId] passenger.user_id: ${newPassenger.userId}');
      print(
          '📧 [CREATE_PASSENGER][TXN:$transactionId] passenger.email: ${newPassenger.email}');
      print(
          '🏁 [CREATE_PASSENGER][TXN:$transactionId] ====== CRIAÇÃO FINALIZADA COM SUCESSO ======');

      return newPassenger.id;
    } catch (e, stackTrace) {
      print(
          '💥 [CREATE_PASSENGER][TXN:$transactionId] ====== ERRO NA CRIAÇÃO ======');
      print('❌ [CREATE_PASSENGER][TXN:$transactionId] Erro: $e');
      print('🔍 [CREATE_PASSENGER][TXN:$transactionId] Tipo: ${e.runtimeType}');
      print('📍 [CREATE_PASSENGER][TXN:$transactionId] Stack: $stackTrace');
      print(
          '🏁 [CREATE_PASSENGER][TXN:$transactionId] ====== CRIAÇÃO FINALIZADA COM ERRO ======');

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 [BUILD] ====== CONSTRUINDO UI ESCOLHA SEU PERFIL ======');
    print('🔑 [BUILD] currentUserUid: $currentUserUid');
    print('📧 [BUILD] currentUserEmail: $currentUserEmail');
    print('👤 [BUILD] currentUserDisplayName: $currentUserDisplayName');
    print('⏰ [BUILD] Timestamp build: ${DateTime.now()}');

    return PopScope(
      canPop: _model.canLeaveScreen(),
      onPopInvokedWithResult: (didPop, result) {
        print('🔙 [WILL_POP] Tentativa de sair da tela interceptada');

        // Verificar se pode sair da tela
        if (!_model.canLeaveScreen()) {
          print('🚫 [WILL_POP] Navegação bloqueada - app_user não válido');
          print('📊 [WILL_POP] hasValidAppUser: ${_model.hasValidAppUser}');
          print('👤 [WILL_POP] currentAppUser: ${_model.currentAppUser?.id}');

          _showInfoSnackBar(
            'Por favor, escolha seu perfil (Motorista ou Passageiro) para continuar.',
          );
        } else {
          print('✅ [WILL_POP] app_user válido - permitindo navegação');
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              buttonSize: 40.0,
              icon: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                print('⬅️ [NAVEGACAO] ====== BOTÃO VOLTAR PRESSIONADO ======');
                print('⏰ [NAVEGACAO] Timestamp: ${DateTime.now()}');

                // Verificar se pode sair da tela
                if (!_model.canLeaveScreen()) {
                  print(
                      '🚫 [NAVEGACAO] Navegação bloqueada - app_user não válido');
                  print(
                      '📊 [NAVEGACAO] hasValidAppUser: ${_model.hasValidAppUser}');
                  print(
                      '👤 [NAVEGACAO] currentAppUser: ${_model.currentAppUser?.id}');

                  _showInfoSnackBar(
                    'Para continuar, escolha como você quer usar o app: como Motorista ou como Passageiro.',
                  );
                  return;
                }

                print('✅ [NAVEGACAO] app_user válido - permitindo navegação');
                print('📍 [NAVEGACAO] Executando context.safePop()...');
                context.safePop();
                print('✅ [NAVEGACAO] Navegação de volta executada');
              },
            ),
            title: Text(
              'Escolha seu perfil',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
            ),
            actions: [],
            centerTitle: false,
            elevation: 1.0,
          ),
          body: SafeArea(
            top: true,
            child: Container(
              decoration: BoxDecoration(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatefulBuilder(
                      builder: (context, setValidationState) {
                        // Armazenar referência para atualizar UI
                        _model.updateUI = () => setValidationState(() {});

                        return SingleChildScrollView(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Indicador de validação de app_user usando widget padronizado
                            _buildValidationMessage(),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                // Garante que apenas uma operação ocorra por vez
                                if (_model.isDriverCreationInProgress ||
                                    _model.isPassengerCreationInProgress) {
                                  _showWarningSnackBar(
                                      'Aguarde o processo atual terminar.');
                                  return;
                                }
                                safeSetState(() =>
                                    _model.isDriverCreationInProgress = true);

                                print(
                                    '🚀 [MOTORISTA] INICIANDO PROCESSO DE CRIAÇÃO DE PERFIL');

                                try {
                                  // 1. Busca ou cria o registro principal do usuário em 'app_users'
                                  final appUser =
                                      await _getOrCreateAppUser('driver');

                                  // 2. A criação do perfil em 'drivers' é tratada por um trigger no Supabase (conforme seu código original)

                                  // 3. Cria a carteira digital INTERNA do motorista
                                  print(
                                      '💰 [MOTORISTA] Criando carteira digital do motorista (driver_wallets)...');
                                  // Buscar o driver_id a partir do user_id (trigger pode demorar um pouco)
                                  String driverId;
                                  final drivers = await DriversTable().queryRows(
                                    queryFn: (q) => q.eq('user_id', appUser.id).limit(1),
                                  );
                                  if (drivers.isEmpty) {
                                    await Future.delayed(const Duration(milliseconds: 500));
                                    final retryDrivers = await DriversTable().queryRows(
                                      queryFn: (q) => q.eq('user_id', appUser.id).limit(1),
                                    );
                                    if (retryDrivers.isEmpty) {
                                      throw Exception('Driver não encontrado para user_id: ${appUser.id}');
                                    }
                                    driverId = retryDrivers.first.id;
                                  } else {
                                    driverId = drivers.first.id;
                                  }

                                  // Verificar existência de carteira antes de inserir
                                  print('🔎 [MOTORISTA] Verificando existência de driver_wallet para driver_id=$driverId');
                                  final existingDriverWallet = await DriverWalletsTable().queryRows(
                                    queryFn: (q) => q.eq('driver_id', driverId).limit(1),
                                  );
                                  if (existingDriverWallet.isNotEmpty) {
                                    print('ℹ️ [MOTORISTA] Carteira já existe para driver_id=$driverId. Pulando criação.');
                                  } else {
                                    await DriverWalletsTable().insert({
                                      'driver_id': driverId,
                                      'email': appUser.email,
                                      'available_balance': 0,
                                      'pending_balance': 0,
                                      'total_earned': 0,
                                      'total_withdrawn': 0,
                                    });
                                    print('✅ [MOTORISTA] Carteira digital do motorista criada!');
                                  }
                                  // 4. Finaliza o fluxo e navega para a próxima tela
                                  _model.stopValidation();
                                  _model.hasValidAppUser = true;
                                  _model.currentAppUser = appUser;
                                  context.pushNamed(
                                      CadastroSucessoWidget.routeName);
                                } catch (e) {
                                  print(
                                      '💥 [MOTORISTA] EXCEÇÃO CRÍTICA CAPTURADA: $e');
                                  _showErrorSnackBar(
                                      'Ocorreu um erro ao criar seu perfil: $e');
                                } finally {
                                  safeSetState(() => _model
                                      .isDriverCreationInProgress = false);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 16.0, 16.0, 16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 48.0,
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                          color:
                                              _model.isDriverCreationInProgress
                                                  ? FlutterFlowTheme.of(context)
                                                      .primary
                                                      .withValues(alpha: 0.1)
                                                  : Color(0xFFE1E1E1),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: _model.isDriverCreationInProgress
                                            ? SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                Icons.directions_car,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 24.0,
                                              ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _model.isDriverCreationInProgress
                                                  ? 'Criando perfil de motorista...'
                                                  : 'Sou Motorista',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleMedium
                                                  .override(
                                                    font: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                            Text(
                                              _model.isDriverCreationInProgress
                                                  ? 'Aguarde, configurando seu perfil...'
                                                  : 'Dirija e ganhe dinheiro',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                            ),
                                          ].divide(SizedBox(height: 4.0)),
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                // Garante que apenas uma operação ocorra por vez
                                if (_model.isPassengerCreationInProgress ||
                                    _model.isDriverCreationInProgress) {
                                  _showWarningSnackBar(
                                      'Aguarde o processo atual terminar.');
                                  return;
                                }
                                safeSetState(() => _model
                                    .isPassengerCreationInProgress = true);

                                print(
                                    '🚀 [PASSAGEIRO] INICIANDO CRIAÇÃO DE PERFIL E CARTEIRA INTERNA');

                                try {
                                  // Validações críticas de autenticação do usuário
                                  if (currentUserUid.isEmpty ||
                                      currentUserEmail.isEmpty ||
                                      !loggedIn) {
                                    throw Exception(
                                        'Dados de autenticação inválidos. Faça login novamente.');
                                  }

                                  // 1. Busca ou cria o registro principal do usuário em 'app_users'
                                  final appUser =
                                      await _getOrCreateAppUser('passenger');

                                  // 2. Cria o perfil específico de passageiro em 'passengers'
                                  final passengerId =
                                      await _createPassengerProfile(appUser.id);
                                  if (passengerId == null) {
                                    throw Exception(
                                        'Falha ao criar o registro na tabela passengers.');
                                  }

                                  // 3. Cria a carteira digital INTERNA do passageiro
                                  print(
                                      '💳 [PASSAGEIRO] Criando registro em passenger_wallets...');

                                  // Verificar existência de carteira antes de inserir
                                  print('🔎 [PASSAGEIRO] Verificando existência de passenger_wallet para passenger_id=$passengerId');
                                  final existingPassengerWallet = await PassengerWalletsTable().queryRows(
                                    queryFn: (q) => q.eq('passenger_id', passengerId).limit(1),
                                  );
                                  if (existingPassengerWallet.isNotEmpty) {
                                    print('ℹ️ [PASSAGEIRO] Carteira já existe para passenger_id=$passengerId. Pulando criação.');
                                  } else {
                                    await PassengerWalletsTable().insert({
                                      'passenger_id': passengerId,
                                      'user_id': appUser.id,
                                      'email': appUser.email,
                                      'available_balance': 0,
                                      'pending_balance': 0,
                                    });
                                    print(
                                        '✅ [PASSAGEIRO] Carteira interna criada com sucesso!');
                                  }

                                  // 4. Finaliza o fluxo e navega para a próxima tela
                                  _model.stopValidation();
                                  _model.hasValidAppUser = true;
                                  _model.currentAppUser = appUser;
                                  context.pushNamed(
                                      CadastroSucessoWidget.routeName);
                                } catch (e) {
                                  print(
                                      '💥 [PASSAGEIRO] EXCEÇÃO CRÍTICA CAPTURADA: $e');
                                  _showErrorSnackBar(
                                      'Ocorreu um erro ao criar seu perfil: $e');
                                } finally {
                                  safeSetState(() => _model
                                      .isPassengerCreationInProgress = false);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 16.0, 16.0, 16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 48.0,
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                          color: _model
                                                  .isPassengerCreationInProgress
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                                  .withValues(alpha: 0.1)
                                              : Color(0xFFE1E1E1),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: _model
                                                .isPassengerCreationInProgress
                                            ? SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                Icons.person,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 24.0,
                                              ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _model.isPassengerCreationInProgress
                                                  ? 'Criando perfil de passageiro...'
                                                  : 'Sou Passageiro',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleMedium
                                                  .override(
                                                    font: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                            Text(
                                              _model.isPassengerCreationInProgress
                                                  ? 'Aguarde, configurando seu perfil...'
                                                  : 'Solicite uma viagem',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                            ),
                                          ].divide(SizedBox(height: 4.0)),
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ));
                      },
                    ),
                    Container(),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: Text(
                          'Ao continuar, você concorda com nossos Termos e Condições.',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                        ),
                      ),
                    ),
                  ].divide(SizedBox(height: 24.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
