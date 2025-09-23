// lib/domain/value_objects/location.dart
import 'dart:math' as math;

class Location {
  final double latitude;
  final double longitude;
  final DateTime? timestamp;
  
  const Location({
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });
  
  factory Location.fromCoordinates(double lat, double lng) {
    if (lat < -90 || lat > 90) {
      throw InvalidLocationException('Latitude must be between -90 and 90');
    }
    if (lng < -180 || lng > 180) {
      throw InvalidLocationException('Longitude must be between -180 and 180');
    }
    
    return Location(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
    );
  }
  
  Distance distanceTo(Location other) {
    // Implementação da fórmula de Haversine
    const double earthRadius = 6371000; // metros
    
    final double lat1Rad = latitude * (math.pi / 180);
    final double lat2Rad = other.latitude * (math.pi / 180);
    final double deltaLatRad = (other.latitude - latitude) * (math.pi / 180);
    final double deltaLngRad = (other.longitude - longitude) * (math.pi / 180);
    
    final double a = math.pow(math.sin(deltaLatRad / 2), 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.pow(math.sin(deltaLngRad / 2), 2);
    
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return Distance.meters(earthRadius * c);
  }
  
  bool isWithinRadius(Location center, Distance radius) {
    return distanceTo(center).meters <= radius.meters;
  }
  
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Location &&
            other.latitude == latitude &&
            other.longitude == longitude);
  }
  
  @override
  int get hashCode => Object.hash(latitude, longitude);
  
  @override
  String toString() => 'Location($latitude, $longitude)';
}

class Distance {
  final double meters;
  
  const Distance._(this.meters);
  
  factory Distance.meters(double meters) {
    if (meters < 0) {
      throw ArgumentError('Distance cannot be negative');
    }
    return Distance._(meters);
  }
  
  factory Distance.kilometers(double km) => Distance._(km * 1000);
  
  double get kilometers => meters / 1000;
  
  bool isLessThan(Distance other) => meters < other.meters;
  bool isGreaterThan(Distance other) => meters > other.meters;
  
  @override
  String toString() => '${kilometers.toStringAsFixed(2)} km';
}

class InvalidLocationException implements Exception {
  final String message;
  const InvalidLocationException(this.message);
}
