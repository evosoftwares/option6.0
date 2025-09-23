// lib/infrastructure/mappers/passengerwallettransaction_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/passengerwallettransaction.dart';
import '../../backend/supabase/database/tables/passenger_wallet_transactions.dart';


class PassengerWalletTransactionMapper {
  PassengerWalletTransaction toDomain(PassengerWalletTransactionsRow row) {
    return PassengerWalletTransaction(
      id: row.id,
      walletId: row.walletId,
      passengerId: row.passengerId,
      type: row.type,
      amount: row.amount,
      description: row.description,
      tripId: row.tripId,
      paymentMethodId: row.paymentMethodId,
      asaasPaymentId: row.asaasPaymentId,
      status: row.status,
      metadata: row.metadata,
      createdAt: row.createdAt,
      processedAt: row.processedAt,
    );
  }
  
  Map<String, dynamic> toSupabase(PassengerWalletTransaction entity) {
    return {
      'id': entity.id,
      'wallet_id': entity.walletId,
      'passenger_id': entity.passengerId,
      'type': entity.type,
      'amount': entity.amount,
      'description': entity.description,
      'trip_id': entity.tripId,
      'payment_method_id': entity.paymentMethodId,
      'asaas_payment_id': entity.asaasPaymentId,
      'status': entity.status,
      'metadata': entity.metadata,
      'created_at': entity.createdAt,
      'processed_at': entity.processedAt,
    };
  }

}
