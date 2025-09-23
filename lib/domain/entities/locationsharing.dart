// lib/domain/entities/locationsharing.dart


class LocationSharing {
  final String id;
  final String userId;
  final DateTime expiresAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime endedAt;
  final List<String> sharedWithUsers;

  const LocationSharing({
    required this.id,
    required this.userId,
    required this.expiresAt,
    required this.isActive,
    required this.createdAt,
    required this.endedAt,
    required this.sharedWithUsers,
  });

  LocationSharing copyWith({
    String? id,
    String? userId,
    DateTime? expiresAt,
    bool? isActive,
    DateTime? createdAt,
    DateTime? endedAt,
    List<String>? sharedWithUsers,
  }) {
    return LocationSharing(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt ?? this.endedAt,
      sharedWithUsers: sharedWithUsers ?? this.sharedWithUsers,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LocationSharing &&
            other.id == this.id &&
            other.userId == this.userId &&
            other.expiresAt == this.expiresAt &&
            other.isActive == this.isActive &&
            other.createdAt == this.createdAt &&
            other.endedAt == this.endedAt &&
            other.sharedWithUsers == this.sharedWithUsers);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      expiresAt,
      isActive,
      createdAt,
      endedAt,
      sharedWithUsers,
    );
  }

  @override
  String toString() => 'LocationSharing(id: $id)';
}
