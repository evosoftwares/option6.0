// lib/domain/entities/appuser.dart
import '../value_objects/email.dart';
import '../value_objects/phone_number.dart';

class AppUser {
  final String id;
  final Email email;
  final String fullName;
  final PhoneNumber phone;
  final String photoUrl;
  final String userType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String fcmToken;
  final String deviceId;
  final String devicePlatform;
  final DateTime lastActiveAt;
  final bool profileComplete;
  final String? onesignalPlayerId;
  final String idText;

  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.photoUrl,
    required this.userType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.fcmToken,
    required this.deviceId,
    required this.devicePlatform,
    required this.lastActiveAt,
    required this.profileComplete,
    required this.onesignalPlayerId,
    required this.idText,
  });

  AppUser copyWith({
    String? id,
    Email? email,
    String? fullName,
    PhoneNumber? phone,
    String? photoUrl,
    String? userType,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fcmToken,
    String? deviceId,
    String? devicePlatform,
    DateTime? lastActiveAt,
    bool? profileComplete,
    String? onesignalPlayerId,
    String? idText,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      userType: userType ?? this.userType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fcmToken: fcmToken ?? this.fcmToken,
      deviceId: deviceId ?? this.deviceId,
      devicePlatform: devicePlatform ?? this.devicePlatform,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      profileComplete: profileComplete ?? this.profileComplete,
      onesignalPlayerId: onesignalPlayerId ?? this.onesignalPlayerId,
      idText: idText ?? this.idText,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AppUser &&
            other.id == this.id &&
            other.email == this.email &&
            other.fullName == this.fullName &&
            other.phone == this.phone &&
            other.photoUrl == this.photoUrl &&
            other.userType == this.userType &&
            other.status == this.status &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt &&
            other.fcmToken == this.fcmToken &&
            other.deviceId == this.deviceId &&
            other.devicePlatform == this.devicePlatform &&
            other.lastActiveAt == this.lastActiveAt &&
            other.profileComplete == this.profileComplete &&
            other.onesignalPlayerId == this.onesignalPlayerId &&
            other.idText == this.idText);
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    fullName,
    phone,
    photoUrl,
    userType,
    status,
    createdAt,
    updatedAt,
    fcmToken,
    deviceId,
    devicePlatform,
    lastActiveAt,
    profileComplete,
    onesignalPlayerId,
    idText
  );

  @override
  String toString() => 'AppUser(id: $id)';
}
