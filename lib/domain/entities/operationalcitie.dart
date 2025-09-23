// lib/domain/entities/operationalcitie.dart
import '../value_objects/money.dart';

class OperationalCitie {
  final String id;
  final String name;
  final String state;
  final String country;
  final bool isActive;
  final Money minFare;
  final DateTime launchDate;
  final dynamic polygonCoordinates;
  final DateTime createdAt;

  const OperationalCitie({
    required this.id,
    required this.name,
    required this.state,
    required this.country,
    required this.isActive,
    required this.minFare,
    required this.launchDate,
    required this.polygonCoordinates,
    required this.createdAt,
  });

  OperationalCitie copyWith({
    String? id,
    String? name,
    String? state,
    String? country,
    bool? isActive,
    Money? minFare,
    DateTime? launchDate,
    dynamic polygonCoordinates,
    DateTime? createdAt,
  }) {
    return OperationalCitie(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      country: country ?? this.country,
      isActive: isActive ?? this.isActive,
      minFare: minFare ?? this.minFare,
      launchDate: launchDate ?? this.launchDate,
      polygonCoordinates: polygonCoordinates ?? this.polygonCoordinates,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OperationalCitie &&
            other.id == this.id &&
            other.name == this.name &&
            other.state == this.state &&
            other.country == this.country &&
            other.isActive == this.isActive &&
            other.minFare == this.minFare &&
            other.launchDate == this.launchDate &&
            other.polygonCoordinates == this.polygonCoordinates &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      state,
      country,
      isActive,
      minFare,
      launchDate,
      polygonCoordinates,
      createdAt,
    );
  }

  @override
  String toString() => 'OperationalCitie(id: $id)';
}
