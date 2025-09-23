// lib/infrastructure/mappers/wallettransaction_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/wallettransaction.dart';
import '../../backend/supabase/database/tables/wallet_transactions.dart';


class WalletTransactionMapper {
  WalletTransaction toDomain(WalletTransactionsRow row) {
    return WalletTransaction(
      id: row.id,
      walletId: row.walletId,
      type: row.type,
      amount: row.amount,
      description: row.description,
      referenceType: row.referenceType,
      referenceId: row.referenceId,
      balanceAfter: row.balanceAfter,
      status: row.status,
      createdAt: row.createdAt,
    );
  }
  
  Map<String, dynamic> toSupabase(WalletTransaction entity) {
    return {
      'id': entity.id,
      'wallet_id': entity.walletId,
      'type': entity.type,
      'amount': entity.amount,
      'description': entity.description,
      'reference_type': entity.referenceType,
      'reference_id': entity.referenceId,
      'balance_after': entity.balanceAfter,
      'status': entity.status,
      'created_at': entity.createdAt,
    };
  }

}
