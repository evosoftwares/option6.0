// lib/infrastructure/mappers/paymentmethod_mapper.dart
import '../../domain/entities/paymentmethod.dart';
import '../../backend/supabase/database/tables/payment_methods.dart';


class PaymentMethodMapper {
  PaymentMethod toDomain(PaymentMethodsRow row) {
    return PaymentMethod(
      id: row.id,
      userId: row.userId ?? '',
      type: row.type ?? '',
      isDefault: row.isDefault ?? false,
      isActive: row.isActive ?? false,
      cardData: row.cardData,
      pixData: row.pixData,
      asaasCustomerId: row.asaasCustomerId,
      createdAt: row.createdAt ?? DateTime.now(),
      updatedAt: row.updatedAt ?? DateTime.now(),
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
