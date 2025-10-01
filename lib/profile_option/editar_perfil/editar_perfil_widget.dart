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
  Uint8List? _localPhotoBytes;
  String? _initialNome;
  String? _initialTelefone;
  String? _initialPhotoUrl;

  @override
  void initState() {
    super.initState();
    print('\n🚀 ========== INIT STATE ==========');
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('🔄 InitState - PostFrameCallback executado');
      await _carregarDadosUsuario();
      print('✅ Carregamento inicial concluído');
    });
    
    print('========== FIM INIT STATE ==========\n');

    // Detectar mudanças nos campos
    _nomeController.addListener(_onFieldChanged);
    _telefoneController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nomeController.removeListener(_onFieldChanged);
    _telefoneController.removeListener(_onFieldChanged);
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  String _formatarTelefoneParaMascara(String telefone) {
    // Remove all non-digit characters
    String digits = telefone.replaceAll(RegExp(r'\D'), '');
    
    // If starts with 55 (Brazilian country code), remove it
    if (digits.startsWith('55') && digits.length >= 12) {
      digits = digits.substring(2);
    }
    // If starts with +55, remove it
    else if (telefone.startsWith('+55') && digits.length >= 12) {
      digits = digits.substring(3);
    }
    
    // If we have exactly 11 digits (Brazilian format 2 digits area code + 9 digits), format with mask
    if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7, 11)}';
    } 
    // If we have 10 digits (without leading '9' in mobile numbers), format with mask
    else if (digits.length == 10) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6, 10)}';
    }
    // Otherwise, return as is
    else {
      return telefone;
    }
  }

  void _onFieldChanged() {
    final hasNomeChanged = _nomeController.text != _initialNome;
    final hasTelefoneChanged = _telefoneController.text != _initialTelefone;
    final hasPhotoChanged = _photoUrl != _initialPhotoUrl;

    final hasChanges = hasNomeChanged || hasTelefoneChanged || hasPhotoChanged;

    if (_hasChanges != hasChanges) {
      setState(() => _hasChanges = hasChanges);
    }
  }

  Future<void> _carregarDadosUsuario() async {
    print('\n🔄 ========== INICIANDO CARREGAMENTO DE DADOS ==========');
    
    setState(() => _carregando = true);
    try {
      final rows = await AppUsersTable().queryRows(
        queryFn: (q) =>
            q.eq('currentUser_UID_Firebase', currentUserUid).limit(1),
      );

      if (rows.isNotEmpty) {
        _appUser = rows.first;

        // Usar os nomes corretos das colunas do banco
        final nome = _appUser?.fullName ?? '';
        final telefone = _appUser?.phone ?? '';
        final foto = _appUser?.photoUrl ?? '';
        
        print('📸 Dados do usuário:');
        print('   - ID: ${_appUser?.id}');
        print('   - Nome: "$nome"');
        print('   - Telefone: "$telefone"');
        print('📸 Photo URL do banco: "$foto"');
        print('📸 Foto vazia? ${foto.isEmpty}');
        print('📸 Foto null? ${_appUser?.photoUrl == null}');
        print('📸 Comprimento da URL: ${foto.length}');

        setState(() {
          _nomeController.text = nome;
          _telefoneController.text = _formatarTelefoneParaMascara(telefone);
          
          _photoUrl = foto.isEmpty ? null : foto;
          _initialPhotoUrl = _photoUrl;
          
          print('📸 _photoUrl setado para: "$_photoUrl"');
          print('📸 _initialPhotoUrl setado para: "$_initialPhotoUrl"');
          
          // Salvar valores iniciais
          _initialNome = _nomeController.text;
          _initialTelefone = _telefoneController.text;
        });
        
        print('✅ setState() chamado com sucesso');
        
        // Forçar rebuild e verificar
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('🔄 PostFrameCallback - Widget reconstruído');
          print('📸 _photoUrl após rebuild: "$_photoUrl"');
        });
      } else {
        print('❌ Usuário não encontrado no banco');
      }
    } catch (e, stackTrace) {
      print('❌ ERRO ao carregar dados do usuário: $e');
      print('📚 StackTrace: $stackTrace');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
    
    print('========== FIM DO CARREGAMENTO DE DADOS ==========\n');
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

      // Usar os nomes corretos das colunas conforme o banco
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
    return GestureDetector(
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
            onPressed: () {
              context.safePop();
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
    );
  }

  Widget _buildPhotoSection() {
    print('\n🖼️  ========== RENDERIZANDO PHOTO SECTION ==========');
    print('📸 Estado atual:');
    print('   - _localPhotoBytes: ${_localPhotoBytes != null ? "SIM (${_localPhotoBytes!.length} bytes)" : "null"}');
    print('   - _photoUrl: "$_photoUrl"');
    print('   - _photoUrl é null? ${_photoUrl == null}');
    print('   - _photoUrl está vazio? ${_photoUrl?.isEmpty ?? true}');
    print('   - Condição trim().isNotEmpty: ${_photoUrl != null && _photoUrl!.trim().isNotEmpty}');
    
    // DIAGNÓSTICO AVANÇADO DA URL
    if (_photoUrl != null && _photoUrl!.isNotEmpty) {
      print('\n🔍 ===== ANÁLISE DETALHADA DA URL =====');
      print('📏 Comprimento: ${_photoUrl!.length}');
      print('🔗 URL completa:\n   $_photoUrl');
      print('✂️  URL após trim: "${_photoUrl!.trim()}"');
      print('🔍 Contém "firebase"? ${_photoUrl!.contains("firebase")}');
      print('🔍 Contém "storage"? ${_photoUrl!.contains("storage")}');
      print('🔍 Contém "/users/"? ${_photoUrl!.contains("/users/")}');
      print('🔍 Começa com http? ${_photoUrl!.startsWith("http")}');
      print('🔍 Tem espaços? ${_photoUrl!.contains(" ")}');
      
      // Verificar se é uma URL válida do Firebase Storage
      if (_photoUrl!.contains('firebasestorage.googleapis.com')) {
        print('✅ URL parece ser do Firebase Storage');
        
        // Extrair o path do arquivo
        try {
          final uri = Uri.parse(_photoUrl!);
          final decodedPath = Uri.decodeComponent(uri.path);
          print('📁 Path codificado: ${uri.path}');
          print('📁 Path decodificado: $decodedPath');
          print('🔑 Query params: ${uri.queryParameters}');
          
          // Verificar se o path está correto (buscando por /users/ em ambos codificado e decodificado)
          if (uri.path.contains('/users/') || decodedPath.contains('/users/')) {
            print('✅ Path contém /users/ (correto)');
          } else {
            print('⚠️ WARNING: Path NÃO contém /users/ - pode não bater com as rules!');
          }
        } catch (e) {
          print('❌ ERRO ao fazer parse da URL: $e');
        }
      } else {
        print('⚠️ WARNING: URL não parece ser do Firebase Storage!');
      }
      print('========================================\n');
    }
    
    // Determinar qual branch será executado
    if (_localPhotoBytes != null) {
      print('✅ Vai mostrar: Image.memory (foto local)');
    } else if (_photoUrl != null && _photoUrl!.trim().isNotEmpty) {
      print('✅ Vai mostrar: Image.network');
      print('   URL completa: $_photoUrl');
    } else {
      print('⚠️  Vai mostrar: Container placeholder (sem foto)');
    }
    print('========== FIM PHOTO SECTION ==========\n');
    
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
                child: _localPhotoBytes != null
                    ? Image.memory(
                        _localPhotoBytes!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : (_photoUrl != null && _photoUrl!.trim().isNotEmpty
                        ? Image.network(
                            _photoUrl!,
                            key: ValueKey(_photoUrl),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            loadingBuilder:
                                (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 120,
                                height: 120,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                    strokeWidth: 2,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              );
                            },
                            errorBuilder:
                                (context, error, stackTrace) {
                              print('❌ ========== ERRO AO CARREGAR IMAGEM ==========');
                              print('📸 URL que falhou: $_photoUrl');
                              print('❌ Tipo do erro: ${error.runtimeType}');
                              print('❌ Erro completo: $error');
                              print('📚 StackTrace: $stackTrace');
                              
                              // Verificar se é erro de rede, permissão, etc
                              String errorMessage = 'Erro';
                              if (error.toString().contains('403')) {
                                errorMessage = 'Sem permissão';
                                print('⚠️  DIAGNÓSTICO: Erro 403 - Problema com Firebase Storage Rules!');
                              } else if (error.toString().contains('404')) {
                                errorMessage = 'Não encontrada';
                                print('⚠️  DIAGNÓSTICO: Erro 404 - Arquivo não existe no Storage!');
                              } else if (error.toString().contains('NetworkImage')) {
                                errorMessage = 'Erro de rede';
                                print('⚠️  DIAGNÓSTICO: Erro de conexão ou CORS!');
                              }
                              print('========================================\n');
                              
                              return Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.red, // Borda vermelha para indicar erro
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 40,
                                      color: Colors.red,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      errorMessage,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 120,
                            height: 120,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                          )),
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
    if (_uploadingPhoto) return;

    try {
      setState(() => _uploadingPhoto = true);

      final media = await selectMediaWithSourceBottomSheet(
        context: context,
        allowPhoto: true,
        allowVideo: false,
        imageQuality: 80,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      );

      if (media == null || media.isEmpty) {
        setState(() => _uploadingPhoto = false);
        return;
      }

      final selectedMedia = media.first;

      // Validar se é uma imagem válida
      if (selectedMedia.bytes.isEmpty) {
        if (mounted) {
          _mostrarMensagem('Arquivo inválido. Selecione uma imagem.', isError: true);
        }
        setState(() => _uploadingPhoto = false);
        return;
      }

      // Mostrar preview local imediatamente
      setState(() {
        _localPhotoBytes = selectedMedia.bytes;
      });

      // Obter extensão do arquivo
      String extensao = '.jpg'; // default
      if (selectedMedia.storagePath.isNotEmpty) {
        final path = selectedMedia.storagePath.toLowerCase();
        if (path.endsWith('.png')) extensao = '.png';
        else if (path.endsWith('.jpeg')) extensao = '.jpeg';
        else if (path.endsWith('.gif')) extensao = '.gif';
        else if (path.endsWith('.webp')) extensao = '.webp';
      }

      // Upload para Firebase Storage com path único
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storagePath = 'users/$currentUserUid/profile_$timestamp$extensao';

      final downloadUrl = await uploadData(
        storagePath,
        selectedMedia.bytes,
      );

      if (downloadUrl != null && downloadUrl.isNotEmpty) {
        print('\n📤 ========== UPLOAD CONCLUÍDO ==========');
        print('📸 Download URL recebida: "$downloadUrl"');
        
        setState(() {
          _photoUrl = downloadUrl;
          // Limpar preview local para usar a imagem do banco/URL
          _localPhotoBytes = null;
          print('📸 _photoUrl atualizada para: "$_photoUrl"');
          print('📸 _localPhotoBytes limpa: ${_localPhotoBytes == null}');
        });
        
        print('✅ setState() chamado após upload');
        _onFieldChanged(); // Atualizar estado de mudanças

        // Persistir imediatamente no banco apenas o photo_url
        try {
          if (_appUser != null) {
            print('💾 Salvando no banco...');
            await AppUsersTable().update(
              data: {
                'photo_url': _photoUrl,
                'updated_at': DateTime.now().toIso8601String(),
              },
              matchingRows: (q) => q.eq('id', _appUser!.id),
            );
            print('✅ Salvo no banco com sucesso');
            
            // Recarregar dados
            print('🔄 Recarregando dados do usuário...');
            await _carregarDadosUsuario();
          }
        } catch (e) {
          print('❌ Erro ao salvar no banco: $e');
        }
        print('========== FIM DO UPLOAD ==========\n');

        if (mounted) {
          _mostrarMensagem('Foto atualizada com sucesso!');
        }
      } else {
        if (mounted) {
          _mostrarMensagem('Erro ao fazer upload da foto.', isError: true);
        }
      }
    } catch (e) {
      debugPrint('Erro ao alterar foto: $e');
      if (mounted) {
        _mostrarMensagem('Erro ao processar a imagem. Tente novamente.', isError: true);
      }
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
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
