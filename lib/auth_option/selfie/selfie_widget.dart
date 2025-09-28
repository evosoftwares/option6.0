import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase_storage/storage.dart';
import '/custom_code/actions/onesignal_service_completo.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selfie_model.dart';
import '/backend/supabase/supabase.dart';
export 'selfie_model.dart';

class SelfieWidget extends StatefulWidget {
  const SelfieWidget({super.key});

  static String routeName = 'selfie';
  static String routePath = '/selfie';

  @override
  State<SelfieWidget> createState() => _SelfieWidgetState();
}

class _SelfieWidgetState extends State<SelfieWidget> {
  late SelfieModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelfieModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              context.pushNamed(LoginWidget.routeName);
            },
          ),
          title: Text(
            'Foto do perfil',
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 200.0,
                                  height: 200.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 500),
                                    fadeOutDuration:
                                        Duration(milliseconds: 500),
                                    imageUrl: valueOrDefault<String>(
                                      _model.uploadedFileUrl_uploadData9d6,
                                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  height: 53.93,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      final selectedMedia =
                                          await selectMediaWithSourceBottomSheet(
                                        context: context,
                                        allowPhoto: true,
                                      );
                                      if (selectedMedia != null &&
                                          selectedMedia.every((m) =>
                                              validateFileFormat(
                                                  m.storagePath, context))) {
                                        safeSetState(() => _model
                                                .isDataUploading_uploadData9d6 =
                                            true);
                                        var selectedUploadedFiles =
                                            <FFUploadedFile>[];

                                        var downloadUrls = <String>[];
                                        try {
                                          selectedUploadedFiles = selectedMedia
                                              .map((m) => FFUploadedFile(
                                                    name: m.storagePath
                                                        .split('/')
                                                        .last,
                                                    bytes: m.bytes,
                                                    height:
                                                        m.dimensions?.height,
                                                    width: m.dimensions?.width,
                                                    blurHash: m.blurHash,
                                                  ))
                                              .toList();

                                          downloadUrls = (await Future.wait(
                                            selectedMedia.map(
                                              (m) async => await uploadData(
                                                  m.storagePath, m.bytes),
                                            ),
                                          ))
                                              .where((u) => u != null)
                                              .map((u) => u!)
                                              .toList();
                                        } finally {
                                          _model.isDataUploading_uploadData9d6 =
                                              false;
                                        }
                                        if (selectedUploadedFiles.length ==
                                                selectedMedia.length &&
                                            downloadUrls.length ==
                                                selectedMedia.length) {
                                          safeSetState(() {
                                            _model.uploadedLocalFile_uploadData9d6 =
                                                selectedUploadedFiles.first;
                                            _model.uploadedFileUrl_uploadData9d6 =
                                                downloadUrls.first;
                                            _model.isPhotoUploaded = true;
                                          });

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Foto carregada com sucesso!')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Erro no upload da imagem. Tente novamente.')),
                                          );
                                          safeSetState(() {});
                                          return;
                                        }
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24.0,
                                        ),
                                        Text(
                                          'Tirar Foto',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontStyle,
                                              ),
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(height: 32.0)),
                            ),
                          ].divide(SizedBox(height: 24.0)),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 1.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!_model.isPhotoUploaded)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                  child: Text(
                                    'Tire uma selfie para continuar',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Readex Pro',
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                              FFButtonWidget(
                            onPressed: _model.isPhotoUploaded
                                ? () async {
                                    try {
                                      // Busca o usuário pelo Firebase UID para obter o registro correto
                                      final userQuery = await AppUsersTable().queryRows(
                                        queryFn: (q) => q.eqOrNull('currentUser_UID_Firebase', currentUserUid),
                                      );

                                      if (userQuery.isNotEmpty) {
                                        final user = userQuery.first;
                                        
                                        // Preparar dados para atualização
                                        final updateData = {
                                          'photo_url': _model.uploadedFileUrl_uploadData9d6,
                                        };
                                        
                                        // Atualizar OneSignal player ID se necessário
                                        try {
                                          final playerId = OneSignalServiceCompleto.instance.playerId;
                                          if (playerId != null && playerId != user.fcmToken) {
                                            updateData['fcm_token'] = playerId;
                                            print('🔄 [SELFIE] Atualizando OneSignal player ID para usuário: ${user.id}');
                                          }
                                        } catch (e) {
                                          print('⚠️ [SELFIE] Erro ao atualizar OneSignal player ID: $e');
                                        }
                                        
                                        // Atualiza os dados usando o ID do Supabase
                                        await AppUsersTable().update(
                                          data: updateData,
                                          matchingRows: (rows) => rows.eqOrNull(
                                            'id',
                                            user.id,
                                          ),
                                        );
                                        
                                        if (updateData.containsKey('currentUser_UID_Firebase')) {
                                          print('✅ [SELFIE] currentUser_UID_Firebase atualizado com sucesso!');
                                        }

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Foto salva com sucesso!')),
                                        );

                                        context.pushNamed(EscolhaSeuPerfilWidget.routeName);
                                      } else {
                                        // Fallback: tentar recuperar por EMAIL e corrigir o campo currentUser_UID_Firebase
                                        try {
                                          final email = currentUserEmail;
                                          List<AppUsersRow> emailQuery = [];
                                          if (email.trim().isNotEmpty) {
                                            emailQuery = await AppUsersTable().queryRows(
                                              queryFn: (q) => q.eq('email', email.trim()).limit(1),
                                            );
                                          }
                                        
                                          if (emailQuery.isNotEmpty) {
                                            final userByEmail = emailQuery.first;
                                            final updateData = {
                                              'photo_url': _model.uploadedFileUrl_uploadData9d6,
                                              'currentUser_UID_Firebase': currentUserUid,
                                            };
                                            // Atualizar OneSignal player ID se disponível
                                            try {
                                              final playerId = OneSignalServiceCompleto.instance.playerId;
                                              if (playerId != null && playerId != userByEmail.fcmToken) {
                                                updateData['fcm_token'] = playerId;
                                              }
                                            } catch (e) {
                                              print('⚠️ [SELFIE][FALLBACK] Erro ao obter OneSignal player ID: $e');
                                            }
                                        
                                            await AppUsersTable().update(
                                              data: updateData,
                                              matchingRows: (rows) => rows.eq('id', userByEmail.id),
                                            );
                                        
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Foto salva com sucesso!')),
                                            );
                                            context.pushNamed(EscolhaSeuPerfilWidget.routeName);
                                          } else {
                                            // Criar um novo usuário mínimo, associando o Firebase UID corretamente
                                            String? playerId;
                                            try {
                                              playerId = OneSignalServiceCompleto.instance.playerId;
                                            } catch (_) {}
                                        
                                            final newUserData = {
                                              'email': email,
                                              'full_name': '',
                                              'phone': '',
                                              'photo_url': _model.uploadedFileUrl_uploadData9d6,
                                              'user_type': '',
                                              'status': 'active',
                                              'currentUser_UID_Firebase': currentUserUid,
                                              'fcm_token': playerId ?? '',
                                              'device_id': '',
                                              'device_platform': '',
                                              'profile_complete': false,
                                              'onesignal_player_id': '',
                                            };
                                        
                                            await AppUsersTable().insert(newUserData);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Foto salva com sucesso!')),
                                            );
                                            context.pushNamed(EscolhaSeuPerfilWidget.routeName);
                                          }
                                        } catch (err) {
                                          print('❌ [SELFIE] Fallback falhou: $err');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Erro: Usuário não encontrado')),
                                          );
                                        }
                                      }
                                    } catch (e) {
                                      print('Erro ao salvar foto: $e');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Erro ao salvar foto. Tente novamente.')),
                                      );
                                    }
                                  }
                                : null,
                            text: 'Salvar',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 60.0,
                              padding: EdgeInsets.all(8.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: _model.isPhotoUploaded
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).secondaryText,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.roboto(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    color: _model.isPhotoUploaded
                                        ? FlutterFlowTheme.of(context).primaryBackground
                                        : FlutterFlowTheme.of(context).secondaryBackground,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 24.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
