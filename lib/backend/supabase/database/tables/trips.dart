import '../database.dart';
import '/backend/supabase/supabase.dart';

class TripsTable extends SupabaseTable<TripsRow> {
  @override
  String get tableName => 'trips';

  @override
  TripsRow createRow(Map<String, dynamic> data) => TripsRow(data);
}

class TripsRow extends SupabaseDataRow {
  TripsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TripsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get tripCode => getField<String>('trip_code');
  set tripCode(String? value) => setField<String>('trip_code', value);

  String? get requestId => getField<String>('request_id');
  set requestId(String? value) => setField<String>('request_id', value);

  String? get passengerId => getField<String>('passenger_id');
  set passengerId(String? value) => setField<String>('passenger_id', value);

  String? get driverId => getField<String>('driver_id');
  set driverId(String? value) => setField<String>('driver_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get originAddress => getField<String>('origin_address');
  set originAddress(String? value) => setField<String>('origin_address', value);

  dynamic? get originLatitude => getField<dynamic>('origin_latitude');
  set originLatitude(dynamic? value) => setField<dynamic>('origin_latitude', value);

  dynamic? get originLongitude => getField<dynamic>('origin_longitude');
  set originLongitude(dynamic? value) => setField<dynamic>('origin_longitude', value);

  String? get originNeighborhood => getField<String>('origin_neighborhood');
  set originNeighborhood(String? value) => setField<String>('origin_neighborhood', value);

  String? get destinationAddress => getField<String>('destination_address');
  set destinationAddress(String? value) => setField<String>('destination_address', value);

  dynamic? get destinationLatitude => getField<dynamic>('destination_latitude');
  set destinationLatitude(dynamic? value) => setField<dynamic>('destination_latitude', value);

  dynamic? get destinationLongitude => getField<dynamic>('destination_longitude');
  set destinationLongitude(dynamic? value) => setField<dynamic>('destination_longitude', value);

  String? get destinationNeighborhood => getField<String>('destination_neighborhood');
  set destinationNeighborhood(String? value) => setField<String>('destination_neighborhood', value);

  String? get vehicleCategory => getField<String>('vehicle_category');
  set vehicleCategory(String? value) => setField<String>('vehicle_category', value);

  bool? get needsPet => getField<bool>('needs_pet');
  set needsPet(bool? value) => setField<bool>('needs_pet', value);

  bool? get needsGrocerySpace => getField<bool>('needs_grocery_space');
  set needsGrocerySpace(bool? value) => setField<bool>('needs_grocery_space', value);

  bool? get isCondoDestination => getField<bool>('is_condo_destination');
  set isCondoDestination(bool? value) => setField<bool>('is_condo_destination', value);

  bool? get isCondoOrigin => getField<bool>('is_condo_origin');
  set isCondoOrigin(bool? value) => setField<bool>('is_condo_origin', value);

  bool? get needsAc => getField<bool>('needs_ac');
  set needsAc(bool? value) => setField<bool>('needs_ac', value);

  int? get numberOfStops => getField<int>('number_of_stops');
  set numberOfStops(int? value) => setField<int>('number_of_stops', value);

  String? get routePolyline => getField<String>('route_polyline');
  set routePolyline(String? value) => setField<String>('route_polyline', value);

  dynamic? get estimatedDistanceKm => getField<dynamic>('estimated_distance_km');
  set estimatedDistanceKm(dynamic? value) => setField<dynamic>('estimated_distance_km', value);

  int? get estimatedDurationMinutes => getField<int>('estimated_duration_minutes');
  set estimatedDurationMinutes(int? value) => setField<int>('estimated_duration_minutes', value);

  dynamic? get driverToPickupDistanceKm => getField<dynamic>('driver_to_pickup_distance_km');
  set driverToPickupDistanceKm(dynamic? value) => setField<dynamic>('driver_to_pickup_distance_km', value);

  int? get driverToPickupDurationMinutes => getField<int>('driver_to_pickup_duration_minutes');
  set driverToPickupDurationMinutes(int? value) => setField<int>('driver_to_pickup_duration_minutes', value);

  dynamic? get actualDistanceKm => getField<dynamic>('actual_distance_km');
  set actualDistanceKm(dynamic? value) => setField<dynamic>('actual_distance_km', value);

  int? get actualDurationMinutes => getField<int>('actual_duration_minutes');
  set actualDurationMinutes(int? value) => setField<int>('actual_duration_minutes', value);

  int? get waitingTimeMinutes => getField<int>('waiting_time_minutes');
  set waitingTimeMinutes(int? value) => setField<int>('waiting_time_minutes', value);

  dynamic? get driverDistanceTraveledKm => getField<dynamic>('driver_distance_traveled_km');
  set driverDistanceTraveledKm(dynamic? value) => setField<dynamic>('driver_distance_traveled_km', value);

  dynamic? get baseFare => getField<dynamic>('base_fare');
  set baseFare(dynamic? value) => setField<dynamic>('base_fare', value);

  dynamic? get additionalFees => getField<dynamic>('additional_fees');
  set additionalFees(dynamic? value) => setField<dynamic>('additional_fees', value);

  dynamic? get surgeMultiplier => getField<dynamic>('surge_multiplier');
  set surgeMultiplier(dynamic? value) => setField<dynamic>('surge_multiplier', value);

  dynamic? get totalFare => getField<dynamic>('total_fare');
  set totalFare(dynamic? value) => setField<dynamic>('total_fare', value);

  dynamic? get platformCommission => getField<dynamic>('platform_commission');
  set platformCommission(dynamic? value) => setField<dynamic>('platform_commission', value);

  dynamic? get driverEarnings => getField<dynamic>('driver_earnings');
  set driverEarnings(dynamic? value) => setField<dynamic>('driver_earnings', value);

  String? get cancellationReason => getField<String>('cancellation_reason');
  set cancellationReason(String? value) => setField<String>('cancellation_reason', value);

  dynamic? get cancellationFee => getField<dynamic>('cancellation_fee');
  set cancellationFee(dynamic? value) => setField<dynamic>('cancellation_fee', value);

  String? get cancelledBy => getField<String>('cancelled_by');
  set cancelledBy(String? value) => setField<String>('cancelled_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get driverAssignedAt => getField<DateTime>('driver_assigned_at');
  set driverAssignedAt(DateTime? value) => setField<DateTime>('driver_assigned_at', value);

  DateTime? get driverArrivedAt => getField<DateTime>('driver_arrived_at');
  set driverArrivedAt(DateTime? value) => setField<DateTime>('driver_arrived_at', value);

  DateTime? get tripStartedAt => getField<DateTime>('trip_started_at');
  set tripStartedAt(DateTime? value) => setField<DateTime>('trip_started_at', value);

  DateTime? get tripCompletedAt => getField<DateTime>('trip_completed_at');
  set tripCompletedAt(DateTime? value) => setField<DateTime>('trip_completed_at', value);

  DateTime? get cancelledAt => getField<DateTime>('cancelled_at');
  set cancelledAt(DateTime? value) => setField<DateTime>('cancelled_at', value);

  String? get paymentStatus => getField<String>('payment_status');
  set paymentStatus(String? value) => setField<String>('payment_status', value);

  String? get paymentId => getField<String>('payment_id');
  set paymentId(String? value) => setField<String>('payment_id', value);

  DateTime? get paymentCompletedAt => getField<DateTime>('payment_completed_at');
  set paymentCompletedAt(DateTime? value) => setField<DateTime>('payment_completed_at', value);

  String? get promoCodeId => getField<String>('promo_code_id');
  set promoCodeId(String? value) => setField<String>('promo_code_id', value);

  dynamic? get discountApplied => getField<dynamic>('discount_applied');
  set discountApplied(dynamic? value) => setField<dynamic>('discount_applied', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get startTime => getField<DateTime>('start_time');
  set startTime(DateTime? value) => setField<DateTime>('start_time', value);

  DateTime? get endTime => getField<DateTime>('end_time');
  set endTime(DateTime? value) => setField<DateTime>('end_time', value);

  DateTime? get requestedAt => getField<DateTime>('requested_at');
  set requestedAt(DateTime? value) => setField<DateTime>('requested_at', value);

  DateTime? get completedAt => getField<DateTime>('completed_at');
  set completedAt(DateTime? value) => setField<DateTime>('completed_at', value);

  DateTime? get assignedAt => getField<DateTime>('assigned_at');
  set assignedAt(DateTime? value) => setField<DateTime>('assigned_at', value);

  DateTime? get arrivedAt => getField<DateTime>('arrived_at');
  set arrivedAt(DateTime? value) => setField<DateTime>('arrived_at', value);

}