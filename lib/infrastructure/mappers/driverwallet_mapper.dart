import '/backend/supabase/supabase.dart';
// lib/infrastructure/mappers/driverwallet_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/driverwallet.dart';
import '../../backend/supabase/database/tables/driver_wallets.dart';
import '../../domain/value_objects/email.dart';

class DriverWalletMapper {
  DriverWallet toDomain(DriverWalletsRow row) {
    return DriverWallet(
      id: row.id,
      email: Email(row.email!),
      availableBalance: row.availableBalance,
      pendingBalance: row.pendingBalance,
      totalEarned: row.totalEarned,
      totalWithdrawn: row.totalWithdrawn,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
  
  Map<String, dynamic> toSupabase(DriverWallet entity) {
    return {
      'id': entity.id,
      'email': entity.email.value,
      'available_balance': entity.availableBalance,
      'pending_balance': entity.pendingBalance,
      'total_earned': entity.totalEarned,
      'total_withdrawn': entity.totalWithdrawn,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
    };
  }

}
