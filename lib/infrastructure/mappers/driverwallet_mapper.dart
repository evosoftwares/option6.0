import '/backend/supabase/supabase.dart';
// lib/infrastructure/mappers/driverwallet_mapper.dart
import '../../domain/entities/driverwallet.dart';
import '../../backend/supabase/database/tables/driver_wallets.dart';
import '../../domain/value_objects/email.dart';

class DriverWalletMapper {
  DriverWallet toDomain(DriverWalletsRow row) {
    return DriverWallet(
      id: row.id,
      email: Email(row.email ?? 'placeholder@example.com'),
      availableBalance: row.availableBalance,
      pendingBalance: row.pendingBalance,
      totalEarned: row.totalEarned,
      totalWithdrawn: row.totalWithdrawn,
      createdAt: row.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: row.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
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
