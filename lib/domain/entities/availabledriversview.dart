// lib/domain/entities/availabledriversview.dart
import '../value_objects/location.dart';
import '../value_objects/money.dart';

class AvailableDriversView {
  final String id;
  final String driverId;
  final String userId;
  final String vehicleBrand;
  final String vehicleModel;
  final int vehicleYear;
  final String vehicleColor;
  final String vehicleCategory;
  final String vehiclePlate;
  final bool isOnline;
  final bool acceptsPet;
  final bool acceptsGrocery;
  final bool acceptsCondo;
  final String acPolicy;
  final Money customPricePerKm;
  final Money petFee;
  final Money groceryFee;
  final Money condoFee;
  final Money stopFee;
  final int totalTrips;
  final double averageRating;
  final Location? currentLocation;

  const AvailableDriversView({
    required this.id,
    required this.driverId,
    required this.userId,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.vehicleColor,
    required this.vehicleCategory,
    required this.vehiclePlate,
    required this.isOnline,
    required this.acceptsPet,
    required this.acceptsGrocery,
    required this.acceptsCondo,
    required this.acPolicy,
    required this.customPricePerKm,
    required this.petFee,
    required this.groceryFee,
    required this.condoFee,
    required this.stopFee,
    required this.totalTrips,
    required this.averageRating,
    this.currentLocation,
  });

  AvailableDriversView copyWith({
    String? driverId,
    String? userId,
    String? vehicleBrand,
    String? vehicleModel,
    int? vehicleYear,
    String? vehicleColor,
    String? vehicleCategory,
    String? vehiclePlate,
    bool? isOnline,
    bool? acceptsPet,
    bool? acceptsGrocery,
    bool? acceptsCondo,
    String? acPolicy,
    Money? customPricePerKm,
    Money? petFee,
    Money? groceryFee,
    Money? condoFee,
    Money? stopFee,
    int? totalTrips,
    double? averageRating,
    Location? currentLocation,
  }) {
    return AvailableDriversView(
      id: id,
      driverId: driverId ?? this.driverId,
      userId: userId ?? this.userId,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      isOnline: isOnline ?? this.isOnline,
      acceptsPet: acceptsPet ?? this.acceptsPet,
      acceptsGrocery: acceptsGrocery ?? this.acceptsGrocery,
      acceptsCondo: acceptsCondo ?? this.acceptsCondo,
      acPolicy: acPolicy ?? this.acPolicy,
      customPricePerKm: customPricePerKm ?? this.customPricePerKm,
      petFee: petFee ?? this.petFee,
      groceryFee: groceryFee ?? this.groceryFee,
      condoFee: condoFee ?? this.condoFee,
      stopFee: stopFee ?? this.stopFee,
      totalTrips: totalTrips ?? this.totalTrips,
      averageRating: averageRating ?? this.averageRating,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AvailableDriversView &&
            other.driverId == this.driverId &&
            other.userId == this.userId &&
            other.vehicleBrand == this.vehicleBrand &&
            other.vehicleModel == this.vehicleModel &&
            other.vehicleYear == this.vehicleYear &&
            other.vehicleColor == this.vehicleColor &&
            other.vehicleCategory == this.vehicleCategory &&
            other.vehiclePlate == this.vehiclePlate &&
            other.isOnline == this.isOnline &&
            other.acceptsPet == this.acceptsPet &&
            other.acceptsGrocery == this.acceptsGrocery &&
            other.acceptsCondo == this.acceptsCondo &&
            other.acPolicy == this.acPolicy &&
            other.customPricePerKm == this.customPricePerKm &&
            other.petFee == this.petFee &&
            other.groceryFee == this.groceryFee &&
            other.condoFee == this.condoFee &&
            other.stopFee == this.stopFee &&
            other.totalTrips == this.totalTrips &&
            other.averageRating == this.averageRating &&
            other.currentLocation == this.currentLocation);
  }

  @override
  int get hashCode {
    return Object.hash(
      driverId,
      userId,
      vehicleBrand,
      vehicleModel,
      vehicleYear,
      vehicleColor,
      vehicleCategory,
      vehiclePlate,
      isOnline,
      acceptsPet,
      acceptsGrocery,
      acceptsCondo,
      acPolicy,
      customPricePerKm,
      petFee,
      groceryFee,
      condoFee,
      stopFee,
      totalTrips,
      Object.hashAll([
        averageRating,
        currentLocation,
      ]),
    );
  }

  @override
  String toString() => 'AvailableDriversView(id: $id)';
}
