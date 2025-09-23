// lib/domain/entities/backupconflict409removal.dart
import '../value_objects/email.dart';
import '../value_objects/phone_number.dart';

class BackupConflict409Removal {
  final String sourceTable;
  final DateTime backupTimestamp;
  final String id;
  final Email email;
  final String fullName;
  final PhoneNumber phone;
  final String photoUrl;
  final String userType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BackupConflict409Removal({
    required this.sourceTable,
    required this.backupTimestamp,
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.photoUrl,
    required this.userType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  BackupConflict409Removal copyWith({
    String? sourceTable,
    DateTime? backupTimestamp,
    String? id,
    Email? email,
    String? fullName,
    PhoneNumber? phone,
    String? photoUrl,
    String? userType,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BackupConflict409Removal(
      sourceTable: sourceTable ?? this.sourceTable,
      backupTimestamp: backupTimestamp ?? this.backupTimestamp,
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      userType: userType ?? this.userType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BackupConflict409Removal &&
            other.sourceTable == this.sourceTable &&
            other.backupTimestamp == this.backupTimestamp &&
            other.id == this.id &&
            other.email == this.email &&
            other.fullName == this.fullName &&
            other.phone == this.phone &&
            other.photoUrl == this.photoUrl &&
            other.userType == this.userType &&
            other.status == this.status &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      sourceTable,
      backupTimestamp,
      id,
      email,
      fullName,
      phone,
      photoUrl,
      userType,
      status,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() => 'BackupConflict409Removal(id: $id)';
}
