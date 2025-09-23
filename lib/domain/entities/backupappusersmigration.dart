// lib/domain/entities/backupappusersmigration.dart
import '../value_objects/email.dart';
import '../value_objects/phone_number.dart';

class BackupAppUsersMigration {
  final String id;
  final Email email;
  final String fullName;
  final PhoneNumber phone;
  final String photoUrl;
  final String userType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  const BackupAppUsersMigration({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.photoUrl,
    required this.userType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  BackupAppUsersMigration copyWith({
    String? id,
    Email? email,
    String? fullName,
    PhoneNumber? phone,
    String? photoUrl,
    String? userType,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return BackupAppUsersMigration(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      userType: userType ?? this.userType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BackupAppUsersMigration &&
            other.id == this.id &&
            other.email == this.email &&
            other.fullName == this.fullName &&
            other.phone == this.phone &&
            other.photoUrl == this.photoUrl &&
            other.userType == this.userType &&
            other.status == this.status &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt &&
            other.userId == this.userId);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      fullName,
      phone,
      photoUrl,
      userType,
      status,
      createdAt,
      updatedAt,
      userId,
    );
  }

  @override
  String toString() => 'BackupAppUsersMigration(id: $id)';
}
