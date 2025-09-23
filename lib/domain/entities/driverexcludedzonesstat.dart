// lib/domain/entities/driverexcludedzonesstat.dart


class DriverExcludedZonesStat {
  final String id;
  final String driverId;
  final int totalExcludedZones;
  final DateTime lastExclusionDate;
  final List<String> cities;
  final List<String> states;

  const DriverExcludedZonesStat({
    required this.id,
    required this.driverId,
    required this.totalExcludedZones,
    required this.lastExclusionDate,
    required this.cities,
    required this.states,
  });

  DriverExcludedZonesStat copyWith({
    String? id,
    String? driverId,
    int? totalExcludedZones,
    DateTime? lastExclusionDate,
    List<String>? cities,
    List<String>? states,
  }) {
    return DriverExcludedZonesStat(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      totalExcludedZones: totalExcludedZones ?? this.totalExcludedZones,
      lastExclusionDate: lastExclusionDate ?? this.lastExclusionDate,
      cities: cities ?? this.cities,
      states: states ?? this.states,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DriverExcludedZonesStat &&
            other.id == this.id &&
            other.driverId == this.driverId &&
            other.totalExcludedZones == this.totalExcludedZones &&
            other.lastExclusionDate == this.lastExclusionDate &&
            other.cities == this.cities &&
            other.states == this.states);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      driverId,
      totalExcludedZones,
      lastExclusionDate,
      cities,
      states,
    );
  }

  @override
  String toString() => 'DriverExcludedZonesStat(id: $id)';
}
