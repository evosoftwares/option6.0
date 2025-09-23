// lib/infrastructure/mappers/passengerwallet_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/passengerwallet.dart';
import '../../backend/supabase/database/tables/passenger_wallets.dart';
import '../../domain/value_objects/email.dart';

class PassengerWalletMapper {
  PassengerWallet toDomain(PassengerWalletsRow row) {
    return PassengerWallet(
      id: row.id,
      passengerId: row.passengerId,
      email: Email(row.email!),
      availableBalance: row.availableBalance,
      pendingBalance: row.pendingBalance,
      totalSpent: row.totalSpent,
      totalCashback: row.totalCashback,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
  
  Map<String, dynamic> toSupabase(PassengerWallet entity) {
    return {
      'id': entity.id,
      'passenger_id': entity.passengerId,
      'email': entity.email.value,
      'available_balance': entity.availableBalance,
      'pending_balance': entity.pendingBalance,
      'total_spent': entity.totalSpent,
      'total_cashback': entity.totalCashback,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
    };
  }

}
