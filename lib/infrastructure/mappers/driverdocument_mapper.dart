// lib/infrastructure/mappers/driverdocument_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/driverdocument.dart';
import '../../backend/supabase/database/tables/driver_documents.dart';


class DriverDocumentMapper {
  DriverDocument toDomain(DriverDocumentsRow row) {
    return DriverDocument(
      id: row.id,
      driverId: row.driverId,
      documentType: row.documentType,
      fileUrl: row.fileUrl,
      fileSize: row.fileSize,
      mimeType: row.mimeType,
      expiryDate: row.expiryDate,
      rejectionReason: row.rejectionReason,
      reviewedBy: row.reviewedBy,
      reviewedAt: row.reviewedAt,
      isCurrent: row.isCurrent,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      status: row.status,
    );
  }
  
  Map<String, dynamic> toSupabase(DriverDocument entity) {
    return {
      'id': entity.id,
      'driver_id': entity.driverId,
      'document_type': entity.documentType,
      'file_url': entity.fileUrl,
      'file_size': entity.fileSize,
      'mime_type': entity.mimeType,
      'expiry_date': entity.expiryDate,
      'rejection_reason': entity.rejectionReason,
      'reviewed_by': entity.reviewedBy,
      'reviewed_at': entity.reviewedAt,
      'is_current': entity.isCurrent,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
      'status': entity.status,
    };
  }

}
