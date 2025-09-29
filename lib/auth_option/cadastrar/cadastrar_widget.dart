import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/auth/auth_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/nav/nav.dart';

class CadastrarWidget extends StatefulWidget {
  const CadastrarWidget({super.key});

  static String routeName = 'cadastrar';
  static String routePath = '/cadastrar';

  @override
  State<CadastrarWidget> createState() => _CadastrarWidgetState();
}

class _CadastrarWidgetState extends State<CadastrarWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      // Evitar refresh automático por mudança de auth para não quebrar navegação.
      AppStateNotifier.instance.updateNotifyOnAuthChange(false);

      final res = await SupabaseAuthManager.instance.registerUser(
        email: _emailController.text.trim(),
        fullName: _nameController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmController.text,
      );

      if (!mounted) return;
      final email = _emailController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          res.user == null
            ? 'Cadastro iniciado. Verifique seu e-mail ($email) para confirmar.'
            : 'Cadastro concluído com sucesso!',
        )),
      );

      // Garantir sessão ativa pós-cadastro quando possível
      if (res.user != null) {
        try {
          await SupaFlow.client.auth.signInWithPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
        } catch (_) {}
      }

      // Redirecionar para seleção de perfil após cadastro
      context.goNamed(SelecaoPerfilWidget.routeName);
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar. Tente novamente.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Informe o e-mail';
    final regex = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
    if (!regex.hasMatch(v)) return 'E-mail inválido';
    return null;
  }

  String? _validateName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Informe seu nome completo';
    if (v.length < 3) return 'Nome muito curto';
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Informe a senha';
    if (v.length < 8) return 'A senha deve ter ao menos 8 caracteres';
    return null;
  }

  String? _validateConfirm(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Confirme a senha';
    if (v != _passwordController.text) return 'Senha e confirmação não conferem';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top - 
                          MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Image.asset(
                        'assets/images/Logotipo_Vertical_Color.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cadastro',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                ),
                                fontSize: 22,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _InputField(
                              icon: Icons.email_outlined,
                              hintText: 'E-mail',
                              controller: _emailController,
                              validator: _validateEmail,
                              obscure: false,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                            ),
                            const SizedBox(height: 12),
                            _InputField(
                              icon: Icons.person_outline,
                              hintText: 'Nome completo',
                              controller: _nameController,
                              validator: _validateName,
                              obscure: false,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.name],
                            ),
                            const SizedBox(height: 12),
                            _InputField(
                              icon: Icons.lock_outline,
                              hintText: 'Senha',
                              controller: _passwordController,
                              validator: _validatePassword,
                              obscure: true,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                            ),
                            const SizedBox(height: 12),
                            _InputField(
                              icon: Icons.lock_outline,
                              hintText: 'Confirmar senha',
                              controller: _confirmController,
                              validator: _validateConfirm,
                              obscure: true,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                            ),
                            const SizedBox(height: 20),
                            FFButtonWidget(
                              onPressed: _isSubmitting ? null : _submit,
                              text: _isSubmitting ? 'Enviando...' : 'Cadastrar',
                              options: FFButtonOptions(
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(
                                  color: Colors.white,
                                ),
                                elevation: 2,
                                borderSide: const BorderSide(color: Colors.transparent, width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => context.goNamed(LoginWidget.routeName),
                              child: const Text('Já tenho conta'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.icon,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.obscure,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
  });

  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: FlutterFlowTheme.of(context).secondaryText, size: 20),
            Expanded(
              child: TextFormField(
                controller: controller,
                autofocus: false,
                obscureText: obscure,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                autofillHints: autofillHints,
                inputFormatters: inputFormatters,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000), width: 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000), width: 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000), width: 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000), width: 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ),
                validator: validator,
              ),
            ),
          ],
        ),
      ),
    );
  }
}