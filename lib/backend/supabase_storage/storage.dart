import 'dart:typed_data';
import 'package:mime_type/mime_type.dart';
import '/backend/supabase/supabase.dart';

/// Upload de dados para Supabase Storage
Future<String?> uploadData(String path, Uint8List data) async {
  try {
    final mimeType = mime(path) ?? 'application/octet-stream';
    
    // Upload para Supabase Storage
    final response = await SupaFlow.client.storage
        .from('uploads')
        .uploadBinary(path, data, fileOptions: FileOptions(contentType: mimeType));
    
    if (response.isEmpty) {
      return null;
    }
    
    // Obter URL pública do arquivo
    final publicUrl = SupaFlow.client.storage
        .from('uploads')
        .getPublicUrl(path);
    
    return publicUrl;
  } catch (e) {
    print('❌ [SUPABASE_STORAGE] Erro no upload: $e');
    return null;
  }
}

/// Upload de arquivo com nome único baseado no timestamp
Future<String?> uploadDataWithTimestamp(String basePath, Uint8List data, String extension) async {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final path = '$basePath/$timestamp.$extension';
  return uploadData(path, data);
}

/// Deletar arquivo do Supabase Storage
Future<bool> deleteFile(String path) async {
  try {
    await SupaFlow.client.storage
        .from('uploads')
        .remove([path]);
    return true;
  } catch (e) {
    print('❌ [SUPABASE_STORAGE] Erro ao deletar arquivo: $e');
    return false;
  }
}