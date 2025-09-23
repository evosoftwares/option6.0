// lib/infrastructure/repositories/supabase_wallettransaction_repository.dart
import '../../domain/entities/wallettransaction.dart';
import '../../domain/repositories/wallettransaction_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/wallet_transactions.dart';
import '../mappers/wallettransaction_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseWalletTransactionRepository implements WalletTransactionRepository {
  final WalletTransactionsTable _table;
  final WalletTransactionMapper _mapper;
  
  SupabaseWalletTransactionRepository({
    required WalletTransactionsTable table,
    required WalletTransactionMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<WalletTransaction?>> findById(String id) async {
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
        RepositoryException('Failed to find wallettransaction: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<WalletTransaction>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all wallettransactions: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(WalletTransaction wallettransaction) async {
    try {
      final data = _mapper.toSupabase(wallettransaction);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save wallettransaction: ${e.message}')
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
        RepositoryException('Failed to delete wallettransaction: ${e.message}')
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

