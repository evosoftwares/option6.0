// lib/infrastructure/repositories/supabase_platformsetting_repository.dart
import '../../domain/entities/platformsetting.dart';
import '../../domain/repositories/platformsetting_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/platform_settings.dart';
import '../mappers/platformsetting_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabasePlatformSettingRepository implements PlatformSettingRepository {
  final PlatformSettingsTable _table;
  final PlatformSettingMapper _mapper;
  
  SupabasePlatformSettingRepository({
    required PlatformSettingsTable table,
    required PlatformSettingMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<PlatformSetting?>> findById(String id) async {
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
        RepositoryException('Failed to find platformsetting: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<PlatformSetting>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all platformsettings: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(PlatformSetting platformsetting) async {
    try {
      final data = _mapper.toSupabase(platformsetting);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save platformsetting: ${e.message}')
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
        RepositoryException('Failed to delete platformsetting: ${e.message}')
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

