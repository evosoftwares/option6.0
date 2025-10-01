import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EditarPerfilWidget extends StatefulWidget {
  const EditarPerfilWidget({super.key});

  static String routeName = 'editarPerfil';
  static String routePath = '/editarPerfil';

  @override
  State<EditarPerfilWidget> createState() => _EditarPerfilWidgetState();
}

class _EditarPerfilWidgetState extends State<EditarPerfilWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();

  bool _carregando = true;
  bool _salvando = false;
  bool _uploadingPhoto = false;
  bool _hasChanges = false;
  AppUsersRow? _appUser;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();

    // Detectar mudanças nos campos
    _nomeController.addListener(_onFieldChanged);
    _telefoneController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> _carregarDadosUsuario() async {
    setState(() => _carregando = true);
    try {
      final rows = await AppUsersTable().queryRows(
        queryFn: (q) =>
            q.eq('currentUser_UID_Firebase', currentUserUid).limit(1),
      );

      if (rows.isNotEmpty) {
        _appUser = rows.first;
        _nomeController.text = _appUser?.fullName ?? '';
        _telefoneController.text = _appUser?.phone ?? '';
        _photoUrl = _appUser?.photoUrl;
      }
    } catch (e) {
      debugPrint('Erro ao carregar app_user: $e');
      if (mounted) {
        _mostrarMensagem(
          'Não foi possível carregar seus dados. Tente novamente.',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (_salvando) return;

    // Remove o foco dos campos
    FocusScope.of(context).unfocus();

    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk || _appUser == null) return;

    setState(() => _salvando = true);

    try {
      final phoneDigits = _extractDigits(_telefoneController.text);
      final e164Phone = phoneDigits.length == 11 ? '+55$phoneDigits' : null;

      final data = {
        'full_name': _nomeController.text.trim(),
        'phone': e164Phone ?? _telefoneController.text.trim(),
        'photo_url':
            _photoUrl?.trim().isEmpty == true ? null : _photoUrl?.trim(),
        'updated_at': DateTime.now().toIso8601String(),
        'profile_complete': _nomeController.text.trim().isNotEmpty &&
            (_telefoneController.text.trim().isNotEmpty),
      };

      await AppUsersTable().update(
        data: data,
        matchingRows: (q) => q.eq('id', _appUser!.id),
      );

      if (mounted) {
        _mostrarMensagem('Perfil atualizado com sucesso!');
        // Pequeno delay para mostrar a mensagem antes de voltar
        await Future.delayed(const Duration(milliseconds: 800));
        Navigator.of(context).maybePop();
      }
    } catch (e) {
      debugPrint('Erro ao atualizar app_user: $e');
      if (mounted) {
        _mostrarMensagem(
          'Não foi possível salvar as alterações. Tente novamente.',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  void _mostrarMensagem(String mensagem, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                mensagem,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }

  String? _validarNome(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Informe seu nome completo';
    if (v.length < 3) return 'Nome muito curto';
    return null;
  }

  String? _validarTelefone(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Informe seu telefone';
    final regex = RegExp(r'^\(\d{2}\) \d{5}-\d{4}$');
    if (!regex.hasMatch(v)) return 'Formato esperado: (XX) XXXXX-XXXX';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _hasChanges) {
          final shouldPop = await _mostrarDialogoConfirmacao();
          if (shouldPop == true && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              buttonSize: 40.0,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                if (_hasChanges) {
                  final shouldPop = await _mostrarDialogoConfirmacao();
                  if (shouldPop == true && context.mounted) {
                    Navigator.of(context).pop();
                  }
                } else {
                  context.safePop();
                }
              },
            ),
            title: Text(
              'Editar Perfil',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ),
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            centerTitle: false,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: FlutterFlowTheme.of(context).alternate,
              ),
            ),
          ),
          body: SafeArea(
            top: true,
            child: _carregando
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Carregando...',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.inter(),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),

                            // Foto do perfil
                            _buildPhotoSection(),

                            const SizedBox(height: 32),

                            // Campos do formulário
                            _buildFormFields(),

                            const SizedBox(height: 32),

                            // Botão salvar
                            _buildSaveButton(),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Avatar com borda
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: _photoUrl != null && _photoUrl!.isNotEmpty
                    ? Image.network(
                        _photoUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 120,
                            height: 120,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 120,
                          height: 120,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      )
                    : Container(
                        width: 120,
                        height: 120,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
              ),
            ),

            // Loading overlay
            if (_uploadingPhoto)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Botão da câmera
            if (!_uploadingPhoto)
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _alterarFoto,
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Texto de instrução
        Text(
          'Toque no ícone da câmera para alterar sua foto',
          style: FlutterFlowTheme.of(context).bodySmall.override(
                font: GoogleFonts.inter(),
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 13,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nome completo
        Text(
          'Informações pessoais',
          style: FlutterFlowTheme.of(context).titleMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 16,
              ),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _nomeController,
          decoration: InputDecoration(
            labelText: 'Nome completo',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
            hintText: 'Digite seu nome completo',
            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
            prefixIcon: Icon(
              Icons.person_outline,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20,
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(),
                fontSize: 15,
              ),
          validator: _validarNome,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 16),

        // Telefone
        TextFormField(
          controller: _telefoneController,
          decoration: InputDecoration(
            labelText: 'Telefone',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
            hintText: '(11) 99999-9999',
            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20,
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(),
                fontSize: 15,
              ),
          validator: _validarTelefone,
          keyboardType: TextInputType.phone,
          inputFormatters: [BrazilCellphoneFormatter()],
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _salvarAlteracoes(),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return FFButtonWidget(
      onPressed: (_salvando || !_hasChanges) ? null : _salvarAlteracoes,
      text: _salvando ? 'Salvando...' : 'Salvar alterações',
      icon: _salvando
          ? null
          : Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 20,
            ),
      options: FFButtonOptions(
        width: double.infinity,
        height: 52,
        color: _hasChanges
            ? FlutterFlowTheme.of(context).primary
            : FlutterFlowTheme.of(context).secondaryText,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
              ),
              color: Colors.white,
              fontSize: 16,
            ),
        elevation: _hasChanges ? 3 : 0,
        borderRadius: BorderRadius.circular(12.0),
        disabledColor: FlutterFlowTheme.of(context).secondaryText,
        disabledTextColor: Colors.white,
      ),
      showLoadingIndicator: false,
    );
  }

  Future<void> _alterarFoto() async {
    try {
      setState(() => _uploadingPhoto = true);

      final media = await selectMediaWithSourceBottomSheet(
        context: context,
        allowPhoto: true,
        allowVideo: false,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
        includeDimensions: true,
      );

      if (media == null || media.isEmpty) {
        setState(() => _uploadingPhoto = false);
        return;
      }

      final m = media.first;
      if (!validateFileFormat(m.filePath ?? m.storagePath, context)) {
        setState(() => _uploadingPhoto = false);
        return;
      }

      final downloadUrl = await uploadData(m.storagePath, m.bytes);

      if (downloadUrl != null) {
        setState(() {
          _photoUrl = downloadUrl;
          _hasChanges = true;
        });
        _mostrarMensagem('Foto atualizada! Não esqueça de salvar.');
      } else {
        _mostrarMensagem('Falha ao enviar a foto.', isError: true);
      }
    } catch (e) {
      _mostrarMensagem('Erro ao selecionar a imagem.', isError: true);
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<bool?> _mostrarDialogoConfirmacao() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Descartar alterações?',
          style: FlutterFlowTheme.of(context).titleMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
        ),
        content: Text(
          'Você tem alterações não salvas. Deseja descartá-las?',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(),
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Descartar',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _extractDigits(String s) => s.replaceAll(RegExp(r'\D'), '');
}

class BrazilCellphoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buf = StringBuffer();

    int i = 0;
    if (digits.isNotEmpty) {
      buf.write('(');
      for (; i < digits.length && i < 2; i++) {
        buf.write(digits[i]);
      }
      if (i >= 2) {
        buf.write(') ');
      }
    }

    int middleCount = 0;
    for (; i < digits.length && middleCount < 5; i++, middleCount++) {
      buf.write(digits[i]);
    }
    if (middleCount == 5) {
      buf.write('-');
    }

    int endCount = 0;
    for (; i < digits.length && endCount < 4; i++, endCount++) {
      buf.write(digits[i]);
    }

    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
