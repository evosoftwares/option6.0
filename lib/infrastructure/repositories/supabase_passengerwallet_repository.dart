// lib/infrastructure/repositories/supabase_passengerwallet_repository.dart
import '../../domain/entities/passengerwallet.dart';
import '../../domain/repositories/passengerwallet_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/passenger_wallets.dart';
import '../mappers/passengerwallet_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabasePassengerWalletRepository implements PassengerWalletRepository {
  final PassengerWalletsTable _table;
  final PassengerWalletMapper _mapper;
  
  SupabasePassengerWalletRepository({
    required PassengerWalletsTable table,
    required PassengerWalletMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<PassengerWallet?>> findById(String id) async {
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
        RepositoryException('Failed to find passengerwallet: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<PassengerWallet>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all passengerwallets: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(PassengerWallet passengerwallet) async {
    try {
      final data = _mapper.toSupabase(passengerwallet);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save passengerwallet: ${e.message}')
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
        RepositoryException('Failed to delete passengerwallet: ${e.message}')
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

