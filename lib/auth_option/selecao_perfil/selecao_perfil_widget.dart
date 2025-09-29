import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelecaoPerfilWidget extends StatefulWidget {
  const SelecaoPerfilWidget({super.key});

  static String routeName = 'selecao_perfil';
  static String routePath = '/selecao-perfil';

  @override
  State<SelecaoPerfilWidget> createState() => _SelecaoPerfilWidgetState();
}

class _SelecaoPerfilWidgetState extends State<SelecaoPerfilWidget> {
  bool _isUpdating = false;

  Future<void> _selecionarPerfil(String tipo) async {
    // Comprehensive logging for profile selection event
    debugPrint('🔄 [PERFIL_SEL] Button Clicked: ${tipo == 'driver' ? 'Sou motorista' : 'Sou passageiro'}');
    debugPrint('👤 [PERFIL_SEL] Current User UID: $currentUserUid');
    debugPrint('⏰ [PERFIL_SEL] Timestamp: ${DateTime.now()}');
    debugPrint('⚙️ [PERFIL_SEL] Is Updating Status: $_isUpdating');
    
    if (_isUpdating) {
      debugPrint('❌ [PERFIL_SEL] Action blocked: Already updating profile');
      return;
    }
    
    setState(() => _isUpdating = true);
    debugPrint('🔄 [PERFIL_SEL] Updating state to: $_isUpdating');
    
    try {
      final uid = currentUserUid;
      debugPrint('👤 [PERFIL_SEL] Retrieved UID from currentUserUid: $uid');
      
      if (uid.isEmpty) {
        debugPrint('❌ [PERFIL_SEL] ERROR: User is not authenticated');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não autenticado.')),
        );
        return;
      }

      debugPrint('💾 [PERFIL_SEL] Starting database update for user: $uid');
      debugPrint('📋 [PERFIL_SEL] Setting user_type to: $tipo');
      debugPrint('📅 [PERFIL_SEL] Update timestamp: ${DateTime.now().toUtc()}');
      
      await AppUsersTable().update(
        data: {
          'user_type': tipo,
          'updated_at': DateTime.now().toUtc(),
        },
        matchingRows: (rows) => rows.eq('id', uid),
      );
      
      debugPrint('✅ [PERFIL_SEL] Database update successful for user: $uid');
      debugPrint('📋 [PERFIL_SEL] User type updated to: $tipo');
      debugPrint('➡️ [PERFIL_SEL] Redirecting to UploadFotoWidget');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tipo == 'driver' ? 'Perfil motorista selecionado.' : 'Perfil passageiro selecionado.',
          ),
        ),
      );

      context.goNamed(UploadFotoWidget.routeName);
      debugPrint('✅ [PERFIL_SEL] Navigation completed to UploadFotoWidget');
    } catch (e, stack) {
      debugPrint('❌ [PERFIL_SEL] ERROR during profile selection: $e');
      debugPrint('📋 [PERFIL_SEL] Stack trace: $stack');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar perfil. Tente novamente.')),
      );
    } finally {
      debugPrint('🔄 [PERFIL_SEL] Final: Setting _isUpdating to false');
      if (mounted) setState(() => _isUpdating = false);
      debugPrint('✅ [PERFIL_SEL] Final: State updated, _isUpdating is now: $_isUpdating');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Seleção de Perfil'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Escolha seu perfil',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              FFButtonWidget(
                onPressed: _isUpdating ? null : () => _selecionarPerfil('passenger'),
                text: _isUpdating ? 'Processando...' : 'Sou passageiro',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.black,
                  textStyle: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  elevation: 0,
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),
              FFButtonWidget(
                onPressed: _isUpdating ? null : () => _selecionarPerfil('driver'),
                text: _isUpdating ? 'Processando...' : 'Sou motorista',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.white,
                  textStyle: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  elevation: 0,
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}