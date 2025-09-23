// lib/domain/entities/passengerpromocode.dart


class PassengerPromoCode {
  final String id;
  final String code;
  final String type;
  final double value;
  final double minAmount;
  final double maxDiscount;
  final bool isActive;
  final bool isFirstRideOnly;
  final int usageLimit;
  final int usageCount;
  final DateTime validFrom;
  final DateTime validUntil;
  final DateTime createdAt;

  const PassengerPromoCode({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    required this.minAmount,
    required this.maxDiscount,
    required this.isActive,
    required this.isFirstRideOnly,
    required this.usageLimit,
    required this.usageCount,
    required this.validFrom,
    required this.validUntil,
    required this.createdAt,
  });

  PassengerPromoCode copyWith({
    String? id,
    String? code,
    String? type,
    double? value,
    double? minAmount,
    double? maxDiscount,
    bool? isActive,
    bool? isFirstRideOnly,
    int? usageLimit,
    int? usageCount,
    DateTime? validFrom,
    DateTime? validUntil,
    DateTime? createdAt,
  }) {
    return PassengerPromoCode(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      value: value ?? this.value,
      minAmount: minAmount ?? this.minAmount,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      isActive: isActive ?? this.isActive,
      isFirstRideOnly: isFirstRideOnly ?? this.isFirstRideOnly,
      usageLimit: usageLimit ?? this.usageLimit,
      usageCount: usageCount ?? this.usageCount,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PassengerPromoCode &&
            other.id == this.id &&
            other.code == this.code &&
            other.type == this.type &&
            other.value == this.value &&
            other.minAmount == this.minAmount &&
            other.maxDiscount == this.maxDiscount &&
            other.isActive == this.isActive &&
            other.isFirstRideOnly == this.isFirstRideOnly &&
            other.usageLimit == this.usageLimit &&
            other.usageCount == this.usageCount &&
            other.validFrom == this.validFrom &&
            other.validUntil == this.validUntil &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      code,
      type,
      value,
      minAmount,
      maxDiscount,
      isActive,
      isFirstRideOnly,
      usageLimit,
      usageCount,
      validFrom,
      validUntil,
      createdAt,
    );
  }

  @override
  String toString() => 'PassengerPromoCode(id: $id)';
}
