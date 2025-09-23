// lib/domain/entities/triprequest.dart
import '../value_objects/location.dart';
import '../value_objects/money.dart';

class TripRequest {
  final String id;
  final String passengerId;
  final String originAddress;
  final String originNeighborhood;
  final String destinationAddress;
  final String vehicleCategory;
  final bool needsPet;
  final bool needsGrocerySpace;
  final bool needsAc;
  final bool isCondoOrigin;
  final bool isCondoDestination;
  final int numberOfStops;
  final String status;
  final String selectedOfferId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String targetDriverId;
  final String acceptedByDriverId;
  final DateTime acceptedAt;
  final int currentFallbackIndex;
  final int timeoutCount;
  final double estimatedDistanceKm;
  final Money estimatedFare;
  final List<String> fallbackDrivers;
  final Location? originLocation;
  final Location? destinationLocation;

  const TripRequest({
    required this.id,
    required this.passengerId,
    required this.originAddress,
    required this.originNeighborhood,
    required this.destinationAddress,
    required this.vehicleCategory,
    required this.needsPet,
    required this.needsGrocerySpace,
    required this.needsAc,
    required this.isCondoOrigin,
    required this.isCondoDestination,
    required this.numberOfStops,
    required this.status,
    required this.selectedOfferId,
    required this.createdAt,
    required this.expiresAt,
    required this.targetDriverId,
    required this.acceptedByDriverId,
    required this.acceptedAt,
    required this.currentFallbackIndex,
    required this.timeoutCount,
    required this.estimatedDistanceKm,
    required this.estimatedFare,
    required this.fallbackDrivers,
    this.originLocation,
    this.destinationLocation,
  });

  TripRequest copyWith({
    String? id,
    String? passengerId,
    String? originAddress,
    String? originNeighborhood,
    String? destinationAddress,
    String? vehicleCategory,
    bool? needsPet,
    bool? needsGrocerySpace,
    bool? needsAc,
    bool? isCondoOrigin,
    bool? isCondoDestination,
    int? numberOfStops,
    String? status, String? selectedOfferId,
    DateTime? createdAt,
    DateTime? expiresAt, String? targetDriverId, String? acceptedByDriverId,
    DateTime? acceptedAt,
    int? currentFallbackIndex,
    int? timeoutCount,
    double? estimatedDistanceKm,
    Money? estimatedFare,
    List<String>? fallbackDrivers,
    Location? originLocation,
    Location? destinationLocation,
  }) {
    return TripRequest(
      id: id ?? this.id,
      passengerId: passengerId ?? this.passengerId,
      originAddress: originAddress ?? this.originAddress,
      originNeighborhood: originNeighborhood ?? this.originNeighborhood,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      needsPet: needsPet ?? this.needsPet,
      needsGrocerySpace: needsGrocerySpace ?? this.needsGrocerySpace,
      needsAc: needsAc ?? this.needsAc,
      isCondoOrigin: isCondoOrigin ?? this.isCondoOrigin,
      isCondoDestination: isCondoDestination ?? this.isCondoDestination,
      numberOfStops: numberOfStops ?? this.numberOfStops,
      status: status ?? this.status,
      selectedOfferId: selectedOfferId ?? this.selectedOfferId,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      targetDriverId: targetDriverId ?? this.targetDriverId,
      acceptedByDriverId: acceptedByDriverId ?? this.acceptedByDriverId,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      currentFallbackIndex: currentFallbackIndex ?? this.currentFallbackIndex,
      timeoutCount: timeoutCount ?? this.timeoutCount,
      estimatedDistanceKm: estimatedDistanceKm ?? this.estimatedDistanceKm,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      fallbackDrivers: fallbackDrivers ?? this.fallbackDrivers,
      originLocation: originLocation ?? this.originLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TripRequest &&
            other.id == this.id &&
            other.passengerId == this.passengerId &&
            other.originAddress == this.originAddress &&
            other.originNeighborhood == this.originNeighborhood &&
            other.destinationAddress == this.destinationAddress &&
            other.vehicleCategory == this.vehicleCategory &&
            other.needsPet == this.needsPet &&
            other.needsGrocerySpace == this.needsGrocerySpace &&
            other.needsAc == this.needsAc &&
            other.isCondoOrigin == this.isCondoOrigin &&
            other.isCondoDestination == this.isCondoDestination &&
            other.numberOfStops == this.numberOfStops &&
            other.status == this.status &&
            other.selectedOfferId == this.selectedOfferId &&
            other.createdAt == this.createdAt &&
            other.expiresAt == this.expiresAt &&
            other.targetDriverId == this.targetDriverId &&
            other.acceptedByDriverId == this.acceptedByDriverId &&
            other.acceptedAt == this.acceptedAt &&
            other.currentFallbackIndex == this.currentFallbackIndex &&
            other.timeoutCount == this.timeoutCount &&
            other.estimatedDistanceKm == this.estimatedDistanceKm &&
            other.estimatedFare == this.estimatedFare &&
            other.fallbackDrivers == this.fallbackDrivers &&
            other.originLocation == this.originLocation &&
            other.destinationLocation == this.destinationLocation);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      passengerId,
      originAddress,
      originNeighborhood,
      destinationAddress,
      vehicleCategory,
      needsPet,
      needsGrocerySpace,
      needsAc,
      isCondoOrigin,
      isCondoDestination,
      numberOfStops,
      status,
      selectedOfferId,
      createdAt,
      expiresAt,
      targetDriverId,
      acceptedByDriverId,
      acceptedAt,
      Object.hashAll([
        currentFallbackIndex,
        timeoutCount,
        estimatedDistanceKm,
        estimatedFare,
        fallbackDrivers,
        originLocation,
        destinationLocation,
      ]),
    );
  }

  @override
  String toString() => 'TripRequest(id: $id)';
}
