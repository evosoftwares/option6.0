import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/supabase_auth/auth_util.dart';
import '../backend/supabase/database/tables/app_users.dart';
import '../custom_code/actions/onesignal_service_completo.dart';
import '/backend/supabase/supabase.dart';

Future alertaNegativo(
  BuildContext context, {
  String? mensagem,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensagem!,
        style: TextStyle(
          color: Color(0xFF900000),
        ),
      ),
      duration: Duration(milliseconds: 4000),
      backgroundColor: Color(0xFFFFAAAA),
    ),
  );
}

Future updateUserSupabase(BuildContext context) async {
  try {
    final currentUserId = currentUserUid;
    if (currentUserId.isEmpty) {
      print('❌ [updateUserSupabase] Usuário não autenticado');
      return;
    }

    // Buscar usuário atual no Supabase usando Firebase UID
    final userQuery = await AppUsersTable().queryRows(
      queryFn: (q) => q.eq('currentUser_UID_Firebase', currentUserId).limit(1),
    );

    if (userQuery.isNotEmpty) {
      final user = userQuery.first;
      
      // Atualizar OneSignal player ID se necessário
      try {
        final playerId = OneSignalServiceCompleto.instance.playerId;
        if (playerId != null && playerId != user.fcmToken) {
          print('🔄 [updateUserSupabase] Atualizando OneSignal player ID para usuário: ${user.id}');
          await AppUsersTable().update(
            data: {'fcm_token': playerId},
            matchingRows: (rows) => rows.eq('id', user.id),
          );
          print('✅ [updateUserSupabase] OneSignal player ID atualizado com sucesso!');
        }
      } catch (e) {
        print('⚠️ [updateUserSupabase] Erro ao atualizar OneSignal player ID: $e');
      }
    } else {
      print('⚠️ [updateUserSupabase] Usuário não encontrado no Supabase');
    }
  } catch (e) {
    print('❌ [updateUserSupabase] Erro ao atualizar usuário: $e');
  }
}

Future snackSalvo(BuildContext context, {String? mensagem}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensagem ?? 'Salvo com sucesso',
        style: GoogleFonts.roboto(
          color: Colors.white,
        ),
      ),
      duration: Duration(milliseconds: 4000),
      backgroundColor: Color(0xFF007047),
    ),
  );
}

// Snack padronizado azul (informativo)
Future snackInfoPadronizado(BuildContext context, {String? mensagem, int? durationMs}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensagem ?? 'Informação',
        style: GoogleFonts.roboto(
          color: Colors.white,
        ),
      ),
      duration: Duration(milliseconds: durationMs ?? 4000),
      backgroundColor: Colors.blue[600],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  );
}
