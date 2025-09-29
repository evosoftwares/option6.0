import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
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
    if (_isUpdating) return;
    setState(() => _isUpdating = true);
    try {
      final uid = currentUserUid;
      if (uid.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não autenticado.')),
        );
        return;
      }

      await AppUsersTable().update(
        data: {
          'user_type': tipo,
          'updated_at': DateTime.now().toUtc(),
        },
        matchingRows: (rows) => rows.eq('id', uid),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tipo == 'driver' ? 'Perfil motorista selecionado.' : 'Perfil passageiro selecionado.',
          ),
        ),
      );

      context.goNamed(UploadFotoWidget.routeName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar perfil. Tente novamente.')),
      );
    } finally {
      if (mounted) setState(() => _isUpdating = false);
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