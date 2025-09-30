import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/supabase/supabase.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadFotoWidget extends StatefulWidget {
  const UploadFotoWidget({super.key});

  static String routeName = 'upload_foto';
  static String routePath = '/upload-foto';

  @override
  State<UploadFotoWidget> createState() => _UploadFotoWidgetState();
}

class _UploadFotoWidgetState extends State<UploadFotoWidget> {
  bool _isUploading = false;
  Uint8List? _imageBytes;
  String? _previewPath;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final picked = await picker.pickImage(source: source, imageQuality: 85);
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _previewPath = picked.path;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao selecionar imagem.')),
      );
    }
  }

  Future<void> _upload() async {
    if (_imageBytes == null || _isUploading) return;
    setState(() => _isUploading = true);
    try {
      final uid = currentUserUid;
      if (uid.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não autenticado.')),
        );
        return;
      }

      final storagePath = 'users/$uid/uploads/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final url = await uploadData(storagePath, _imageBytes!);
      if (url == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha no upload. Tente novamente.')),
        );
        return;
      }

      await AppUsersTable().update(
        data: {
          'photo_url': url,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq('currentUser_UID_Firebase', uid),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto enviada com sucesso!')),
      );

      // Direcionar para tela principal conforme perfil
      final userRows = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('currentUser_UID_Firebase', uid).limit(1),
      );
      final user = userRows.isNotEmpty ? userRows.first : null;
      final tipo = user?.userType ?? 'passenger';
      if (tipo == 'driver') {
        context.goNamed(MainMotoristaWidget.routeName);
      } else {
        context.goNamed(MainPassageiroWidget.routeName);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar a foto de perfil.')),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Foto de Perfil'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecione uma foto',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Use a câmera ou escolha da galeria. O upload é seguro e imediato.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              if (_imageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _imageBytes!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: _isUploading ? null : () => _pickImage(ImageSource.camera),
                      text: 'Câmera',
                      options: FFButtonOptions(
                        height: 48,
                        color: Colors.black,
                        textStyle: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        elevation: 0,
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: _isUploading ? null : () => _pickImage(ImageSource.gallery),
                      text: 'Galeria',
                      options: FFButtonOptions(
                        height: 48,
                        color: Colors.white,
                        textStyle: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        elevation: 0,
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FFButtonWidget(
                onPressed: _imageBytes == null || _isUploading ? null : _upload,
                text: _isUploading ? 'Enviando...' : 'Enviar foto',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 56,
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
            ],
          ),
        ),
      ),
    );
  }
}