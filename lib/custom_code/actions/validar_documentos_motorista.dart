import '/backend/supabase/supabase.dart';
import '/auth/firebase_auth/auth_util.dart';

/// Lista dos documentos obrigatórios para motoristas
const List<String> REQUIRED_DOCUMENT_TYPES = [
  'CNH_FRONT',      // CNH Frente
  'CNH_BACK',       // CNH Verso
  'CRLV',           // CRLV
  'VEHICLE_FRONT',  // Foto do Veículo (Frente)
];

/// Valida se o motorista tem todos os documentos obrigatórios aprovados
///
/// Retorna true se todos os documentos estão aprovados, false caso contrário
Future<bool> validarDocumentosMotorista() async {
  try {
    print('🔍 [DOC_VALIDATION] Iniciando validação de documentos do motorista');

    // Obter o driver_id do usuário atual
    final String? driverId = await _getDriverIdForCurrentUser();
    if (driverId == null) {
      print('❌ [DOC_VALIDATION] Driver não encontrado para o usuário atual');
      return false;
    }

    print('👤 [DOC_VALIDATION] Driver ID: $driverId');
    print('🔎 [DOC_VALIDATION] debug: driverId resolved');

    // Buscar todos os documentos aprovados do motorista
    final approvedDocs = await DriverDocumentsTable().queryRows(
      queryFn: (q) => q
          .eq('driver_id', driverId)
          .eq('status', 'approved')
          .eq('is_current', true),
    );

    print('📋 [DOC_VALIDATION] Documentos aprovados encontrados: ${approvedDocs.length}');
    print('🔎 [DOC_VALIDATION] debug: CAPTURADO approvedDocTypes a partir de approvedDocs');

    // Verificar se todos os tipos de documento obrigatórios estão presentes
    final approvedDocTypes = approvedDocs
        .map((doc) => doc.documentType)
        .where((type) => type != null)
        .cast<String>()
        .toSet();

    print('📄 [DOC_VALIDATION] Tipos de documento aprovados: $approvedDocTypes');
    print('🔎 [DOC_VALIDATION] debug: Documentos obrigatórios: $REQUIRED_DOCUMENT_TYPES');
    final missingTypes = REQUIRED_DOCUMENT_TYPES.where((t) => !approvedDocTypes.contains(t)).toList();
    if (missingTypes.isNotEmpty) {
      print('❌ [DOC_VALIDATION] Documentos obrigatórios ausentes: $missingTypes');
    } else {
      print('✅ [DOC_VALIDATION] Todos os documentos obrigatórios presentes');
    }

    // Verificar se todos os documentos obrigatórios estão aprovados
    for (String requiredType in REQUIRED_DOCUMENT_TYPES) {
      if (!approvedDocTypes.contains(requiredType)) {
        print('❌ [DOC_VALIDATION] Documento obrigatório faltando ou não aprovado: $requiredType');
        return false;
      }
    }

    print('✅ [DOC_VALIDATION] Todos os documentos obrigatórios estão aprovados');
    return true;

  } catch (e) {
    print('💥 [DOC_VALIDATION] Erro ao validar documentos: $e');
    return false;
  }
}

/// Obter o driver_id para o usuário atual
Future<String?> _getDriverIdForCurrentUser() async {
  try {
    // Tenta localizar o app_user pelo e-mail do Firebase Auth primeiro,
    // com fallback para o fcm_token (usando currentUserUid) caso não encontre.
    final String? email = currentUserEmail;
    final String? fcm = currentUserUid;

    List<AppUsersRow> appUsers = [];
    if (email != null && email.isNotEmpty) {
      appUsers = await AppUsersTable()
          .queryRows(queryFn: (q) => q.eq('email', email).limit(1));
    }
    if (appUsers.isEmpty && fcm != null && fcm.isNotEmpty) {
      appUsers = await AppUsersTable()
          .queryRows(queryFn: (q) => q.eq('fcm_token', fcm).limit(1));
    }

    if (appUsers.isEmpty) return null;
    final appUserId = appUsers.first.id;

    final drivers = await DriversTable()
        .queryRows(queryFn: (q) => q.eq('user_id', appUserId).limit(1));
    if (drivers.isEmpty) return null;

    return drivers.first.id;
  } catch (e) {
    print('💥 [DOC_VALIDATION] Erro ao obter driver ID: $e');
    return null;
  }
}

/// Verifica se o usuário atual é um motorista
Future<bool> isCurrentUserDriver() async {
  try {
    final String? email = currentUserEmail;
    final String? fcm = currentUserUid;

    List<AppUsersRow> appUsers = [];
    if (email != null && email.isNotEmpty) {
      appUsers = await AppUsersTable()
          .queryRows(queryFn: (q) => q.eq('email', email).limit(1));
    }
    if (appUsers.isEmpty && fcm != null && fcm.isNotEmpty) {
      appUsers = await AppUsersTable()
          .queryRows(queryFn: (q) => q.eq('fcm_token', fcm).limit(1));
    }

    if (appUsers.isEmpty) return false;

    return appUsers.first.userType == 'driver';
  } catch (e) {
    print('💥 [DOC_VALIDATION] Erro ao verificar se usuário é motorista: $e');
    return false;
  }
}