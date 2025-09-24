// lib/infrastructure/mappers/withdrawal_mapper.dart
import '../../domain/entities/withdrawal.dart';
import '../../backend/supabase/database/tables/withdrawals.dart';

class WithdrawalMapper {
  Withdrawal toDomain(WithdrawalsRow row) {
    return Withdrawal(
      id: row.id,
      driverId: row.driverId ?? '',
      walletId: row.walletId ?? '',
      amount: row.amount is num ? (row.amount as num).toDouble() : 0.0,
      withdrawalMethod: row.withdrawalMethod ?? '',
      bankAccountInfo: row.bankAccountInfo,
      asaasTransferId: row.asaasTransferId ?? '',
      status: row.status ?? '',
      failureReason: row.failureReason ?? '',
      requestedAt: row.requestedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      processedAt: row.processedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      completedAt: row.completedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
  
  Map<String, dynamic> toSupabase(Withdrawal entity) {
    return {
      'id': entity.id,
      'driver_id': entity.driverId,
      'wallet_id': entity.walletId,
      'amount': entity.amount,
      'withdrawal_method': entity.withdrawalMethod,
      'bank_account_info': entity.bankAccountInfo,
      'asaas_transfer_id': entity.asaasTransferId,
      'status': entity.status,
      'failure_reason': entity.failureReason,
      'requested_at': entity.requestedAt,
      'processed_at': entity.processedAt,
      'completed_at': entity.completedAt,
    };
  }

}
