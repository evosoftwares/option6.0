// lib/infrastructure/repositories/supabase_passengerpromocode_repository.dart
import '../../domain/entities/passengerpromocode.dart';
import '../../domain/repositories/passengerpromocode_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/passenger_promo_codes.dart';
import '../mappers/passengerpromocode_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabasePassengerPromoCodeRepository implements PassengerPromoCodeRepository {
  final PassengerPromoCodesTable _table;
  final PassengerPromoCodeMapper _mapper;
  
  SupabasePassengerPromoCodeRepository({
    required PassengerPromoCodesTable table,
    required PassengerPromoCodeMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<PassengerPromoCode?>> findById(String id) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('id', id),
      );
      
      if (rows.isEmpty) {
        return Result.success(null);
      }
      
      final entity = _mapper.toDomain(rows.first);
      return Result.success(entity);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find passengerpromocode: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<PassengerPromoCode>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all passengerpromocodes: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(PassengerPromoCode passengerpromocode) async {
    try {
      final data = _mapper.toSupabase(passengerpromocode);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save passengerpromocode: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _table.delete(
        matchingRows: (rows) => rows.eq('id', id),
      );
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to delete passengerpromocode: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

}

class RepositoryException implements Exception {
  final String message;
  const RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

