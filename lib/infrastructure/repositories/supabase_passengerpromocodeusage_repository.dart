// lib/infrastructure/repositories/supabase_passengerpromocodeusage_repository.dart
import '../../domain/entities/passengerpromocodeusage.dart';
import '../../domain/repositories/passengerpromocodeusage_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/passenger_promo_code_usage.dart';
import '../mappers/passengerpromocodeusage_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabasePassengerPromoCodeUsageRepository implements PassengerPromoCodeUsageRepository {
  final PassengerPromoCodeUsageTable _table;
  final PassengerPromoCodeUsageMapper _mapper;
  
  SupabasePassengerPromoCodeUsageRepository({
    required PassengerPromoCodeUsageTable table,
    required PassengerPromoCodeUsageMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<PassengerPromoCodeUsage?>> findById(String id) async {
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
        RepositoryException('Failed to find passengerpromocodeusage: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<PassengerPromoCodeUsage>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all passengerpromocodeusages: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(PassengerPromoCodeUsage passengerpromocodeusage) async {
    try {
      final data = _mapper.toSupabase(passengerpromocodeusage);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save passengerpromocodeusage: ${e.message}')
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
        RepositoryException('Failed to delete passengerpromocodeusage: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<PassengerPromoCodeUsage?>> findByUserId(String userId) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('user_id', userId),
      );
      
      if (rows.isEmpty) {
        return Result.success(null);
      }
      
      final entity = _mapper.toDomain(rows.first);
      return Result.success(entity);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find passengerpromocodeusage by user ID: ${e.message}')
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

