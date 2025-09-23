// lib/domain/entities/drivercurrentdocument.dart


class DriverCurrentDocument {
  final String id;
  final String driverId;
  final String documentType;
  final String fileUrl;
  final int fileSize;
  final String mimeType;
  final DateTime expiryDate;
  final String status;
  final DateTime reviewedAt;
  final bool isCurrent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool urlMightBeStale;

  const DriverCurrentDocument({
    required this.id,
    required this.driverId,
    required this.documentType,
    required this.fileUrl,
    required this.fileSize,
    required this.mimeType,
    required this.expiryDate,
    required this.status,
    required this.reviewedAt,
    required this.isCurrent,
    required this.createdAt,
    required this.updatedAt,
    required this.urlMightBeStale,
  });

  DriverCurrentDocument copyWith({
    String? id,
    String? driverId,
    String? documentType,
    String? fileUrl,
    int? fileSize,
    String? mimeType,
    DateTime? expiryDate,
    String? status,
    DateTime? reviewedAt,
    bool? isCurrent,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? urlMightBeStale,
  }) {
    return DriverCurrentDocument(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      documentType: documentType ?? this.documentType,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      isCurrent: isCurrent ?? this.isCurrent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      urlMightBeStale: urlMightBeStale ?? this.urlMightBeStale,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DriverCurrentDocument &&
            other.id == this.id &&
            other.driverId == this.driverId &&
            other.documentType == this.documentType &&
            other.fileUrl == this.fileUrl &&
            other.fileSize == this.fileSize &&
            other.mimeType == this.mimeType &&
            other.expiryDate == this.expiryDate &&
            other.status == this.status &&
            other.reviewedAt == this.reviewedAt &&
            other.isCurrent == this.isCurrent &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt &&
            other.urlMightBeStale == this.urlMightBeStale);
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
      status,
      reviewedAt,
      isCurrent,
      createdAt,
      updatedAt,
      urlMightBeStale,
    );
  }

  @override
  String toString() => 'DriverCurrentDocument(id: $id)';
}
