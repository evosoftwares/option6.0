// lib/domain/entities/trip.dart
import '../value_objects/location.dart';
import '../value_objects/money.dart';

class Trip {
  final String id;
  final String tripCode;
  final String requestId;
  final String passengerId;
  final String driverId;
  final String status;
  final String originAddress;
  final String originNeighborhood;
  final String destinationAddress;
  final String vehicleCategory;
  final bool needsPet;
  final bool needsGrocerySpace;
  final bool isCondoDestination;
  final bool isCondoOrigin;
  final bool needsAc;
  final int numberOfStops;
  final String routePolyline;
  final double estimatedDistanceKm;
  final double actualDistanceKm;
  final int actualDurationMinutes;
  final int waitingTimeMinutes;
  final Money baseFare;
  final Money additionalFees;
  final double surgeMultiplier;
  final Money totalFare;
  final double platformCommission;
  final double driverEarnings;
  final String cancellationReason;
  final Money cancellationFee;
  final String cancelledBy;
  final DateTime createdAt;
  final DateTime driverAssignedAt;
  final DateTime driverArrivedAt;
  final DateTime tripStartedAt;
  final DateTime tripCompletedAt;
  final DateTime cancelledAt;
  final String paymentStatus;
  final String paymentId;
  final String promoCodeId;
  final double discountApplied;
  final DateTime updatedAt;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime requestedAt;
  final DateTime completedAt;
  final DateTime assignedAt;
  final DateTime arrivedAt;
  final Location? originLocation;
  final Location? destinationLocation;

  const Trip({
    required this.id,
    required this.tripCode,
    required this.requestId,
    required this.passengerId,
    required this.driverId,
    required this.status,
    required this.originAddress,
    required this.originNeighborhood,
    required this.destinationAddress,
    required this.vehicleCategory,
    required this.needsPet,
    required this.needsGrocerySpace,
    required this.isCondoDestination,
    required this.isCondoOrigin,
    required this.needsAc,
    required this.numberOfStops,
    required this.routePolyline,
    required this.estimatedDistanceKm,
    required this.actualDistanceKm,
    required this.actualDurationMinutes,
    required this.waitingTimeMinutes,
    required this.baseFare,
    required this.additionalFees,
    required this.surgeMultiplier,
    required this.totalFare,
    required this.platformCommission,
    required this.driverEarnings,
    required this.cancellationReason,
    required this.cancellationFee,
    required this.cancelledBy,
    required this.createdAt,
    required this.driverAssignedAt,
    required this.driverArrivedAt,
    required this.tripStartedAt,
    required this.tripCompletedAt,
    required this.cancelledAt,
    required this.paymentStatus,
    required this.paymentId,
    required this.promoCodeId,
    required this.discountApplied,
    required this.updatedAt,
    required this.startTime,
    required this.endTime,
    required this.requestedAt,
    required this.completedAt,
    required this.assignedAt,
    required this.arrivedAt,
    this.originLocation,
    this.destinationLocation,
  });

  Trip copyWith({
    String? id,
    String? tripCode,
    String? requestId,
    String? passengerId,
    String? driverId,
    String? status,
    String? originAddress,
    String? originNeighborhood,
    String? destinationAddress,
    String? vehicleCategory,
    bool? needsPet,
    bool? needsGrocerySpace,
    bool? isCondoDestination,
    bool? isCondoOrigin,
    bool? needsAc,
    int? numberOfStops,
    String? routePolyline,
    double? estimatedDistanceKm,
    double? actualDistanceKm,
    int? actualDurationMinutes,
    int? waitingTimeMinutes,
    Money? baseFare,
    Money? additionalFees,
    double? surgeMultiplier,
    Money? totalFare,
    double? platformCommission,
    double? driverEarnings,
    String? cancellationReason,
    Money? cancellationFee,
    String? cancelledBy,
    DateTime? createdAt,
    DateTime? driverAssignedAt,
    DateTime? driverArrivedAt,
    DateTime? tripStartedAt,
    DateTime? tripCompletedAt,
    DateTime? cancelledAt,
    String? paymentStatus,
    String? paymentId, String? promoCodeId,
    double? discountApplied,
    DateTime? updatedAt,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? requestedAt,
    DateTime? completedAt,
    DateTime? assignedAt,
    DateTime? arrivedAt,
    Location? originLocation,
    Location? destinationLocation,
  }) {
    return Trip(
      id: id ?? this.id,
      tripCode: tripCode ?? this.tripCode,
      requestId: requestId ?? this.requestId,
      passengerId: passengerId ?? this.passengerId,
      driverId: driverId ?? this.driverId,
      status: status ?? this.status,
      originAddress: originAddress ?? this.originAddress,
      originNeighborhood: originNeighborhood ?? this.originNeighborhood,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      needsPet: needsPet ?? this.needsPet,
      needsGrocerySpace: needsGrocerySpace ?? this.needsGrocerySpace,
      isCondoDestination: isCondoDestination ?? this.isCondoDestination,
      isCondoOrigin: isCondoOrigin ?? this.isCondoOrigin,
      needsAc: needsAc ?? this.needsAc,
      numberOfStops: numberOfStops ?? this.numberOfStops,
      routePolyline: routePolyline ?? this.routePolyline,
      estimatedDistanceKm: estimatedDistanceKm ?? this.estimatedDistanceKm,
      actualDistanceKm: actualDistanceKm ?? this.actualDistanceKm,
      actualDurationMinutes: actualDurationMinutes ?? this.actualDurationMinutes,
      waitingTimeMinutes: waitingTimeMinutes ?? this.waitingTimeMinutes,
      baseFare: baseFare ?? this.baseFare,
      additionalFees: additionalFees ?? this.additionalFees,
      surgeMultiplier: surgeMultiplier ?? this.surgeMultiplier,
      totalFare: totalFare ?? this.totalFare,
      platformCommission: platformCommission ?? this.platformCommission,
      driverEarnings: driverEarnings ?? this.driverEarnings,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancellationFee: cancellationFee ?? this.cancellationFee,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      createdAt: createdAt ?? this.createdAt,
      driverAssignedAt: driverAssignedAt ?? this.driverAssignedAt,
      driverArrivedAt: driverArrivedAt ?? this.driverArrivedAt,
      tripStartedAt: tripStartedAt ?? this.tripStartedAt,
      tripCompletedAt: tripCompletedAt ?? this.tripCompletedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentId: paymentId ?? this.paymentId,
      promoCodeId: promoCodeId ?? this.promoCodeId,
      discountApplied: discountApplied ?? this.discountApplied,
      updatedAt: updatedAt ?? this.updatedAt,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      requestedAt: requestedAt ?? this.requestedAt,
      completedAt: completedAt ?? this.completedAt,
      assignedAt: assignedAt ?? this.assignedAt,
      arrivedAt: arrivedAt ?? this.arrivedAt,
      originLocation: originLocation ?? this.originLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
    );
  }


