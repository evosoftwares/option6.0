// lib/domain/entities/promocodeusage.dart


class PromoCodeUsage {
  final String id;
  final String promoCodeId;
  final String passengerId;
  final String tripId;
  final double discountApplied;
  final DateTime usedAt;

  const PromoCodeUsage({
    required this.id,
    required this.promoCodeId,
    required this.passengerId,
    required this.tripId,
    required this.discountApplied,
    required this.usedAt,
  });

  PromoCodeUsage copyWith({
    String? id, String? promoCodeId,
    String? passengerId,
    String? tripId,
    double? discountApplied,
    DateTime? usedAt,
  }) {
    return PromoCodeUsage(
      id: id ?? this.id,
      promoCodeId: promoCodeId ?? this.promoCodeId,
      passengerId: passengerId ?? this.passengerId,
      tripId: tripId ?? this.tripId,
      discountApplied: discountApplied ?? this.discountApplied,
      usedAt: usedAt ?? this.usedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PromoCodeUsage &&
            other.id == this.id &&
            other.promoCodeId == this.promoCodeId &&
            other.passengerId == this.passengerId &&
            other.tripId == this.tripId &&
            other.discountApplied == this.discountApplied &&
            other.usedAt == this.usedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      promoCodeId,
      passengerId,
      tripId,
      discountApplied,
      usedAt,
    );
  }

  @override
  String toString() => 'PromoCodeUsage(id: $id)';
}
