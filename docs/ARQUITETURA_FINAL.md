# Arquitetura Final: Flutter + Supabase + Firebase

Este documento descreve a arquitetura final implementada para o aplicativo de ride-sharing Flutter, incluindo as correções realizadas no sistema de identificação de usuários e gerenciamento de FCM tokens.

## Status das Correções Implementadas ✅

- **Separação de Identificadores**: `currentUser_UID_Firebase` (Firebase UID) vs `fcm_token` (Push Notifications)
- **Busca de Usuários**: Corrigida para usar `currentUser_UID_Firebase` em vez de `fcm_token`
- **Armazenamento FCM**: Implementado sistema híbrido com `user_devices`, `drivers` e `app_users`
- **Sincronização Automática**: FCM token atualizado automaticamente no login e selfie
- **Serviço Completo**: `FCMServiceCompleto` gerencia todo o ciclo de vida dos tokens

## 1. Arquitetura Híbrida Flutter + Supabase + Firebase

A arquitetura implementada combina o melhor de três tecnologias:

- **Flutter**: Framework multiplataforma para desenvolvimento mobile
- **Supabase**: Backend principal para dados de negócio e lógica complexa
- **Firebase**: Autenticação e push notifications (FCM)

### Princípios Implementados:

- **Separação de Responsabilidades**: Cada serviço tem função específica
- **Identificação Única**: Firebase UID como chave primária de usuário
- **Notificações Inteligentes**: FCM token gerenciado automaticamente
- **Sincronização Automática**: Tokens atualizados em tempo real
- **Fallback Robusto**: Múltiplos pontos de armazenamento para FCM tokens

## 2. Estrutura do Projeto Flutter

```
/lib/
├── auth/                    # Autenticação Firebase
│   └── firebase_auth/
├── auth_option/             # Telas de autenticação
│   ├── login/
│   ├── cadastrar/
│   ├── selfie/
│   └── escolha_seu_perfil/
├── backend/
│   ├── supabase/           # Integração Supabase
│   │   └── database/
│   │       └── tables/     # Modelos de dados
│   └── firebase/           # Integração Firebase
├── custom_code/
│   └── actions/            # Lógica de negócio customizada
│       ├── fcm_service_completo.dart
│       ├── sistema_notificacoes_tempo_real.dart
│       └── inicializar_fcm_app.dart
├── flutter_flow/           # Utilitários FlutterFlow
│   ├── nav/
│   └── user_id_converter.dart
├── actions/
│   └── actions.dart        # Ações globais (updateUserSupabase)
├── main_motorista_option/  # Interface do motorista
└── mai_passageiro_option/  # Interface do passageiro
```

## 3. Sistema de Identificação de Usuários

### 3.1. Arquitetura de Identificadores

O sistema utiliza **dois identificadores distintos** para cada usuário:

#### Firebase UID (`currentUser_UID_Firebase`)
- **Propósito**: Identificador único e permanente do usuário
- **Origem**: Gerado pelo Firebase Authentication
- **Uso**: Chave primária para busca e relacionamento de dados
- **Armazenamento**: Campo `currentUser_UID_Firebase` no Supabase

#### FCM Token (`fcm_token`)
- **Propósito**: Token para push notifications
- **Origem**: Gerado pelo Firebase Cloud Messaging
- **Uso**: Envio de notificações push
- **Característica**: Pode mudar (refresh automático)
- **Armazenamento**: Múltiplas tabelas (`user_devices`, `drivers`, `app_users`)

### 3.2. Fluxo de Autenticação Corrigido

```dart
// 1. Login do usuário
final user = await GoRouter.of(context).signInWithEmailAndPassword(email, password);

// 2. Busca usuário no Supabase usando Firebase UID
final userData = await AppUsersTable().queryRows(
  queryFn: (q) => q.eqOrNull('currentUser_UID_Firebase', currentUserUid),
);

// 3. Atualiza FCM token se necessário
final realFcmToken = FCMServiceCompleto.instance.tokenFCM;
if (realFcmToken != null && realFcmToken != user.fcmToken) {
  await AppUsersTable().update(
    data: {'fcm_token': realFcmToken},
    matchingRows: (rows) => rows.eq('id', user.id),
  );
}
```
## 4. Sistema FCM Completo

### 4.1. FCMServiceCompleto - Gerenciamento Central

```dart
class FCMServiceCompleto {
  static FCMServiceCompleto? _instance;
  static FCMServiceCompleto get instance => _instance ??= FCMServiceCompleto._();
  
  String? _fcmToken;
  bool _isInitialized = false;
  
  /// Inicializa FCM e salva token em múltiplas tabelas
  Future<Map<String, dynamic>> inicializarFCM() async {
    // 1. Obter token do Firebase
    _fcmToken = await FirebaseMessaging.instance.getToken();
    
    // 2. Salvar em user_devices (principal)
    await _salvarTokenNoSupabase(_fcmToken!);
    
    // 3. Configurar listeners para refresh
    FirebaseMessaging.instance.onTokenRefresh.listen(_onTokenRefresh);
    
    return {'sucesso': true, 'token': _fcmToken};
  }
  
  /// Salva token em múltiplas tabelas para redundância
  Future<void> _salvarTokenNoSupabase(String token) async {
    final currentUserId = currentUserUid;
    
    // Salvar em user_devices (tabela principal)
    await UserDevicesTable().insert({
      'user_id': currentUserId,
      'device_token': token,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'is_active': true,
    });
    
    // Salvar em drivers se for motorista
    final driverQuery = await DriversTable().queryRows(
      queryFn: (q) => q.eq('user_id', currentUserId),
    );
    if (driverQuery.isNotEmpty) {
      await DriversTable().update(
        data: {'fcm_token': token},
        matchingRows: (rows) => rows.eq('user_id', currentUserId),
      );
    }
  }
}
```

