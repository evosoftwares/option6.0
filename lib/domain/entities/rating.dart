// lib/domain/entities/rating.dart


class Rating {
  final String id;
  final String tripId;
  final int passengerRating;
  final DateTime passengerRatedAt;
  final int driverRating;
  final String driverRatingComment;
  final DateTime driverRatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> passengerRatingTags;
  final List<String> driverRatingTags;

  const Rating({
    required this.id,
    required this.tripId,
    required this.passengerRating,
    required this.passengerRatedAt,
    required this.driverRating,
    required this.driverRatingComment,
    required this.driverRatedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.passengerRatingTags,
    required this.driverRatingTags,
  });

  Rating copyWith({
    String? id,
    String? tripId,
    int? passengerRating,
    DateTime? passengerRatedAt,
    int? driverRating,
    String? driverRatingComment,
    DateTime? driverRatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? passengerRatingTags,
    List<String>? driverRatingTags,
  }) {
    return Rating(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      passengerRating: passengerRating ?? this.passengerRating,
      passengerRatedAt: passengerRatedAt ?? this.passengerRatedAt,
      driverRating: driverRating ?? this.driverRating,
      driverRatingComment: driverRatingComment ?? this.driverRatingComment,
      driverRatedAt: driverRatedAt ?? this.driverRatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      passengerRatingTags: passengerRatingTags ?? this.passengerRatingTags,
      driverRatingTags: driverRatingTags ?? this.driverRatingTags,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Rating &&
            other.id == this.id &&
            other.tripId == this.tripId &&
            other.passengerRating == this.passengerRating &&
            other.passengerRatedAt == this.passengerRatedAt &&
            other.driverRating == this.driverRating &&
            other.driverRatingComment == this.driverRatingComment &&
            other.driverRatedAt == this.driverRatedAt &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt &&
            other.passengerRatingTags == this.passengerRatingTags &&
            other.driverRatingTags == this.driverRatingTags);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      tripId,
      passengerRating,
      passengerRatedAt,
      driverRating,
      driverRatingComment,
      driverRatedAt,
      createdAt,
      updatedAt,
      passengerRatingTags,
      driverRatingTags,
    );
  }

  @override
  String toString() => 'Rating(id: $id)';
}
