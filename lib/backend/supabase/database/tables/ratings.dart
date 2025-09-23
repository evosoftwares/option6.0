import '../database.dart';

class RatingsTable extends SupabaseTable<RatingsRow> {
  @override
  String get tableName => 'ratings';

  @override
  RatingsRow createRow(Map<String, dynamic> data) => RatingsRow(data);
}

class RatingsRow extends SupabaseDataRow {
  RatingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RatingsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get tripId => getField<String>('trip_id');
  set tripId(String? value) => setField<String>('trip_id', value);

  int? get passengerRating => getField<int>('passenger_rating');
  set passengerRating(int? value) => setField<int>('passenger_rating', value);

  List<String> get passengerRatingTags => getListField<String>('passenger_rating_tags');
  set passengerRatingTags(List<String>? value) => setListField<String>('passenger_rating_tags', value);

  String? get passengerRatingComment => getField<String>('passenger_rating_comment');
  set passengerRatingComment(String? value) => setField<String>('passenger_rating_comment', value);

  DateTime? get passengerRatedAt => getField<DateTime>('passenger_rated_at');
  set passengerRatedAt(DateTime? value) => setField<DateTime>('passenger_rated_at', value);

  int? get driverRating => getField<int>('driver_rating');
  set driverRating(int? value) => setField<int>('driver_rating', value);

  List<String> get driverRatingTags => getListField<String>('driver_rating_tags');
  set driverRatingTags(List<String>? value) => setListField<String>('driver_rating_tags', value);

  String? get driverRatingComment => getField<String>('driver_rating_comment');
  set driverRatingComment(String? value) => setField<String>('driver_rating_comment', value);

  DateTime? get driverRatedAt => getField<DateTime>('driver_rated_at');
  set driverRatedAt(DateTime? value) => setField<DateTime>('driver_rated_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

}