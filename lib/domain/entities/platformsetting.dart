// lib/domain/entities/platformsetting.dart
import '../value_objects/money.dart';

class PlatformSetting {
  final String id;
  final String category;
  final Money basePricePerKm;
  final Money basePricePerMinute;
  final Money minFare;
  final Money minCancellationFee;
  final int noShowWaitMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int searchRadiusKm;

  const PlatformSetting({
    required this.id,
    required this.category,
    required this.basePricePerKm,
    required this.basePricePerMinute,
    required this.minFare,
    required this.minCancellationFee,
    required this.noShowWaitMinutes,
    required this.createdAt,
    required this.updatedAt,
    required this.searchRadiusKm,
  });

  PlatformSetting copyWith({
    String? id,
    String? category,
    Money? basePricePerKm,
    Money? basePricePerMinute,
    Money? minFare,
    Money? minCancellationFee,
    int? noShowWaitMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? searchRadiusKm,
  }) {
    return PlatformSetting(
      id: id ?? this.id,
      category: category ?? this.category,
      basePricePerKm: basePricePerKm ?? this.basePricePerKm,
      basePricePerMinute: basePricePerMinute ?? this.basePricePerMinute,
      minFare: minFare ?? this.minFare,
      minCancellationFee: minCancellationFee ?? this.minCancellationFee,
      noShowWaitMinutes: noShowWaitMinutes ?? this.noShowWaitMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      searchRadiusKm: searchRadiusKm ?? this.searchRadiusKm,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PlatformSetting &&
            other.id == this.id &&
            other.category == this.category &&
            other.basePricePerKm == this.basePricePerKm &&
            other.basePricePerMinute == this.basePricePerMinute &&
            other.minFare == this.minFare &&
            other.minCancellationFee == this.minCancellationFee &&
            other.noShowWaitMinutes == this.noShowWaitMinutes &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt &&
            other.searchRadiusKm == this.searchRadiusKm);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      category,
      basePricePerKm,
      basePricePerMinute,
      minFare,
      minCancellationFee,
      noShowWaitMinutes,
      createdAt,
      updatedAt,
      searchRadiusKm,
    );
  }

  @override
  String toString() => 'PlatformSetting(id: $id)';
}
