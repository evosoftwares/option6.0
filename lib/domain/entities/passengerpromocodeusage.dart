// lib/domain/entities/passengerpromocodeusage.dart


class PassengerPromoCodeUsage {
  final String id;
  final String userId;
  final String promoCodeId;
  final String tripId;
  final double originalAmount;
  final double discountAmount;
  final double finalAmount;
  final DateTime usedAt;

  const PassengerPromoCodeUsage({
    required this.id,
    required this.userId,
    required this.promoCodeId,
    required this.tripId,
    required this.originalAmount,
    required this.discountAmount,
    required this.finalAmount,
    required this.usedAt,
  });

  PassengerPromoCodeUsage copyWith({
    String? id,
    String? userId, String? promoCodeId,
    String? tripId,
    double? originalAmount,
    double? discountAmount,
    double? finalAmount,
    DateTime? usedAt,
  }) {
    return PassengerPromoCodeUsage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      promoCodeId: promoCodeId ?? this.promoCodeId,
      tripId: tripId ?? this.tripId,
      originalAmount: originalAmount ?? this.originalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      usedAt: usedAt ?? this.usedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PassengerPromoCodeUsage &&
            other.id == this.id &&
            other.userId == this.userId &&
            other.promoCodeId == this.promoCodeId &&
            other.tripId == this.tripId &&
            other.originalAmount == this.originalAmount &&
            other.discountAmount == this.discountAmount &&
            other.finalAmount == this.finalAmount &&
            other.usedAt == this.usedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      promoCodeId,
      tripId,
      originalAmount,
      discountAmount,
      finalAmount,
      usedAt,
    );
  }

  @override
  String toString() => 'PassengerPromoCodeUsage(id: $id)';
}
