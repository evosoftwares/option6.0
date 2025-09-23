// lib/domain/entities/withdrawal.dart


class Withdrawal {
  final String id;
  final String driverId;
  final String walletId;
  final double amount;
  final String withdrawalMethod;
  final dynamic bankAccountInfo;
  final String asaasTransferId;
  final String status;
  final String failureReason;
  final DateTime requestedAt;
  final DateTime processedAt;
  final DateTime completedAt;

  const Withdrawal({
    required this.id,
    required this.driverId,
    required this.walletId,
    required this.amount,
    required this.withdrawalMethod,
    required this.bankAccountInfo,
    required this.asaasTransferId,
    required this.status,
    required this.failureReason,
    required this.requestedAt,
    required this.processedAt,
    required this.completedAt,
  });

  Withdrawal copyWith({
    String? id,
    String? driverId,
    String? walletId,
    double? amount,
    String? withdrawalMethod,
    dynamic bankAccountInfo,
    String? asaasTransferId,
    String? status,
    String? failureReason,
    DateTime? requestedAt,
    DateTime? processedAt,
    DateTime? completedAt,
  }) {
    return Withdrawal(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      walletId: walletId ?? this.walletId,
      amount: amount ?? this.amount,
      withdrawalMethod: withdrawalMethod ?? this.withdrawalMethod,
      bankAccountInfo: bankAccountInfo ?? this.bankAccountInfo,
      asaasTransferId: asaasTransferId ?? this.asaasTransferId,
      status: status ?? this.status,
      failureReason: failureReason ?? this.failureReason,
      requestedAt: requestedAt ?? this.requestedAt,
      processedAt: processedAt ?? this.processedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Withdrawal &&
            other.id == this.id &&
            other.driverId == this.driverId &&
            other.walletId == this.walletId &&
            other.amount == this.amount &&
            other.withdrawalMethod == this.withdrawalMethod &&
            other.bankAccountInfo == this.bankAccountInfo &&
            other.asaasTransferId == this.asaasTransferId &&
            other.status == this.status &&
            other.failureReason == this.failureReason &&
            other.requestedAt == this.requestedAt &&
            other.processedAt == this.processedAt &&
            other.completedAt == this.completedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      driverId,
      walletId,
      amount,
      withdrawalMethod,
      bankAccountInfo,
      asaasTransferId,
      status,
      failureReason,
      requestedAt,
      processedAt,
      completedAt,
    );
  }

  @override
  String toString() => 'Withdrawal(id: $id)';
}
