import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/upload_data.dart';
import '/custom_code/actions/validar_documentos_motorista.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'documentos_motorista_model.dart';
import '/backend/supabase/supabase.dart';
export 'documentos_motorista_model.dart';

class DocumentosMotoristaWidget extends StatefulWidget {
  const DocumentosMotoristaWidget({super.key});

  static const String routeName = 'DocumentosMotorista';
  static const String routePath = '/documentos_motorista';

  @override
  State<DocumentosMotoristaWidget> createState() =>
      _DocumentosMotoristaWidgetState();
}

class _DocumentosMotoristaWidgetState extends State<DocumentosMotoristaWidget> {
  late DocumentosMotoristaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _canNavigateAway = false;
  bool _allDocumentsUploaded = false;
  bool _navigatedAfterApproval = false;
  StreamSubscription<List<Map<String, dynamic>>>? _docsRealtimeSub;
  String? _driverId;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DocumentosMotoristaModel());

    // Verificar se o motorista pode sair da tela de documentos
    _checkDocumentStatus();
    _initializeRealtimeWatcher();
  }

  /// Verifica se todos os documentos estão aprovados
  Future<void> _checkDocumentStatus() async {
    try {
      final hasAllDocuments = await validarDocumentosMotorista();
      debugPrint('DOCS_STATUS: hasAllDocuments=$hasAllDocuments; driverId=$_driverId');
      setState(() {
        _canNavigateAway = hasAllDocuments;
        if (hasAllDocuments) {
          _allDocumentsUploaded = false;
        }
      });

      if (hasAllDocuments) {
        print('✅ [DOCS_SCREEN] Todos os documentos aprovados - navegação permitida');
      } else {
        print('⚠️ [DOCS_SCREEN] Documentos pendentes - navegação bloqueada');
      }
    } catch (e) {
      print('💥 [DOCS_SCREEN] Erro ao verificar status dos documentos: $e');
      setState(() {
        _canNavigateAway = false;
      });
    }
  }

  /// Verifica se todos os 4 documentos foram enviados
  void _checkAllDocumentsUploaded() {
    final allUploaded = _model.uploadedFileUrl_uploadDataN5p.isNotEmpty &&
        _model.uploadedFileUrl_uploadDataN5pw.isNotEmpty &&
        _model.uploadedFileUrl_uploadDataCRLV.isNotEmpty &&
        _model.uploadedFileUrl_uploadDataVF.isNotEmpty;
    
    if (allUploaded && !_allDocumentsUploaded) {
      setState(() {
        _allDocumentsUploaded = true;
      });
      
      // Esconder a mensagem após 5 segundos
      Future.delayed(Duration(seconds: 5), () {
        if (mounted) {
          setState(() {});
        }
      });
    } else {
      setState(() {
        _allDocumentsUploaded = allUploaded;
      });
    }
  }

  @override
  void dispose() {
    _docsRealtimeSub?.cancel();
    _model.dispose();
    super.dispose();
  }

  Future<String?> _getDriverIdForCurrentUser(BuildContext context) async {
    try {
      // Tenta localizar o app_user pelo e-mail do Firebase Auth primeiro,
      // com fallback para o fcm_token (usando currentUserUid) caso não encontre.
      final String? email = currentUserEmail;
      final String? fcm = currentUserUid;

      List<AppUsersRow> appUsers = [];
      if (email != null && email.isNotEmpty) {
        appUsers = await AppUsersTable()
            .queryRows(queryFn: (q) => q.eq('email', email).limit(1));
      }
      if (appUsers.isEmpty && fcm != null && fcm.isNotEmpty) {
        appUsers = await AppUsersTable()
            .queryRows(queryFn: (q) => q.eq('fcm_token', fcm).limit(1));
      }

      if (appUsers.isEmpty) return null;
      final appUserId = appUsers.first.id;

      final drivers = await DriversTable()
          .queryRows(queryFn: (q) => q.eq('user_id', appUserId).limit(1));
      if (drivers.isEmpty) return null;
      return drivers.first.id;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter motorista: $e')),
      );
      return null;
    }
  }

  /// Inicializa watcher Realtime para aprovações de documentos
  Future<void> _initializeRealtimeWatcher() async {
    try {
      _driverId = await _getDriverIdForCurrentUser(context);
      if (_driverId == null) return;

      // Cancelar assinatura anterior, se houver
      await _docsRealtimeSub?.cancel();

      final stream = SupaFlow.client
          .from('driver_documents')
          .stream(primaryKey: ['id']);

      _docsRealtimeSub = stream.listen((rows) async {
        // Filtra apenas documentos do motorista atual e marcados como atuais
        final relevant = rows.where((r) =>
            r['driver_id'] == _driverId && (r['is_current'] == true));
        if (relevant.isEmpty) return;

        // Revalidar status sempre que houver mudança relevante
        final hasAllDocuments = await validarDocumentosMotorista();
        if (mounted) {
          setState(() {
            _canNavigateAway = hasAllDocuments;
            if (hasAllDocuments) {
              _allDocumentsUploaded = false;
            }
          });
        }

        if (hasAllDocuments && !_navigatedAfterApproval) {
          _navigatedAfterApproval = true;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ Documentos aprovados! Você será redirecionado.'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
          // Pequeno delay para o usuário ver o feedback visual
          await Future.delayed(Duration(milliseconds: 1400));
          if (mounted) {
            context.goNamed('menuMotorista');
          }
        }
      });
    } catch (e) {
      print('💥 [DOCS_SCREEN] Erro ao iniciar watcher realtime: $e');
    }
  }

  void _navigateToMenuMotorista() {
    if (!mounted) return;
    context.goNamed('menuMotorista');
  }

  Future<void> _saveDocumentToSupabase({
    required BuildContext context,
    required String driverId,
    required String documentType,
    required String fileUrl,
    required int fileSize,
    required String? mimeTypeValue,
  }) async {
    try {
      // Monta payload do documento com adição condicional de mime_type
      final Map<String, dynamic> docInsert = {
        'driver_id': driverId,
        'document_type': documentType,
        'file_url': fileUrl,
        'file_size': fileSize,
        'is_current': true,
        'status': 'pending',
      };
      if (mimeTypeValue != null) {
        docInsert['mime_type'] = mimeTypeValue;
      }
      final existing = await DriverDocumentsTable().queryRows(
        queryFn: (q) => q
            .eq('driver_id', driverId)
            .eq('document_type', documentType)
            .eq('is_current', true)
            .limit(1),
      );

      if (existing.isEmpty) {
        debugPrint('DOCS_UPLOAD: Inserindo novo documento $documentType para driver $driverId');
        await DriverDocumentsTable().insert(docInsert);
      } else {
        final Map<String, dynamic> currentUpdate = {
          'file_url': fileUrl,
          'file_size': fileSize,
          'is_current': true,
          'status': 'pending',
        };
        if (mimeTypeValue != null) {
          currentUpdate['mime_type'] = mimeTypeValue;
        }
        debugPrint('DOCS_UPLOAD: Atualizando documento existente ${existing.first.id} ($documentType) para driver $driverId');
        await DriverDocumentsTable().update(
          data: currentUpdate,
          matchingRows: (rows) => rows.eq('id', existing.first.id),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar documento: $e')),
      );
      rethrow;
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canNavigateAway,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && !_canNavigateAway) {
          // Mostra mensagem informando que documentos são obrigatórios
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Você precisa enviar e ter todos os documentos aprovados antes de continuar.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              if (_canNavigateAway && context.mounted) {
                context.pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Envie e aguarde aprovação de todos os documentos antes de sair.'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          title: Text(
            'Documentos',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.menu,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: _navigateToMenuMotorista,
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Documentos Pessoais',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0.0,
                                ),
                          ),
                          Text(
                            'Envie seus documentos para verificação',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          // Status dos documentos
                          if (!_canNavigateAway)
                            Container(
                              margin: EdgeInsets.only(top: 16.0),
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.orange, size: 20),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      'Você precisa enviar e ter todos os documentos aprovados para acessar outras funcionalidades.',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.orange.shade700,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            SizedBox.shrink(),
                          // Feedback visual para todos os documentos enviados
                          if (_allDocumentsUploaded && !_canNavigateAway)
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              margin: EdgeInsets.only(top: 16.0),
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    FlutterFlowTheme.of(context).primary,
                                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
                                    blurRadius: 8.0,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(50.0),
                                        ),
                                        child: Icon(
                                          Icons.cloud_upload_rounded,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                      SizedBox(width: 12.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '🎉 Documentos Enviados!',
                                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                                fontFamily: 'Readex Pro',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.0,
                                              ),
                                            ),
                                            SizedBox(height: 4.0),
                                            Text(
                                              'Todos os 4 documentos foram enviados com sucesso!',
                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                fontFamily: 'Readex Pro',
                                                color: Colors.white.withValues(alpha: 0.9),
                                                letterSpacing: 0.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.0),
                                  Container(
                                    padding: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.schedule_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: Text(
                                            'A administração da OPTION está avaliando seu cadastro. Você receberá uma notificação quando a análise for concluída.',
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                              fontFamily: 'Readex Pro',
                                              color: Colors.white.withValues(alpha: 0.95),
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // CNH (Frente)
                          Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('CNH (Frente)', style: FlutterFlowTheme.of(context).titleMedium),
                                  SizedBox(height: 8.0),
                                  if (_model.uploadedFileUrl_uploadDataN5p.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        _model.uploadedFileUrl_uploadDataN5p,
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else
                                    Container(
                                      height: 160,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Text('Nenhuma imagem selecionada'),
                                    ),
                                  SizedBox(height: 8.0),
                                  InkWell(
                                    onTap: () async {
                                      final selectedMedia = await selectMediaWithSourceBottomSheet(
                                        context: context,
                                        allowPhoto: true,
                                      );
                                      if (selectedMedia != null &&
                                          selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                        setState(() => _model.isDataUploading_uploadDataN5p = true);
                                        try {
                                          final m = selectedMedia.first;
                                          final downloadUrl = await uploadData(m.storagePath, m.bytes);
                                          if (downloadUrl == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Erro no upload. Tente novamente.')),
                                            );
                                            return;
                                          }
                                          setState(() {
                                            _model.uploadedLocalFile_uploadDataN5p = FFUploadedFile(
                                              name: m.storagePath.split('/').last,
                                              bytes: m.bytes,
                                              height: m.dimensions?.height,
                                              width: m.dimensions?.width,
                                              blurHash: m.blurHash,
                                            );
                                            _model.uploadedFileUrl_uploadDataN5p = downloadUrl;
                                          });

                                          final driverId = await _getDriverIdForCurrentUser(context);
                                          if (driverId == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Motorista não encontrado.')),
                                            );
                                            return;
                                          }
                                          await _saveDocumentToSupabase(
                                            context: context,
                                            driverId: driverId,
                                            documentType: 'CNH_FRONT',
                                            fileUrl: downloadUrl,
                                            fileSize: m.bytes.length,
                                            mimeTypeValue: mime(m.storagePath),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('CNH (Frente) salva com sucesso.')),
                                          );
                                          // Revalidar status dos documentos
                                          _checkDocumentStatus();
                                          _checkAllDocumentsUploaded();
                                        } finally {
                                          setState(() => _model.isDataUploading_uploadDataN5p = false);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 48,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).primary,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        _model.isDataUploading_uploadDataN5p ? 'Carregando...' : 'Selecionar imagem',
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: 'Readex Pro',
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // CNH (Verso)
                          Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('CNH (Verso)', style: FlutterFlowTheme.of(context).titleMedium),
                                  SizedBox(height: 8.0),
                                  if (_model.uploadedFileUrl_uploadDataN5pw.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        _model.uploadedFileUrl_uploadDataN5pw,
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else
                                    Container(
                                      height: 160,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Text('Nenhuma imagem selecionada'),
                                    ),
                                  SizedBox(height: 8.0),
                                  InkWell(
                                    onTap: () async {
                                      final selectedMedia = await selectMediaWithSourceBottomSheet(
                                        context: context,
                                        allowPhoto: true,
                                      );
                                      if (selectedMedia != null &&
                                          selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                        setState(() => _model.isDataUploading_uploadDataN5pw = true);
                                        try {
                                          final m = selectedMedia.first;
                                          final downloadUrl = await uploadData(m.storagePath, m.bytes);
                                          if (downloadUrl == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Erro no upload. Tente novamente.')),
                                            );
                                            return;
                                          }
                                          setState(() {
                                            _model.uploadedLocalFile_uploadDataN5pw = FFUploadedFile(
                                              name: m.storagePath.split('/').last,
                                              bytes: m.bytes,
                                              height: m.dimensions?.height,
                                              width: m.dimensions?.width,
                                              blurHash: m.blurHash,
                                            );
                                            _model.uploadedFileUrl_uploadDataN5pw = downloadUrl;
                                          });

                                          final driverId = await _getDriverIdForCurrentUser(context);
                                          if (driverId == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Motorista não encontrado.')),
                                            );
                                            return;
                                          }
                                          await _saveDocumentToSupabase(
                                            context: context,
                                            driverId: driverId,
                                            documentType: 'CNH_BACK',
                                            fileUrl: downloadUrl,
                                            fileSize: m.bytes.length,
                                            mimeTypeValue: mime(m.storagePath),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('CNH (Verso) salva com sucesso.')),
                                          );
                                          // Revalidar status dos documentos
                                          _checkDocumentStatus();
                                          _checkAllDocumentsUploaded();
                                        } finally {
                                          setState(() => _model.isDataUploading_uploadDataN5pw = false);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 48,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).primary,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        _model.isDataUploading_uploadDataN5pw ? 'Carregando...' : 'Selecionar imagem',
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: 'Readex Pro',
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // CRLV
                          Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('CRLV', style: FlutterFlowTheme.of(context).titleMedium),
                                  SizedBox(height: 8.0),
                                  if (_model.uploadedFileUrl_uploadDataCRLV.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        _model.uploadedFileUrl_uploadDataCRLV,
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else
                                    Container(
                                      height: 160,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Text('Nenhuma imagem selecionada'),
                                    ),
                                  SizedBox(height: 8.0),
                                  InkWell(
                                    onTap: () async {
                                      final selectedMedia = await selectMediaWithSourceBottomSheet(
                                        context: context,
                                        allowPhoto: true,
                                      );
                                      if (selectedMedia != null &&
                                          selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                        setState(() => _model.isDataUploading_uploadDataCRLV = true);
                                        try {
                                          final m = selectedMedia.first;
                                          final downloadUrl = await uploadData(m.storagePath, m.bytes);
                                          if (downloadUrl == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Erro no upload. Tente novamente.')),
                                            );
                                            return;
                                          }
                                          setState(() {
                                            _model.uploadedLocalFile_uploadDataCRLV = FFUploadedFile(
                                              name: m.storagePath.split('/').last,
                                              bytes: m.bytes,
                                              height: m.dimensions?.height,
                                              width: m.dimensions?.width,
                                              blurHash: m.blurHash,
                                            );
                                            _model.uploadedFileUrl_uploadDataCRLV = downloadUrl;
                                          });

                                          final driverId = await _getDriverIdForCurrentUser(context);
                                          if (driverId == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Motorista não encontrado.')),
                                            );
                                            return;
                                          }
                                          await _saveDocumentToSupabase(
                                            context: context,
                                            driverId: driverId,
                                            documentType: 'CRLV',
                                            fileUrl: downloadUrl,
                                            fileSize: m.bytes.length,
                                            mimeTypeValue: mime(m.storagePath),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('CRLV salvo com sucesso.')),
                                          );
                                          // Revalidar status dos documentos
                                          _checkDocumentStatus();
                                          _checkAllDocumentsUploaded();
                                        } finally {
                                          setState(() => _model.isDataUploading_uploadDataCRLV = false);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 48,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).primary,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        _model.isDataUploading_uploadDataCRLV ? 'Carregando...' : 'Selecionar imagem',
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: 'Readex Pro',
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Foto Veículo (Frente)
                          Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Foto do Veículo (Frente)', style: FlutterFlowTheme.of(context).titleMedium),
                                  SizedBox(height: 8.0),
                                  if (_model.uploadedFileUrl_uploadDataVF.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        _model.uploadedFileUrl_uploadDataVF,
                                        height: 160,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else
                                    Container(
                                      height: 160,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Text('Nenhuma imagem selecionada'),
                                    ),
                                  SizedBox(height: 8.0),
                                  InkWell(
                                    onTap: () async {
                                      final selectedMedia = await selectMediaWithSourceBottomSheet(
                                        context: context,
                                        allowPhoto: true,
                                      );
                                      if (selectedMedia != null &&
                                          selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                        setState(() => _model.isDataUploading_uploadDataVF = true);
                                        try {
                                          final m = selectedMedia.first;
                                          final downloadUrl = await uploadData(m.storagePath, m.bytes);
                                          if (downloadUrl == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Erro no upload. Tente novamente.')),
                                            );
                                            return;
                                          }
                                          setState(() {
                                            _model.uploadedLocalFile_uploadDataVF = FFUploadedFile(
                                              name: m.storagePath.split('/').last,
                                              bytes: m.bytes,
                                              height: m.dimensions?.height,
                                              width: m.dimensions?.width,
                                              blurHash: m.blurHash,
                                            );
                                            _model.uploadedFileUrl_uploadDataVF = downloadUrl;
                                          });

                                          final driverId = await _getDriverIdForCurrentUser(context);
                                          if (driverId == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Motorista não encontrado.')),
                                            );
                                            return;
                                          }
                                          await _saveDocumentToSupabase(
                                            context: context,
                                            driverId: driverId,
                                            documentType: 'VEHICLE_FRONT',
                                            fileUrl: downloadUrl,
                                            fileSize: m.bytes.length,
                                            mimeTypeValue: mime(m.storagePath),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Foto (Frente) salva com sucesso.')),
                                          );
                                          // Revalidar status dos documentos
                                          _checkDocumentStatus();
                                          _checkAllDocumentsUploaded();
                                        } finally {
                                          setState(() => _model.isDataUploading_uploadDataVF = false);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 48,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).primary,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        _model.isDataUploading_uploadDataVF ? 'Carregando...' : 'Selecionar imagem',
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: 'Readex Pro',
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}
