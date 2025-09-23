// lib/domain/entities/notification.dart


class Notification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final dynamic dataField;
  final String priority;
  final bool isRead;
  final DateTime sentAt;
  final DateTime readAt;
  final DateTime createdAt;

  const Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.dataField,
    required this.priority,
    required this.isRead,
    required this.sentAt,
    required this.readAt,
    required this.createdAt,
  });

  Notification copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? type,
    dynamic dataField,
    String? priority,
    bool? isRead,
    DateTime? sentAt,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      dataField: dataField ?? this.dataField,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Notification &&
            other.id == this.id &&
            other.userId == this.userId &&
            other.title == this.title &&
            other.body == this.body &&
            other.type == this.type &&
            other.dataField == this.dataField &&
            other.priority == this.priority &&
            other.isRead == this.isRead &&
            other.sentAt == this.sentAt &&
            other.readAt == this.readAt &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      title,
      body,
      type,
      dataField,
      priority,
      isRead,
      sentAt,
      readAt,
      createdAt,
    );
  }

  @override
  String toString() => 'Notification(id: $id)';
}
