// lib/domain/entities/backuppassengersbeforefkchange.dart


class BackupPassengersBeforeFkChange {
  final String id;
  final int totalTrips;
  final double averageRating;
  final String paymentMethodId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  const BackupPassengersBeforeFkChange({
    required this.id,
    required this.totalTrips,
    required this.averageRating,
    required this.paymentMethodId,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  BackupPassengersBeforeFkChange copyWith({
    String? id,
    int? totalTrips,
    double? averageRating,
    String? paymentMethodId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return BackupPassengersBeforeFkChange(
      id: id ?? this.id,
      totalTrips: totalTrips ?? this.totalTrips,
      averageRating: averageRating ?? this.averageRating,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BackupPassengersBeforeFkChange &&
            other.id == this.id &&
            other.totalTrips == this.totalTrips &&
            other.averageRating == this.averageRating &&
            other.paymentMethodId == this.paymentMethodId &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt &&
            other.userId == this.userId);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      totalTrips,
      averageRating,
      paymentMethodId,
      createdAt,
      updatedAt,
      userId,
    );
  }

  @override
  String toString() => 'BackupPassengersBeforeFkChange(id: $id)';
}
