// =====================================================
// FUNÇÕES FIREBASE FIRESTORE DEPRECIADAS
// =====================================================
//
// ATENÇÃO: Este arquivo documenta as funções Firebase que foram
// substituídas pelo sistema Supabase + Sistema Inteligente
//
// ❌ NÃO USAR MAIS estas funções
// ✅ USAR as novas funções Supabase
//
// =====================================================

/*

❌ DEPRECIADAS - Substituídas pelo Sistema Inteligente:

1. aceitar_corrida.dart
   ┌─ Substituída por: aceitar_viagem_supabase.dart
   ├─ Motivo: Usava Firebase Firestore
   ├─ Nova função: aceitarViagemSupabase()
   └─ Status: DEPRECATED ❌

2. encontrar_motoristas_disponiveis.dart
   ┌─ Substituída por: RPC buscar_motoristas_inteligentes + solicitar_viagem_inteligente.dart
   ├─ Motivo: Usava Firebase Firestore + sem algoritmo de scoring
   ├─ Nova função: RPC buscar_motoristas_inteligentes (Supabase)
   └─ Status: DEPRECATED ❌

3. encontrar_motoristas_disponiveis_dinheiro.dart
   ┌─ Substituída por: RPC buscar_motoristas_inteligentes + solicitar_viagem_inteligente.dart
   ├─ Motivo: Usava Firebase Firestore + lógica duplicada
   ├─ Nova função: RPC buscar_motoristas_inteligentes (Supabase)
   └─ Status: DEPRECATED ❌

═══════════════════════════════════════════════════════════════

✅ MIGRAÇÃO COMPLETA:

Sistema Antigo (Firebase Firestore):
┌─ Firebase Auth (✅ mantido)
├─ Firebase FCM (✅ mantido)
├─ Firestore para dados (❌ removido)
├─ Firestore para motoristas (❌ removido)
├─ Firestore para viagens (❌ removido)
└─ Algoritmo simples (❌ removido)

Sistema Novo (Supabase + IA):
┌─ Firebase Auth (✅ mantido)
├─ Firebase FCM (✅ melhorado)
├─ Supabase para dados (✅ novo)
├─ RPC functions otimizadas (✅ novo)
├─ Algoritmo inteligente de scoring (✅ novo)
├─ Fallback automático (✅ novo)
├─ Notificações tempo real (✅ novo)
└─ Sistema de timeout (✅ novo)

═══════════════════════════════════════════════════════════════

🔄 COMO MIGRAR SEU CÓDIGO:

// ❌ ANTIGO (Firebase)
Future<List<DocumentReference>?> encontrarMotoristas() async {
  final firestore = FirebaseFirestore.instance;
  final querySnapshot = await firestore
      .collection('perfisMotorista')
      .where('statusAtual', isEqualTo: true)
      .get();
  // ... lógica complexa ...
}

// ✅ NOVO (Supabase + IA)
Future<List<Map<String, dynamic>>> buscarMotoristasInteligente() async {
  return await solicitarViagemInteligente(
    passengerId: currentUserUid!,
    originLatitude: lat,
    originLongitude: lon,
    vehicleCategory: 'standard',
    // ... outros parâmetros ...
  );
}

═══════════════════════════════════════════════════════════════

📋 CHECKLIST DE SUBSTITUIÇÃO:

□ Substituir aceitar_corrida() por aceitarViagemSupabase()
□ Substituir encontrar_motoristas_disponiveis() por solicitarViagemInteligente()
□ Substituir encontrar_motoristas_disponiveis_dinheiro() por solicitarViagemInteligente()
□ Testar fluxo completo de solicitação
□ Testar aceitação de viagem
□ Validar notificações FCM
□ Confirmar timeout automático
□ Validar fallback de motoristas

═══════════════════════════════════════════════════════════════

⚠️ ARQUIVOS PARA ANÁLISE ADICIONAL:

Estes arquivos também usam Firebase mas podem ser de outras funcionalidades:

📁 Relacionados a Prestadores (não ride-sharing):
├─ buscar_prestadores.dart
├─ criar_missoes_prestadores.dart
├─ get_eligible_categories.dart
├─ get_marcas_from_produtos.dart
├─ get_refs_de_usuarios_por_perfis.dart
└─ lista_users_da_lista_prestadores.dart

📁 Widgets (verificar uso):
├─ lista_pretadores_escolha.dart
├─ localizacao_produtos_agrupados.dart
├─ seletor_de_produtos.dart
└─ visor_validade_relatorio.dart

❓ Status: PRECISA ANÁLISE - podem ser de outras funcionalidades do app
   que não relacionadas ao ride-sharing

═══════════════════════════════════════════════════════════════

✅ ARQUIVOS CORRETOS PARA USAR:

🚗 Sistema de Viagens:
├─ solicitar_viagem_inteligente.dart (✅)
├─ aceitar_viagem_supabase.dart (✅)
├─ conectar_interface_passageiro.dart (✅)
├─ sistema_notificacoes_tempo_real.dart (✅)
├─ fcm_service_completo.dart (✅)
└─ inicializar_fcm_app.dart (✅)

📊 Sistema Supabase:
├─ supabase_rpc_functions.sql (✅)
└─ todas as tabelas em /backend/supabase/database/ (✅)

🔑 Firebase (mantidos):
├─ Firebase Auth (✅)
└─ Firebase FCM (✅)

═══════════════════════════════════════════════════════════════

🎯 RESULTADO FINAL:

Sistema híbrido otimizado:
✅ Firebase para Auth e Push Notifications
✅ Supabase para dados e business logic
✅ IA para matching inteligente
✅ Tempo real para notificações
❌ Zero dependência do Firestore

*/