import '../database.dart';

class TripRequestsTable extends SupabaseTable<TripRequestsRow> {
  @override
  String get tableName => 'trip_requests';

  @override
  TripRequestsRow createRow(Map<String, dynamic> data) => TripRequestsRow(data);
}

class TripRequestsRow extends SupabaseDataRow {
  TripRequestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TripRequestsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get passengerId => getField<String>('passenger_id');
  set passengerId(String? value) => setField<String>('passenger_id', value);

  String? get originAddress => getField<String>('origin_address');
  set originAddress(String? value) => setField<String>('origin_address', value);

  dynamic get originLatitude => getField<dynamic>('origin_latitude');
  set originLatitude(dynamic value) => setField<dynamic>('origin_latitude', value);

  dynamic get originLongitude => getField<dynamic>('origin_longitude');
  set originLongitude(dynamic value) => setField<dynamic>('origin_longitude', value);

  String? get originNeighborhood => getField<String>('origin_neighborhood');
  set originNeighborhood(String? value) => setField<String>('origin_neighborhood', value);

  String? get destinationAddress => getField<String>('destination_address');
  set destinationAddress(String? value) => setField<String>('destination_address', value);

  dynamic get destinationLatitude => getField<dynamic>('destination_latitude');
  set destinationLatitude(dynamic value) => setField<dynamic>('destination_latitude', value);

  dynamic get destinationLongitude => getField<dynamic>('destination_longitude');
  set destinationLongitude(dynamic value) => setField<dynamic>('destination_longitude', value);

  String? get destinationNeighborhood => getField<String>('destination_neighborhood');
  set destinationNeighborhood(String? value) => setField<String>('destination_neighborhood', value);

  String? get vehicleCategory => getField<String>('vehicle_category');
  set vehicleCategory(String? value) => setField<String>('vehicle_category', value);

  bool? get needsPet => getField<bool>('needs_pet');
  set needsPet(bool? value) => setField<bool>('needs_pet', value);

  bool? get needsGrocerySpace => getField<bool>('needs_grocery_space');
  set needsGrocerySpace(bool? value) => setField<bool>('needs_grocery_space', value);

  bool? get needsAc => getField<bool>('needs_ac');
  set needsAc(bool? value) => setField<bool>('needs_ac', value);

  bool? get isCondoOrigin => getField<bool>('is_condo_origin');
  set isCondoOrigin(bool? value) => setField<bool>('is_condo_origin', value);

  bool? get isCondoDestination => getField<bool>('is_condo_destination');
  set isCondoDestination(bool? value) => setField<bool>('is_condo_destination', value);

  int? get numberOfStops => getField<int>('number_of_stops');
  set numberOfStops(int? value) => setField<int>('number_of_stops', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get selectedOfferId => getField<String>('selected_offer_id');
  set selectedOfferId(String? value) => setField<String>('selected_offer_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  String? get targetDriverId => getField<String>('target_driver_id');
  set targetDriverId(String? value) => setField<String>('target_driver_id', value);

  List<String> get fallbackDrivers => getListField<String>('fallback_drivers');
  set fallbackDrivers(List<String>? value) => setListField<String>('fallback_drivers', value);

  String? get acceptedByDriverId => getField<String>('accepted_by_driver_id');
  set acceptedByDriverId(String? value) => setField<String>('accepted_by_driver_id', value);

  DateTime? get acceptedAt => getField<DateTime>('accepted_at');
  set acceptedAt(DateTime? value) => setField<DateTime>('accepted_at', value);

  int? get currentFallbackIndex => getField<int>('current_fallback_index');
  set currentFallbackIndex(int? value) => setField<int>('current_fallback_index', value);

  int? get timeoutCount => getField<int>('timeout_count');
  set timeoutCount(int? value) => setField<int>('timeout_count', value);

  double? get estimatedDistanceKm => getField<double>('estimated_distance_km');
  set estimatedDistanceKm(double? value) => setField<double>('estimated_distance_km', value);

  int? get estimatedDurationMinutes => getField<int>('estimated_duration_minutes');
  set estimatedDurationMinutes(int? value) => setField<int>('estimated_duration_minutes', value);

  double? get estimatedFare => getField<double>('estimated_fare');
  set estimatedFare(double? value) => setField<double>('estimated_fare', value);

}