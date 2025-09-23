// lib/infrastructure/mappers/drivercurrentdocument_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/drivercurrentdocument.dart';
import '../../backend/supabase/database/tables/driver_documents.dart';


class DriverCurrentDocumentMapper {
  DriverCurrentDocument toDomain(DriverDocumentsRow row) {
    return DriverCurrentDocument(
      id: row.id,
      driverId: row.driverId ?? '',
      documentType: row.documentType ?? '',
      fileUrl: row.fileUrl ?? '',
      fileSize: row.fileSize ?? 0,
      mimeType: row.mimeType ?? '',
      expiryDate: row.expiryDate ?? DateTime.now(),
      status: row.status?.toString() ?? 'unknown',
      reviewedAt: row.reviewedAt ?? DateTime.now(),
      isCurrent: row.isCurrent ?? false,
      createdAt: row.createdAt ?? DateTime.now(),
      updatedAt: row.updatedAt ?? DateTime.now(),
      urlMightBeStale: false,
    );
  }
  
  Map<String, dynamic> toSupabase(DriverCurrentDocument entity) {
    return {
      'id': entity.id,
      'driver_id': entity.driverId,
      'document_type': entity.documentType,
      'file_url': entity.fileUrl,
      'file_size': entity.fileSize,
      'mime_type': entity.mimeType,
      'expiry_date': entity.expiryDate,
      'status': entity.status,
      'reviewed_at': entity.reviewedAt,
      'is_current': entity.isCurrent,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
    };
  }

}
