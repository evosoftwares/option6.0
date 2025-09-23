// lib/domain/entities/savedplace.dart
import '../value_objects/location.dart';

class SavedPlace {
  final String id;
  final String userId;
  final String label;
  final String address;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Location? locationLocation;

  const SavedPlace({
    required this.id,
    required this.userId,
    required this.label,
    required this.address,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.locationLocation,
  });

  SavedPlace copyWith({
    String? id,
    String? userId,
    String? label,
    String? address,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    Location? locationLocation,
  }) {
    return SavedPlace(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      address: address ?? this.address,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      locationLocation: locationLocation ?? this.locationLocation,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SavedPlace &&
            other.id == this.id &&
            other.userId == this.userId &&
            other.label == this.label &&
            other.address == this.address &&
            other.category == this.category &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt &&
            other.locationLocation == this.locationLocation);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      label,
      address,
      category,
      createdAt,
      updatedAt,
      locationLocation,
    );
  }

  @override
  String toString() => 'SavedPlace(id: $id)';
}
