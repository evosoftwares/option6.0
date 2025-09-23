// lib/domain/entities/passengerwallet.dart
import '../value_objects/email.dart';

class PassengerWallet {
  final String id;
  final String passengerId;
  final Email email;
  final double availableBalance;
  final double pendingBalance;
  final double totalSpent;
  final double totalCashback;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PassengerWallet({
    required this.id,
    required this.passengerId,
    required this.email,
    required this.availableBalance,
    required this.pendingBalance,
    required this.totalSpent,
    required this.totalCashback,
    required this.createdAt,
    required this.updatedAt,
  });

  PassengerWallet copyWith({
    String? id,
    String? passengerId,
    Email? email,
    double? availableBalance,
    double? pendingBalance,
    double? totalSpent,
    double? totalCashback,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PassengerWallet(
      id: id ?? this.id,
      passengerId: passengerId ?? this.passengerId,
      email: email ?? this.email,
      availableBalance: availableBalance ?? this.availableBalance,
      pendingBalance: pendingBalance ?? this.pendingBalance,
      totalSpent: totalSpent ?? this.totalSpent,
      totalCashback: totalCashback ?? this.totalCashback,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PassengerWallet &&
            other.id == this.id &&
            other.passengerId == this.passengerId &&
            other.email == this.email &&
            other.availableBalance == this.availableBalance &&
            other.pendingBalance == this.pendingBalance &&
            other.totalSpent == this.totalSpent &&
            other.totalCashback == this.totalCashback &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      passengerId,
      email,
      availableBalance,
      pendingBalance,
      totalSpent,
      totalCashback,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() => 'PassengerWallet(id: $id)';
}
