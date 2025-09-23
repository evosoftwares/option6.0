// lib/domain/entities/backuppassengersmigration.dart


class BackupPassengersMigration {
  final String id;
  final String userId;
  final int totalTrips;
  final double averageRating;
  final String paymentMethodId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BackupPassengersMigration({
    required this.id,
    required this.userId,
    required this.totalTrips,
    required this.averageRating,
    required this.paymentMethodId,
    required this.createdAt,
    required this.updatedAt,
  });

  BackupPassengersMigration copyWith({
    String? id,
    String? userId,
    int? totalTrips,
    double? averageRating,
    String? paymentMethodId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BackupPassengersMigration(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalTrips: totalTrips ?? this.totalTrips,
      averageRating: averageRating ?? this.averageRating,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BackupPassengersMigration &&
            other.id == this.id &&
            other.userId == this.userId &&
            other.totalTrips == this.totalTrips &&
            other.averageRating == this.averageRating &&
            other.paymentMethodId == this.paymentMethodId &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      totalTrips,
      averageRating,
      paymentMethodId,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() => 'BackupPassengersMigration(id: $id)';
}
