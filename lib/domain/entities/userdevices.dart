// lib/domain/entities/userdevices.dart


class UserDevices {
  final String id;
  final String userId;
  final String deviceToken;
  final String platform;
  final String deviceModel;
  final String appVersion;
  final String osVersion;
  final bool isActive;
  final DateTime lastUsedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserDevices({
    required this.id,
    required this.userId,
    required this.deviceToken,
    required this.platform,
    required this.deviceModel,
    required this.appVersion,
    required this.osVersion,
    required this.isActive,
    required this.lastUsedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  UserDevices copyWith({
    String? id,
    String? userId,
    String? deviceToken,
    String? platform,
    String? deviceModel,
    String? appVersion,
    String? osVersion,
    bool? isActive,
    DateTime? lastUsedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserDevices(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceToken: deviceToken ?? this.deviceToken,
      platform: platform ?? this.platform,
      deviceModel: deviceModel ?? this.deviceModel,
      appVersion: appVersion ?? this.appVersion,
      osVersion: osVersion ?? this.osVersion,
      isActive: isActive ?? this.isActive,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserDevices &&
            other.id == this.id &&
            other.userId == this.userId &&
            other.deviceToken == this.deviceToken &&
            other.platform == this.platform &&
            other.deviceModel == this.deviceModel &&
            other.appVersion == this.appVersion &&
            other.osVersion == this.osVersion &&
            other.isActive == this.isActive &&
            other.lastUsedAt == this.lastUsedAt &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      deviceToken,
      platform,
      deviceModel,
      appVersion,
      osVersion,
      isActive,
      lastUsedAt,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() => 'UserDevices(id: $id)';
}
