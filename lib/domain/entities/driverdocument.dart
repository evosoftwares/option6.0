// lib/domain/entities/driverdocument.dart


class DriverDocument {
  final String id;
  final String driverId;
  final String documentType;
  final String fileUrl;
  final int fileSize;
  final String mimeType;
  final DateTime expiryDate;
  final String rejectionReason;
  final String reviewedBy;
  final DateTime reviewedAt;
  final bool isCurrent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;

  const DriverDocument({
    required this.id,
    required this.driverId,
    required this.documentType,
    required this.fileUrl,
    required this.fileSize,
    required this.mimeType,
    required this.expiryDate,
    required this.rejectionReason,
    required this.reviewedBy,
    required this.reviewedAt,
    required this.isCurrent,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  DriverDocument copyWith({
    String? id,
    String? driverId,
    String? documentType,
    String? fileUrl,
    int? fileSize,
    String? mimeType,
    DateTime? expiryDate,
    String? rejectionReason,
    String? reviewedBy,
    DateTime? reviewedAt,
    bool? isCurrent,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
  }) {
    return DriverDocument(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      documentType: documentType ?? this.documentType,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      expiryDate: expiryDate ?? this.expiryDate,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      isCurrent: isCurrent ?? this.isCurrent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DriverDocument &&
            other.id == this.id &&
            other.driverId == this.driverId &&
            other.documentType == this.documentType &&
            other.fileUrl == this.fileUrl &&
            other.fileSize == this.fileSize &&
            other.mimeType == this.mimeType &&
            other.expiryDate == this.expiryDate &&
            other.rejectionReason == this.rejectionReason &&
            other.reviewedBy == this.reviewedBy &&
            other.reviewedAt == this.reviewedAt &&
            other.isCurrent == this.isCurrent &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt &&
            other.status == this.status);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      driverId,
      documentType,
      fileUrl,
      fileSize,
      mimeType,
      expiryDate,
      rejectionReason,
      reviewedBy,
      reviewedAt,
      isCurrent,
      createdAt,
      updatedAt,
      status,
    );
  }

  @override
  String toString() => 'DriverDocument(id: $id)';
}
