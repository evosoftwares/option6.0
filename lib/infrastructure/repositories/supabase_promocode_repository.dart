// lib/infrastructure/repositories/supabase_promocode_repository.dart
import '../../domain/entities/promocode.dart';
import '../../domain/repositories/promocode_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/promo_codes.dart';
import '../mappers/promocode_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabasePromoCodeRepository implements PromoCodeRepository {
  final PromoCodesTable _table;
  final PromoCodeMapper _mapper;
  
  SupabasePromoCodeRepository({
    required PromoCodesTable table,
    required PromoCodeMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<PromoCode?>> findById(String id) async {
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
        RepositoryException('Failed to find promocode: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<PromoCode>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all promocodes: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(PromoCode promocode) async {
    try {
      final data = _mapper.toSupabase(promocode);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save promocode: ${e.message}')
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
        RepositoryException('Failed to delete promocode: ${e.message}')
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

