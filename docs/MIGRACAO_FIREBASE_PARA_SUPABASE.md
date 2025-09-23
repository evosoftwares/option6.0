# Migração Firebase → Supabase

## ✅ O que MANTER do Firebase

### 🔐 Firebase Auth (MANTER)
- **Motivo**: Sistema de autenticação principal
- **user_id**: Continua sendo a chave primária em todas as tabelas Supabase
- **Arquivos a manter**:
  - `/auth/firebase_auth/auth_util.dart`
  - Toda configuração de autenticação
  - `currentUserUid` e funções relacionadas

### 📱 Firebase Cloud Messaging (MANTER)
- **Motivo**: Sistema de push notifications
- **Arquivos novos criados**:
  - `fcm_service_completo.dart` (✅ CRIADO)
  - `inicializar_fcm_app.dart` (✅ CRIADO)
- **Arquivos existentes a manter**:
  - Configuração FCM no `main.dart`
  - `google-services.json` e configurações iOS

## ❌ O que REMOVER do Firebase

### 🗄️ Firebase Firestore (SUBSTITUÍDO por Supabase)

#### Arquivos para DEPRECAR/REMOVER:

1. **`aceitar_corrida.dart`** ❌
   - **Substituído por**: `aceitar_viagem_supabase.dart` ✅
   - **Problema**: Usa `FirebaseFirestore.instance`
   - **Status**: DEPRECATED

2. **Imports do Firestore** ❌
   - **Linha 2**: `import '/backend/backend.dart';` (se contém Firestore)
   - **Verificar**: Se backend.dart usa apenas Firestore ou tem outras funções

3. **Referências DocumentReference** ❌
   - **Problema**: `DocumentReference` é específico do Firestore
   - **Substituído por**: Strings UUID do Supabase

## 🔄 Plano de Migração

### Fase 1: Identificar Arquivos Legados
```bash
# Buscar arquivos que usam Firestore
grep -r "FirebaseFirestore" lib/custom_code/
grep -r "DocumentReference" lib/custom_code/
grep -r "import '/backend/backend.dart'" lib/custom_code/
```

### Fase 2: Atualizar Referencias
- Substituir `aceitar_corrida()` por `aceitarViagemSupabase()`
- Atualizar widgets que chamam funções legadas
- Verificar se `encontrar_motoristas_disponiveis_dinheiro.dart` usa Firestore

### Fase 3: Limpar Imports
- Remover imports desnecessários do Firestore
- Manter apenas imports necessários para Auth

### Fase 4: Teste e Validação
- Testar fluxo completo de solicitação de viagem
- Validar notificações FCM
- Confirmar que Auth continua funcionando

## 📋 Checklist de Arquivos

### ✅ Arquivos Supabase (MANTER)
- `solicitar_viagem_inteligente.dart`
- `aceitar_viagem_supabase.dart`
- `conectar_interface_passageiro.dart`
- `sistema_notificacoes_tempo_real.dart`
- `fcm_service_completo.dart` (NOVO)
- `inicializar_fcm_app.dart` (NOVO)

### ❓ Arquivos para ANALISAR
- `encontrar_motoristas_disponiveis_dinheiro.dart`
- `buscar_prestadores.dart`
- `criar_missoes_prestadores.dart`
- Outros arquivos em `/custom_code/actions/`

### ❌ Arquivos para DEPRECAR
- `aceitar_corrida.dart` (substituído)
- Qualquer arquivo que use `FirebaseFirestore.instance`

## 🚨 IMPORTANTE

### Não Tocar:
1. **Firebase Auth**: Essencial para `currentUserUid`
2. **FCM**: Essencial para push notifications
3. **google-services.json**: Necessário para Auth e FCM
4. **main.dart**: Firebase.initializeApp() ainda é necessário

### Pode Remover:
1. **Firestore imports** não relacionados a Auth
2. **DocumentReference** e tipos específicos do Firestore
3. **Transações** do Firestore (substituídas por Supabase)
4. **Queries** do Firestore (substituídas por Supabase)

## 🎯 Objetivo Final

**Sistema Híbrido Otimizado:**
- ✅ Firebase Auth (user_id)
- ✅ Firebase FCM (push notifications)
- ✅ Supabase (todos os dados e business logic)
- ❌ Firebase Firestore (removido)

## 📄 Próximos Passos

1. ✅ RPC Functions criadas no Supabase
2. ✅ FCM Service completo implementado
3. 🔄 **ATUAL**: Identificar e remover código Firestore legado
4. ⏳ Melhorar validação de rotas
5. ⏳ Sistema de analytics
6. ⏳ Testes automatizados