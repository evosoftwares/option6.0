// lib/infrastructure/mappers/wallettransaction_mapper.dart
import '../../domain/entities/wallettransaction.dart';
import '../../backend/supabase/database/tables/wallet_transactions.dart';

class WalletTransactionMapper {
  WalletTransaction toDomain(WalletTransactionsRow row) {
    return WalletTransaction(
      id: row.id,
      walletId: row.walletId ?? '',
      type: (row.type ?? '').toString(),
      amount: (() {
        final v = row.amount;
        if (v is num) return v.toDouble();
        if (v is String) return double.tryParse(v) ?? 0.0;
        return 0.0;
      })(),
      description: row.description ?? '',
      referenceType: row.referenceType ?? '',
      referenceId: row.referenceId ?? '',
      balanceAfter: (() {
        final v = row.balanceAfter;
        if (v is num) return v.toDouble();
        if (v is String) return double.tryParse(v) ?? 0.0;
        return 0.0;
      })(),
      status: (row.status ?? '').toString(),
      createdAt: row.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
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
