// lib/domain/entities/tripchat.dart


class TripChat {
  final String id;
  final String tripId;
  final String senderId;
  final String message;
  final bool isRead;
  final DateTime readAt;
  final DateTime createdAt;

  const TripChat({
    required this.id,
    required this.tripId,
    required this.senderId,
    required this.message,
    required this.isRead,
    required this.readAt,
    required this.createdAt,
  });

  TripChat copyWith({
    String? id,
    String? tripId, String? senderId,
    String? message,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return TripChat(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TripChat &&
            other.id == this.id &&
            other.tripId == this.tripId &&
            other.senderId == this.senderId &&
            other.message == this.message &&
            other.isRead == this.isRead &&
            other.readAt == this.readAt &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      tripId,
      senderId,
      message,
      isRead,
      readAt,
      createdAt,
    );
  }

  @override
  String toString() => 'TripChat(id: $id)';
}
