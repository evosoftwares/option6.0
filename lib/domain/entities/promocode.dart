// lib/domain/entities/promocode.dart


class PromoCode {
  final String id;
  final String code;
  final String description;
  final String discountType;
  final double discountValue;
  final double maxDiscount;
  final double minTripValue;
  final int maxUsesPerUser;
  final DateTime validFrom;
  final DateTime validUntil;
  final int usageLimit;
  final int usedCount;
  final bool isFirstTripOnly;
  final bool isActive;
  final String createdBy;
  final DateTime createdAt;
  final List<String> targetCities;
  final List<String> targetCategories;

  const PromoCode({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.maxDiscount,
    required this.minTripValue,
    required this.maxUsesPerUser,
    required this.validFrom,
    required this.validUntil,
    required this.usageLimit,
    required this.usedCount,
    required this.isFirstTripOnly,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.targetCities,
    required this.targetCategories,
  });

  PromoCode copyWith({
    String? id,
    String? code,
    String? description,
    String? discountType,
    double? discountValue,
    double? maxDiscount,
    double? minTripValue,
    int? maxUsesPerUser,
    DateTime? validFrom,
    DateTime? validUntil,
    int? usageLimit,
    int? usedCount,
    bool? isFirstTripOnly,
    bool? isActive,
    String? createdBy,
    DateTime? createdAt,
    List<String>? targetCities,
    List<String>? targetCategories,
  }) {
    return PromoCode(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      minTripValue: minTripValue ?? this.minTripValue,
      maxUsesPerUser: maxUsesPerUser ?? this.maxUsesPerUser,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      usageLimit: usageLimit ?? this.usageLimit,
      usedCount: usedCount ?? this.usedCount,
      isFirstTripOnly: isFirstTripOnly ?? this.isFirstTripOnly,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      targetCities: targetCities ?? this.targetCities,
      targetCategories: targetCategories ?? this.targetCategories,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PromoCode &&
            other.id == this.id &&
            other.code == this.code &&
            other.description == this.description &&
            other.discountType == this.discountType &&
            other.discountValue == this.discountValue &&
            other.maxDiscount == this.maxDiscount &&
            other.minTripValue == this.minTripValue &&
            other.maxUsesPerUser == this.maxUsesPerUser &&
            other.validFrom == this.validFrom &&
            other.validUntil == this.validUntil &&
            other.usageLimit == this.usageLimit &&
            other.usedCount == this.usedCount &&
            other.isFirstTripOnly == this.isFirstTripOnly &&
            other.isActive == this.isActive &&
            other.createdBy == this.createdBy &&
            other.createdAt == this.createdAt &&
            other.targetCities == this.targetCities &&
            other.targetCategories == this.targetCategories);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      code,
      description,
      discountType,
      discountValue,
      maxDiscount,
      minTripValue,
      maxUsesPerUser,
      validFrom,
      validUntil,
      usageLimit,
      usedCount,
      isFirstTripOnly,
      isActive,
      createdBy,
      createdAt,
      targetCities,
      targetCategories,
    );
  }

  @override
  String toString() => 'PromoCode(id: $id)';
}
