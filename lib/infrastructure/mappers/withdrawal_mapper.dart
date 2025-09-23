// lib/infrastructure/mappers/withdrawal_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/withdrawal.dart';
import '../../backend/supabase/database/tables/withdrawals.dart';


class WithdrawalMapper {
  Withdrawal toDomain(WithdrawalsRow row) {
    return Withdrawal(
      id: row.id,
      driverId: row.driverId,
      walletId: row.walletId,
      amount: row.amount,
      withdrawalMethod: row.withdrawalMethod,
      bankAccountInfo: row.bankAccountInfo,
      asaasTransferId: row.asaasTransferId,
      status: row.status,
      failureReason: row.failureReason,
      requestedAt: row.requestedAt,
      processedAt: row.processedAt,
      completedAt: row.completedAt,
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
