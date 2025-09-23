# Implementação do Campo currentUser_UID_Firebase

## Visão Geral

Este documento descreve a implementação do campo `currentUser_UID_Firebase` na tabela `app_users` do Supabase. Este campo armazena o ID único (`app_users.id`) do usuário no Supabase, criando uma referência interna que facilita operações de consulta e relacionamento.

## Motivação

O campo foi criado para:
- **Facilitar consultas**: Permitir acesso direto ao `app_users.id` sem necessidade de consultas adicionais
- **Otimizar performance**: Reduzir a necessidade de joins e consultas complexas
- **Melhorar rastreabilidade**: Criar uma referência interna consistente para auditoria
- **Simplificar relacionamentos**: Facilitar operações que requerem o UUID do Supabase

## Estrutura do Campo

### Definição no Modelo

**Arquivo**: `lib/backend/supabase/database/tables/app_users.dart`

```dart
// Getter para acessar o campo
String? get currentUserUidFirebase => getField<String>('currentUser_UID_Firebase');

// Setter para definir o campo
set currentUserUidFirebase(String? value) => setField<String>('currentUser_UID_Firebase', value);
```

### Características
- **Tipo**: `String?` (nullable)
- **Nome no banco**: `currentUser_UID_Firebase`
- **Propósito**: Armazenar o `app_users.id` (UUID do Supabase)
- **Preenchimento**: Automático após criação do usuário

## Implementação por Fluxo

### 1. Registro de Usuário

**Arquivo**: `lib/auth_option/escolha_seu_perfil/escolha_seu_perfil_widget.dart`

```dart
// 1. Campo incluído na criação inicial (vazio)
final newUserData = {
  // ... outros campos
  'currentUser_UID_Firebase': '', // Será preenchido após a inserção
};

// 2. Inserção do usuário
final newUser = await AppUsersTable().insert(newUserData);

// 3. Atualização do campo com o ID gerado
await AppUsersTable().update(
  data: {'currentUser_UID_Firebase': newUser.id},
  matchingRows: (rows) => rows.eq('id', newUser.id),
);
```

**Fluxo**:
1. Usuário é criado com campo vazio
2. Supabase gera UUID automático (`app_users.id`)
3. Campo é atualizado com o UUID gerado
4. Logs detalhados registram o processo

### 2. Login de Usuário

**Arquivo**: `lib/auth_option/login/login_widget.dart`

```dart
// Verificar se o campo precisa ser preenchido
if (_model.idusuario != null && _model.idusuario!.isNotEmpty) {
  final user = _model.idusuario!.first;
  
  // Atualizar se campo estiver vazio
  if (user.currentUserUidFirebase == null || user.currentUserUidFirebase!.isEmpty) {
    await AppUsersTable().update(
      data: {'currentUser_UID_Firebase': user.id},
      matchingRows: (rows) => rows.eq('id', user.id),
    );
  }
}
```

**Cenário**: Usuários existentes que não possuem o campo preenchido

### 3. Atualização de Foto (Selfie)

**Arquivo**: `lib/auth_option/selfie/selfie_widget.dart`

```dart
// Verificar e atualizar campo durante upload de foto
if (user.currentUserUidFirebase == null || user.currentUserUidFirebase!.isEmpty) {
  updateData['currentUser_UID_Firebase'] = user.id;
  print('🔄 [SELFIE] Atualizando currentUser_UID_Firebase para usuário: ${user.id}');
}

// Aplicar todas as atualizações
await AppUsersTable().update(
  data: updateData,
  matchingRows: (rows) => rows.eq('fcm_token', currentUserUid),
);
```

**Cenário**: Atualização oportunística durante outras operações

### 4. Função de Sincronização

**Arquivo**: `lib/actions/actions.dart`

```dart
Future updateUserSupabase(BuildContext context) async {
  try {
    final currentUserId = currentUserUid;
    if (currentUserId.isEmpty) {
      print('❌ [updateUserSupabase] Usuário não autenticado');
      return;
    }

    // Buscar usuário atual
    final userQuery = await AppUsersTable().queryRows(
      queryFn: (q) => q.eq('fcm_token', currentUserId).limit(1),
    );

    if (userQuery.isNotEmpty) {
      final user = userQuery.first;
      
      // Atualizar se necessário
      if (user.currentUserUidFirebase == null || user.currentUserUidFirebase!.isEmpty) {
        await AppUsersTable().update(
          data: {'currentUser_UID_Firebase': user.id},
          matchingRows: (rows) => rows.eq('id', user.id),
        );
      }
    }
  } catch (e) {
    print('❌ [updateUserSupabase] Erro: $e');
  }
}
```

**Propósito**: Função utilitária para sincronização manual

## Logs e Monitoramento

### Padrão de Logs

Todos os pontos de atualização incluem logs detalhados:

