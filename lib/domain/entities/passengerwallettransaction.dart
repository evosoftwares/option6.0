// lib/domain/entities/passengerwallettransaction.dart


class PassengerWalletTransaction {
  final String id;
  final String walletId;
  final String passengerId;
  final String type;
  final double amount;
  final String description;
  final String tripId;
  final String paymentMethodId;
  final String asaasPaymentId;
  final String status;
  final dynamic metadata;
  final DateTime createdAt;
  final DateTime processedAt;

  const PassengerWalletTransaction({
    required this.id,
    required this.walletId,
    required this.passengerId,
    required this.type,
    required this.amount,
    required this.description,
    required this.tripId,
    required this.paymentMethodId,
    required this.asaasPaymentId,
    required this.status,
    required this.metadata,
    required this.createdAt,
    required this.processedAt,
  });

  PassengerWalletTransaction copyWith({
    String? id,
    String? walletId,
    String? passengerId,
    String? type,
    double? amount,
    String? description,
    String? tripId,
    String? paymentMethodId, String? asaasPaymentId,
    String? status,
    dynamic metadata,
    DateTime? createdAt,
    DateTime? processedAt,
  }) {
    return PassengerWalletTransaction(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      passengerId: passengerId ?? this.passengerId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      tripId: tripId ?? this.tripId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      asaasPaymentId: asaasPaymentId ?? this.asaasPaymentId,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PassengerWalletTransaction &&
            other.id == this.id &&
            other.walletId == this.walletId &&
            other.passengerId == this.passengerId &&
            other.type == this.type &&
            other.amount == this.amount &&
            other.description == this.description &&
            other.tripId == this.tripId &&
            other.paymentMethodId == this.paymentMethodId &&
            other.asaasPaymentId == this.asaasPaymentId &&
            other.status == this.status &&
            other.metadata == this.metadata &&
            other.createdAt == this.createdAt &&
            other.processedAt == this.processedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      walletId,
      passengerId,
      type,
      amount,
      description,
      tripId,
      paymentMethodId,
      asaasPaymentId,
      status,
      metadata,
      createdAt,
      processedAt,
    );
  }

  @override
  String toString() => 'PassengerWalletTransaction(id: $id)';
}
