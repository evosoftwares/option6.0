import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
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
    // Log completo pra quando o usuário escolhe o perfil
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
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq('currentUser_UID_Firebase', uid),
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
        title: null,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Icon(
                  Icons.person_pin_circle,
                  color: Colors.black,
                  size: 100.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Como você deseja usar a plataforma?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16.0),
                          onTap: _isUpdating ? null : () => _selecionarPerfil('passenger'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Text(
                                    'Sou passageiro',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16.0),
                          onTap: _isUpdating ? null : () => _selecionarPerfil('driver'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.drive_eta,
                                  color: Colors.black,
                                  size: 24.0,
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Text(
                                    'Sou motorista',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                  size: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}