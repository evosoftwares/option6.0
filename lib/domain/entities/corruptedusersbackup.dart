// lib/domain/entities/corruptedusersbackup.dart


class CorruptedUsersBackup {
  final String id;
  final String originalUserId;
  final String originalFullName;
  final String originalPhone;
  final String originalEmail;
  final String correctionReason;
  final bool restored;
  final DateTime restoredAt;

  const CorruptedUsersBackup({
    required this.id,
    required this.originalUserId,
    required this.originalFullName,
    required this.originalPhone,
    required this.originalEmail,
    required this.correctionReason,
    required this.restored,
    required this.restoredAt,
  });

  CorruptedUsersBackup copyWith({
    String? id,
    String? originalUserId,
    String? originalFullName,
    String? originalPhone,
    String? originalEmail,
    String? correctionReason,
    bool? restored,
    DateTime? restoredAt,
  }) {
    return CorruptedUsersBackup(
      id: id ?? this.id,
      originalUserId: originalUserId ?? this.originalUserId,
      originalFullName: originalFullName ?? this.originalFullName,
      originalPhone: originalPhone ?? this.originalPhone,
      originalEmail: originalEmail ?? this.originalEmail,
      correctionReason: correctionReason ?? this.correctionReason,
      restored: restored ?? this.restored,
      restoredAt: restoredAt ?? this.restoredAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CorruptedUsersBackup &&
            other.id == this.id &&
            other.originalUserId == this.originalUserId &&
            other.originalFullName == this.originalFullName &&
            other.originalPhone == this.originalPhone &&
            other.originalEmail == this.originalEmail &&
            other.correctionReason == this.correctionReason &&
            other.restored == this.restored &&
            other.restoredAt == this.restoredAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      originalUserId,
      originalFullName,
      originalPhone,
      originalEmail,
      correctionReason,
      restored,
      restoredAt,
    );
  }

  @override
  String toString() => 'CorruptedUsersBackup(id: $id)';
}
