// lib/domain/entities/driverwallet.dart
import '../value_objects/email.dart';

class DriverWallet {
  final String id;
  final Email email;
  final double availableBalance;
  final double pendingBalance;
  final double totalEarned;
  final double totalWithdrawn;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DriverWallet({
    required this.id,
    required this.email,
    required this.availableBalance,
    required this.pendingBalance,
    required this.totalEarned,
    required this.totalWithdrawn,
    required this.createdAt,
    required this.updatedAt,
  });

  DriverWallet copyWith({
    String? id,
    Email? email,
    double? availableBalance,
    double? pendingBalance,
    double? totalEarned,
    double? totalWithdrawn,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DriverWallet(
      id: id ?? this.id,
      email: email ?? this.email,
      availableBalance: availableBalance ?? this.availableBalance,
      pendingBalance: pendingBalance ?? this.pendingBalance,
      totalEarned: totalEarned ?? this.totalEarned,
      totalWithdrawn: totalWithdrawn ?? this.totalWithdrawn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DriverWallet &&
            other.id == this.id &&
            other.email == this.email &&
            other.availableBalance == this.availableBalance &&
            other.pendingBalance == this.pendingBalance &&
            other.totalEarned == this.totalEarned &&
            other.totalWithdrawn == this.totalWithdrawn &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      availableBalance,
      pendingBalance,
      totalEarned,
      totalWithdrawn,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() => 'DriverWallet(id: $id)';
}
