// lib/domain/entities/wallettransaction.dart


class WalletTransaction {
  final String id;
  final String walletId;
  final String type;
  final double amount;
  final String description;
  final String referenceType;
  final String referenceId;
  final double balanceAfter;
  final String status;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.description,
    required this.referenceType,
    required this.referenceId,
    required this.balanceAfter,
    required this.status,
    required this.createdAt,
  });

  WalletTransaction copyWith({
    String? id,
    String? walletId,
    String? type,
    double? amount,
    String? description,
    String? referenceType, String? referenceId,
    double? balanceAfter,
    String? status,
    DateTime? createdAt,
  }) {
    return WalletTransaction(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is WalletTransaction &&
            other.id == this.id &&
            other.walletId == this.walletId &&
            other.type == this.type &&
            other.amount == this.amount &&
            other.description == this.description &&
            other.referenceType == this.referenceType &&
            other.referenceId == this.referenceId &&
            other.balanceAfter == this.balanceAfter &&
            other.status == this.status &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      walletId,
      type,
      amount,
      description,
      referenceType,
      referenceId,
      balanceAfter,
      status,
      createdAt,
    );
  }

  @override
  String toString() => 'WalletTransaction(id: $id)';
}
