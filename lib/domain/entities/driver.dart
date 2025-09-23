// lib/domain/entities/driver.dart
import '../value_objects/email.dart';
import '../value_objects/location.dart';
import '../value_objects/money.dart';

class Driver {
  final String id;
  final String userId;
  final String vehicleBrand;
  final String vehicleModel;
  final int vehicleYear;
  final String vehicleColor;
  final String vehiclePlate;
  final String vehicleCategory;
  final String approvedBy;
  final DateTime approvedAt;
  final bool isOnline;
  final bool acceptsPet;
  final Money petFee;
  final bool acceptsGrocery;
  final Money groceryFee;
  final bool acceptsCondo;
  final Money condoFee;
  final Money stopFee;
  final String acPolicy;
  final Money customPricePerKm;
  final String bankAccountType;
  final String bankCode;
  final String bankAgency;
  final String bankAccount;
  final String pixKey;
  final String pixKeyType;
  final int totalTrips;
  final double averageRating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String fcmToken;
  final String devicePlatform;
  final String approvalStatus;
  final String? onesignalPlayerId;
  final Email email;
  final Location? currentLocation;

  const Driver({
    required this.id,
    required this.userId,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.vehicleColor,
    required this.vehiclePlate,
    required this.vehicleCategory,
    required this.approvedBy,
    required this.approvedAt,
    required this.isOnline,
    required this.acceptsPet,
    required this.petFee,
    required this.acceptsGrocery,
    required this.groceryFee,
    required this.acceptsCondo,
    required this.condoFee,
    required this.stopFee,
    required this.acPolicy,
    required this.customPricePerKm,
    required this.bankAccountType,
    required this.bankCode,
    required this.bankAgency,
    required this.bankAccount,
    required this.pixKey,
    required this.pixKeyType,
    required this.totalTrips,
    required this.averageRating,
    required this.createdAt,
    required this.updatedAt,
    required this.fcmToken,
    required this.devicePlatform,
    required this.approvalStatus,
    required this.onesignalPlayerId,
    required this.email,
    this.currentLocation,
  });

  Driver copyWith({
    String? id,
    String? userId,
    String? vehicleBrand,
    String? vehicleModel,
    int? vehicleYear,
    String? vehicleColor,
    String? vehiclePlate,
    String? vehicleCategory,
    String? approvedBy,
    DateTime? approvedAt,
    bool? isOnline,
    bool? acceptsPet,
    Money? petFee,
    bool? acceptsGrocery,
    Money? groceryFee,
    bool? acceptsCondo,
    Money? condoFee,
    Money? stopFee,
    String? acPolicy,
    Money? customPricePerKm,
    String? bankAccountType,
    String? bankCode,
    String? bankAgency,
    String? bankAccount,
    String? pixKey,
    String? pixKeyType,
    int? totalTrips,
    double? averageRating,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fcmToken,
    String? devicePlatform,
    String? approvalStatus,
    String? onesignalPlayerId,
    Email? email,
    Location? currentLocation,
  }) {
    return Driver(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      isOnline: isOnline ?? this.isOnline,
      acceptsPet: acceptsPet ?? this.acceptsPet,
      petFee: petFee ?? this.petFee,
      acceptsGrocery: acceptsGrocery ?? this.acceptsGrocery,
      groceryFee: groceryFee ?? this.groceryFee,
      acceptsCondo: acceptsCondo ?? this.acceptsCondo,
      condoFee: condoFee ?? this.condoFee,
      stopFee: stopFee ?? this.stopFee,
      acPolicy: acPolicy ?? this.acPolicy,
      customPricePerKm: customPricePerKm ?? this.customPricePerKm,
      bankAccountType: bankAccountType ?? this.bankAccountType,
      bankCode: bankCode ?? this.bankCode,
      bankAgency: bankAgency ?? this.bankAgency,
      bankAccount: bankAccount ?? this.bankAccount,
      pixKey: pixKey ?? this.pixKey,
      pixKeyType: pixKeyType ?? this.pixKeyType,
      totalTrips: totalTrips ?? this.totalTrips,
      averageRating: averageRating ?? this.averageRating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fcmToken: fcmToken ?? this.fcmToken,
      devicePlatform: devicePlatform ?? this.devicePlatform,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      onesignalPlayerId: onesignalPlayerId ?? this.onesignalPlayerId,
      email: email ?? this.email,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }


  bool canAcceptTrip() {
    return isOnline && approvalStatus == 'approved';
  }

  Money calculateBaseFee() {
    return customPricePerKm;
  }

  bool isApproved() {
    return approvalStatus == 'approved';
  }

  bool hasValidDocuments() {
    return approvedBy.isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Driver &&
        other.id == this.id &&
        other.userId == this.userId &&
        other.vehicleBrand == this.vehicleBrand &&
        other.vehicleModel == this.vehicleModel &&
        other.vehicleYear == this.vehicleYear &&
        other.vehicleColor == this.vehicleColor &&
        other.vehiclePlate == this.vehiclePlate &&
        other.vehicleCategory == this.vehicleCategory &&
        other.approvedBy == this.approvedBy &&
        other.approvedAt == this.approvedAt &&
        other.isOnline == this.isOnline &&
        other.acceptsPet == this.acceptsPet &&
        other.petFee == this.petFee &&
        other.acceptsGrocery == this.acceptsGrocery &&
        other.groceryFee == this.groceryFee &&
        other.acceptsCondo == this.acceptsCondo &&
        other.condoFee == this.condoFee &&
        other.stopFee == this.stopFee &&
        other.acPolicy == this.acPolicy &&
        other.customPricePerKm == this.customPricePerKm &&
        other.bankAccountType == this.bankAccountType &&
        other.bankCode == this.bankCode &&
        other.bankAgency == this.bankAgency &&
        other.bankAccount == this.bankAccount &&
        other.pixKey == this.pixKey &&
        other.pixKeyType == this.pixKeyType &&
        other.totalTrips == this.totalTrips &&
        other.averageRating == this.averageRating &&
        other.createdAt == this.createdAt &&
        other.updatedAt == this.updatedAt &&
        other.fcmToken == this.fcmToken &&
        other.devicePlatform == this.devicePlatform &&
        other.approvalStatus == this.approvalStatus &&
        other.onesignalPlayerId == this.onesignalPlayerId &&
        other.email == this.email &&
        other.currentLocation == this.currentLocation;
  
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      vehicleBrand,
      vehicleModel,
      vehicleYear,
      vehicleColor,
      vehiclePlate,
      vehicleCategory,
      approvedBy,
      approvedAt,
      isOnline,
      acceptsPet,
      petFee,
      acceptsGrocery,
      groceryFee,
      acceptsCondo,
      condoFee,
      stopFee,
      acPolicy,
      Object.hashAll([
        customPricePerKm,
        bankAccountType,
        bankCode,
        bankAgency,
        bankAccount,
        pixKey,
        pixKeyType,
        totalTrips,
        averageRating,
        createdAt,
        updatedAt,
        fcmToken,
        devicePlatform,
        approvalStatus,
        onesignalPlayerId,
        email,
        currentLocation,
      ]),
    );
  }

  @override
  String toString() => 'Driver(id: $id)';
}
