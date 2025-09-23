// lib/infrastructure/repositories/supabase_locationsharing_repository.dart
import '../../domain/entities/locationsharing.dart';
import '../../domain/repositories/locationsharing_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/location_sharing.dart';
import '../mappers/locationsharing_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseLocationSharingRepository implements LocationSharingRepository {
  final LocationSharingTable _table;
  final LocationSharingMapper _mapper;
  
  SupabaseLocationSharingRepository({
    required LocationSharingTable table,
    required LocationSharingMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<LocationSharing?>> findById(String id) async {
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
        RepositoryException('Failed to find locationsharing: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<LocationSharing>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all locationsharings: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(LocationSharing locationsharing) async {
    try {
      final data = _mapper.toSupabase(locationsharing);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save locationsharing: ${e.message}')
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
        RepositoryException('Failed to delete locationsharing: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<LocationSharing?>> findByUserId(String userId) async {
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
        RepositoryException('Failed to find locationsharing by user ID: ${e.message}')
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

