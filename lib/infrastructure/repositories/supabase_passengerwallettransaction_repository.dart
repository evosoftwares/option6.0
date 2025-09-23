// lib/infrastructure/repositories/supabase_passengerwallettransaction_repository.dart
import '../../domain/entities/passengerwallettransaction.dart';
import '../../domain/repositories/passengerwallettransaction_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/passenger_wallet_transactions.dart';
import '../mappers/passengerwallettransaction_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabasePassengerWalletTransactionRepository implements PassengerWalletTransactionRepository {
  final PassengerWalletTransactionsTable _table;
  final PassengerWalletTransactionMapper _mapper;
  
  SupabasePassengerWalletTransactionRepository({
    required PassengerWalletTransactionsTable table,
    required PassengerWalletTransactionMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<PassengerWalletTransaction?>> findById(String id) async {
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
        RepositoryException('Failed to find passengerwallettransaction: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<PassengerWalletTransaction>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all passengerwallettransactions: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(PassengerWalletTransaction passengerwallettransaction) async {
    try {
      final data = _mapper.toSupabase(passengerwallettransaction);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save passengerwallettransaction: ${e.message}')
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
        RepositoryException('Failed to delete passengerwallettransaction: ${e.message}')
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

