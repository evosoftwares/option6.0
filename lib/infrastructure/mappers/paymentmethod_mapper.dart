// lib/infrastructure/mappers/paymentmethod_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/paymentmethod.dart';
import '../../backend/supabase/database/tables/payment_methods.dart';


class PaymentMethodMapper {
  PaymentMethod toDomain(PaymentMethodsRow row) {
    return PaymentMethod(
      id: row.id,
      userId: row.userId,
      type: row.type,
      isDefault: row.isDefault,
      isActive: row.isActive,
      cardData: row.cardData,
      pixData: row.pixData,
      asaasCustomerId: row.asaasCustomerId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
  
  Map<String, dynamic> toSupabase(PaymentMethod entity) {
    return {
      'id': entity.id,
      'user_id': entity.userId,
      'type': entity.type,
      'is_default': entity.isDefault,
      'is_active': entity.isActive,
      'card_data': entity.cardData,
      'pix_data': entity.pixData,
      'asaas_customer_id': entity.asaasCustomerId,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
    };
  }

}