```dart
// Antes da atualização
print('🔄 [CONTEXTO] Atualizando currentUser_UID_Firebase para usuário: ${user.id}');

// Após sucesso
print('✅ [CONTEXTO] currentUser_UID_Firebase atualizado com sucesso!');

// Em caso de erro
print('❌ [CONTEXTO] Erro ao atualizar currentUser_UID_Firebase: $erro');
```

### Contextos de Log
- `[GET_OR_CREATE_USER]`: Durante registro
- `[LOGIN]`: Durante login
- `[SELFIE]`: Durante upload de foto
- `[updateUserSupabase]`: Durante sincronização manual

## Casos de Uso

### 1. Consultas Otimizadas
```dart
// Antes: Consulta com join
final result = await supabase
  .from('trips')
  .select('*, app_users!inner(*)')
  .eq('app_users.fcm_token', firebaseUid);

// Depois: Consulta direta
final user = await AppUsersTable().querySingleRow(
  queryFn: (q) => q.eq('fcm_token', firebaseUid),
);
final trips = await TripsTable().queryRows(
  queryFn: (q) => q.eq('passenger_id', user!.currentUserUidFirebase),
);
```

### 2. Relacionamentos Simplificados
```dart
// Criar viagem com referência direta
final tripData = {
  'passenger_id': user.currentUserUidFirebase, // UUID direto
  'driver_id': driver.currentUserUidFirebase,   // UUID direto
  // ... outros campos
};
```

### 3. Auditoria e Rastreamento
```dart
// Logs de auditoria com referência consistente
final auditLog = {
  'user_id': user.currentUserUidFirebase,
  'action': 'trip_created',
  'timestamp': DateTime.now().toIso8601String(),
};
```

## Migração de Dados Existentes

### Script SQL para Migração

```sql
-- Atualizar registros existentes que não possuem o campo
UPDATE app_users 
SET "currentUser_UID_Firebase" = id 
WHERE "currentUser_UID_Firebase" IS NULL 
   OR "currentUser_UID_Firebase" = '';
```

### Verificação de Integridade

```sql
-- Verificar registros sem o campo preenchido
SELECT COUNT(*) as registros_sem_campo
FROM app_users 
WHERE "currentUser_UID_Firebase" IS NULL 
   OR "currentUser_UID_Firebase" = '';

-- Verificar consistência dos dados
SELECT COUNT(*) as registros_inconsistentes
FROM app_users 
WHERE "currentUser_UID_Firebase" != id;
```

## Testes

### Script de Teste Automatizado

**Arquivo**: `test_currentuser_uid_firebase.dart`

O script verifica:
1. ✅ Campo no modelo `app_users.dart`
2. ✅ Implementação no registro
3. ✅ Implementação no login
4. ✅ Implementação na selfie
5. ✅ Função `updateUserSupabase`

**Execução**:
```bash
dart test_currentuser_uid_firebase.dart
```

**Resultado esperado**: `5/5 testes passaram`

## Considerações de Performance

### Benefícios
- **Redução de JOINs**: Consultas mais rápidas
- **Índices otimizados**: Melhor performance em consultas
- **Cache eficiente**: Dados mais facilmente cacheáveis

### Overhead
- **Espaço adicional**: ~36 bytes por registro (UUID)
- **Sincronização**: Lógica adicional de atualização
- **Consistência**: Necessidade de manter dados sincronizados

## Manutenção

### Monitoramento
1. **Logs de aplicação**: Verificar atualizações bem-sucedidas
2. **Consultas SQL**: Monitorar registros inconsistentes
3. **Métricas de performance**: Acompanhar impacto nas consultas

### Troubleshooting

**Problema**: Campo vazio em usuários existentes
**Solução**: Executar `updateUserSupabase()` ou script SQL de migração

**Problema**: Inconsistência entre `id` e `currentUser_UID_Firebase`
**Solução**: Executar script de verificação e correção

**Problema**: Performance degradada
**Solução**: Verificar índices e otimizar consultas

## Conclusão

A implementação do campo `currentUser_UID_Firebase` fornece uma solução robusta para otimização de consultas e simplificação de relacionamentos no sistema. A implementação gradual garante compatibilidade com dados existentes, enquanto os logs detalhados facilitam o monitoramento e debugging.

### Status da Implementação
- ✅ **Modelo de dados**: Implementado
- ✅ **Fluxo de registro**: Implementado
- ✅ **Fluxo de login**: Implementado
- ✅ **Atualização de foto**: Implementado
- ✅ **Função de sincronização**: Implementado
- ✅ **Testes automatizados**: Implementado
- ✅ **Documentação**: Completa

**Próximos passos**:
1. Monitorar logs de produção
2. Executar migração de dados existentes
3. Otimizar consultas utilizando o novo campo
4. Implementar métricas de performance