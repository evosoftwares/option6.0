// lib/domain/entities/paymentmethod.dart


class PaymentMethod {
  final String id;
  final String userId;
  final String type;
  final bool isDefault;
  final bool isActive;
  final dynamic cardData;
  final dynamic pixData;
  final String asaasCustomerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.isDefault,
    required this.isActive,
    required this.cardData,
    required this.pixData,
    required this.asaasCustomerId,
    required this.createdAt,
    required this.updatedAt,
  });

  PaymentMethod copyWith({
    String? id,
    String? userId,
    String? type,
    bool? isDefault,
    bool? isActive,
    dynamic cardData,
    dynamic pixData, String? asaasCustomerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      cardData: cardData ?? this.cardData,
      pixData: pixData ?? this.pixData,
      asaasCustomerId: asaasCustomerId ?? this.asaasCustomerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PaymentMethod &&
            other.id == this.id &&
            other.userId == this.userId &&
            other.type == this.type &&
            other.isDefault == this.isDefault &&
            other.isActive == this.isActive &&
            other.cardData == this.cardData &&
            other.pixData == this.pixData &&
            other.asaasCustomerId == this.asaasCustomerId &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      type,
      isDefault,
      isActive,
      cardData,
      pixData,
      asaasCustomerId,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() => 'PaymentMethod(id: $id)';
}