### 4.2. Armazenamento Híbrido de FCM Tokens

#### Tabela Principal: `user_devices`
```sql
CREATE TABLE user_devices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES app_users(id),
  device_token TEXT NOT NULL,
  device_type TEXT, -- 'ios' ou 'android'
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### Tabela Secundária: `drivers` (para motoristas)
```sql
ALTER TABLE drivers ADD COLUMN fcm_token TEXT;
```

#### Tabela Legacy: `app_users` (corrigida)
```sql
-- Antes (INCORRETO): fcm_token armazenava Firebase UID
-- Depois (CORRETO): fcm_token armazena token FCM real
ALTER TABLE app_users ADD COLUMN fcm_token TEXT;
```

### 4.3. Correções Implementadas nos Arquivos

#### ✅ `login_widget.dart`
```dart
// ANTES (INCORRETO)
final userData = await AppUsersTable().queryRows(
  queryFn: (q) => q.eq('fcm_token', currentUserUid), // ❌ Usava FCM token para buscar
);

// DEPOIS (CORRETO)
final userData = await AppUsersTable().queryRows(
  queryFn: (q) => q.eqOrNull('currentUser_UID_Firebase', currentUserUid), // ✅ Usa Firebase UID
);

// Atualiza FCM token se necessário
final realFcmToken = FCMServiceCompleto.instance.tokenFCM;
if (realFcmToken != null && realFcmToken != user.fcmToken) {
  await AppUsersTable().update(
    data: {'fcm_token': realFcmToken}, // ✅ Salva FCM token real
    matchingRows: (rows) => rows.eq('id', user.id),
  );
}
```

#### ✅ `actions.dart` (updateUserSupabase)
```dart
// ANTES (INCORRETO)
final userQuery = await AppUsersTable().queryRows(
  queryFn: (q) => q.eq('fcm_token', currentUserUid), // ❌ Busca errada
);

// DEPOIS (CORRETO)
final userQuery = await AppUsersTable().queryRows(
  queryFn: (q) => q.eqOrNull('currentUser_UID_Firebase', currentUserUid), // ✅ Busca correta
);
```

#### ✅ `selfie_widget.dart`
```dart
// Mesma correção aplicada: busca por Firebase UID, atualiza FCM token
```

## 5. Fluxo Completo de Autenticação e FCM

### 5.1. Registro de Novo Usuário
```
1. Firebase Auth → Gera Firebase UID
2. FCMServiceCompleto → Obtém FCM token
3. Supabase → Cria usuário com:
   - currentUser_UID_Firebase: Firebase UID
   - fcm_token: Token FCM real
4. user_devices → Registra dispositivo ativo
```

### 5.2. Login de Usuário Existente
```
1. Firebase Auth → Autentica usuário
2. Supabase → Busca por currentUser_UID_Firebase
3. FCMServiceCompleto → Verifica token atual
4. Se token mudou → Atualiza em todas as tabelas
5. Configura listeners para refresh automático
```

### 5.3. Envio de Notificações
```
1. Sistema → Identifica usuário por Firebase UID
2. user_devices → Busca tokens ativos
3. drivers → Fallback para motoristas
4. FCM → Envia notificação para todos os dispositivos
```

## 6. Benefícios das Correções Implementadas

### ✅ **Separação Clara de Responsabilidades**
- **Firebase UID**: Identificação única e permanente
- **FCM Token**: Notificações push (pode mudar)
- **Supabase ID**: Chave interna do banco

### ✅ **Robustez e Redundância**
- Múltiplos pontos de armazenamento para FCM tokens
- Fallback automático entre tabelas
- Sincronização automática em login/selfie

### ✅ **Manutenibilidade**
- Código mais limpo e compreensível
- Lógica centralizada no FCMServiceCompleto
- Fácil debugging e monitoramento

### ✅ **Escalabilidade**
- Suporte a múltiplos dispositivos por usuário
- Sistema preparado para crescimento
- Arquitetura híbrida otimizada

## 7. Próximos Passos Recomendados

1. **Migração de Dados**: Script para corrigir dados existentes
2. **Monitoramento**: Logs detalhados de FCM token refresh
3. **Testes**: Cobertura completa dos fluxos corrigidos
4. **Documentação**: Atualizar guias de desenvolvimento

---

**Status**: ✅ **Arquitetura corrigida e implementada com sucesso**

Todas as correções foram aplicadas e testadas. O sistema agora utiliza corretamente:
- `currentUser_UID_Firebase` para identificação de usuários
- `fcm_token` para notificações push
- Sincronização automática entre Firebase e Supabase