  bool canBeAccepted() {
    return status == 'pending';
  }

  bool isCompleted() {
    return status == 'completed';
  }

  bool isInProgress() {
    return status == 'in_progress';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Trip &&
            other.id == this.id &&
            other.tripCode == this.tripCode &&
            other.requestId == this.requestId &&
            other.passengerId == this.passengerId &&
            other.driverId == this.driverId &&
            other.status == this.status &&
            other.originAddress == this.originAddress &&
            other.originNeighborhood == this.originNeighborhood &&
            other.destinationAddress == this.destinationAddress &&
            other.vehicleCategory == this.vehicleCategory &&
            other.needsPet == this.needsPet &&
            other.needsGrocerySpace == this.needsGrocerySpace &&
            other.isCondoDestination == this.isCondoDestination &&
            other.isCondoOrigin == this.isCondoOrigin &&
            other.needsAc == this.needsAc &&
            other.numberOfStops == this.numberOfStops &&
            other.routePolyline == this.routePolyline &&
            other.estimatedDistanceKm == this.estimatedDistanceKm &&
            other.actualDistanceKm == this.actualDistanceKm &&
            other.actualDurationMinutes == this.actualDurationMinutes &&
            other.waitingTimeMinutes == this.waitingTimeMinutes &&
            other.baseFare == this.baseFare &&
            other.additionalFees == this.additionalFees &&
            other.surgeMultiplier == this.surgeMultiplier &&
            other.totalFare == this.totalFare &&
            other.platformCommission == this.platformCommission &&
            other.driverEarnings == this.driverEarnings &&
            other.cancellationReason == this.cancellationReason &&
            other.cancellationFee == this.cancellationFee &&
            other.cancelledBy == this.cancelledBy &&
            other.createdAt == this.createdAt &&
            other.driverAssignedAt == this.driverAssignedAt &&
            other.driverArrivedAt == this.driverArrivedAt &&
            other.tripStartedAt == this.tripStartedAt &&
            other.tripCompletedAt == this.tripCompletedAt &&
            other.cancelledAt == this.cancelledAt &&
            other.paymentStatus == this.paymentStatus &&
            other.paymentId == this.paymentId &&
            other.promoCodeId == this.promoCodeId &&
            other.discountApplied == this.discountApplied &&
            other.updatedAt == this.updatedAt &&
            other.startTime == this.startTime &&
            other.endTime == this.endTime &&
            other.requestedAt == this.requestedAt &&
            other.completedAt == this.completedAt &&
            other.assignedAt == this.assignedAt &&
            other.arrivedAt == this.arrivedAt &&
            other.originLocation == this.originLocation &&
            other.destinationLocation == this.destinationLocation);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      tripCode,
      requestId,
      passengerId,
      driverId,
      status,
      originAddress,
      originNeighborhood,
      destinationAddress,
      vehicleCategory,
      needsPet,
      needsGrocerySpace,
      isCondoDestination,
      isCondoOrigin,
      needsAc,
      numberOfStops,
      routePolyline,
      estimatedDistanceKm,
      actualDistanceKm,
      Object.hashAll([
        actualDurationMinutes,
        waitingTimeMinutes,
        baseFare,
        additionalFees,
        surgeMultiplier,
        totalFare,
        platformCommission,
        driverEarnings,
        cancellationReason,
        cancellationFee,
        cancelledBy,
        createdAt,
        driverAssignedAt,
        driverArrivedAt,
        tripStartedAt,
        tripCompletedAt,
        cancelledAt,
        paymentStatus,
        paymentId,
        promoCodeId,
        discountApplied,
        updatedAt,
        startTime,
        endTime,
        requestedAt,
        completedAt,
        assignedAt,
        arrivedAt,
        originLocation,
        destinationLocation,
      ]),
    );
  }

  @override
  String toString() => 'Trip(id: $id)';
}
