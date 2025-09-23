// lib/domain/entities/passenger.dart
import '../value_objects/email.dart';

class Passenger {
  final String id;
  final String userId;
  final int totalTrips;
  final int consecutiveCancellations;
  final double averageRating;
  final String paymentMethodId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Email email;

  const Passenger({
    required this.id,
    required this.userId,
    required this.totalTrips,
    required this.consecutiveCancellations,
    required this.averageRating,
    required this.paymentMethodId,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
  });

  Passenger copyWith({
    String? id,
    String? userId,
    int? totalTrips,
    int? consecutiveCancellations,
    double? averageRating,
    String? paymentMethodId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Email? email,
  }) {
    return Passenger(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalTrips: totalTrips ?? this.totalTrips,
      consecutiveCancellations: consecutiveCancellations ?? this.consecutiveCancellations,
      averageRating: averageRating ?? this.averageRating,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      email: email ?? this.email,
    );
  }


  bool canRequestTrip() {
    return consecutiveCancellations < 3;
  }

  bool hasGoodRating() {
    return averageRating >= 4.0;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Passenger &&
            other.id == this.id &&
            other.userId == this.userId &&
            other.totalTrips == this.totalTrips &&
            other.consecutiveCancellations == this.consecutiveCancellations &&
            other.averageRating == this.averageRating &&
            other.paymentMethodId == this.paymentMethodId &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt &&
            other.email == this.email);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      totalTrips,
      averageRating,
      paymentMethodId,
      createdAt,
      updatedAt,
      email,
    );
  }

  @override
  String toString() => 'Passenger(id: $id)';
}
