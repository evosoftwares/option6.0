// lib/domain/entities/securitylog.dart


class SecurityLog {
  final String id;
  final String eventType;
  final String severity;
  final String description;
  final String userId;
  final String ipAddress;
  final String userAgent;
  final dynamic deviceInfo;
  final String platform;
  final String appVersion;
  final String sessionId;
  final dynamic metadata;
  final DateTime timestamp;
  final DateTime createdAt;

  const SecurityLog({
    required this.id,
    required this.eventType,
    required this.severity,
    required this.description,
    required this.userId,
    required this.ipAddress,
    required this.userAgent,
    required this.deviceInfo,
    required this.platform,
    required this.appVersion,
    required this.sessionId,
    required this.metadata,
    required this.timestamp,
    required this.createdAt,
  });

  SecurityLog copyWith({
    String? id,
    String? eventType,
    String? severity,
    String? description,
    String? userId,
    String? ipAddress,
    String? userAgent,
    dynamic deviceInfo,
    String? platform,
    String? appVersion, String? sessionId,
    dynamic metadata,
    DateTime? timestamp,
    DateTime? createdAt,
  }) {
    return SecurityLog(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      severity: severity ?? this.severity,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      platform: platform ?? this.platform,
      appVersion: appVersion ?? this.appVersion,
      sessionId: sessionId ?? this.sessionId,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SecurityLog &&
            other.id == this.id &&
            other.eventType == this.eventType &&
            other.severity == this.severity &&
            other.description == this.description &&
            other.userId == this.userId &&
            other.ipAddress == this.ipAddress &&
            other.userAgent == this.userAgent &&
            other.deviceInfo == this.deviceInfo &&
            other.platform == this.platform &&
            other.appVersion == this.appVersion &&
            other.sessionId == this.sessionId &&
            other.metadata == this.metadata &&
            other.timestamp == this.timestamp &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      eventType,
      severity,
      description,
      userId,
      ipAddress,
      userAgent,
      deviceInfo,
      platform,
      appVersion,
      sessionId,
      metadata,
      timestamp,
      createdAt,
    );
  }

  @override
  String toString() => 'SecurityLog(id: $id)';
}
