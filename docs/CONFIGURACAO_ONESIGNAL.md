# Configuração OneSignal

## Visão Geral
Este documento descreve como configurar o OneSignal para substituir o Firebase Cloud Messaging no projeto.

## 1. Criar Conta OneSignal

1. Acesse [OneSignal.com](https://onesignal.com)
2. Crie uma conta gratuita
3. Clique em "Add a new app"
4. Escolha "Mobile App" como plataforma

## 2. Configuração Android

### 2.1 Obter Server Key do Firebase (para compatibilidade)
1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Selecione seu projeto
3. Vá em "Project Settings" > "Cloud Messaging"
4. Copie o "Server key"

### 2.2 Configurar no OneSignal
1. No dashboard OneSignal, vá em "Settings" > "Platforms"
2. Clique em "Google Android (FCM)"
3. Cole o Server Key do Firebase
4. Salve as configurações

## 3. Configuração iOS (se aplicável)

### 3.1 Certificados Apple
1. No dashboard OneSignal, vá em "Settings" > "Platforms"
2. Clique em "Apple iOS"
3. Faça upload do certificado .p12 ou configure via AuthKey
4. Salve as configurações

## 4. Obter App ID

1. No dashboard OneSignal, vá em "Settings" > "Keys & IDs"
2. Copie o "OneSignal App ID"
3. Este será usado no código Flutter

## 5. Configuração no Código

### 5.1 Atualizar main.dart
```dart
// Em lib/main.dart, no initState:
OneSignalService.instance.initialize('SEU_ONESIGNAL_APP_ID');
```

### 5.2 Variáveis de Ambiente
Crie um arquivo `.env` na raiz do projeto:
```
ONESIGNAL_APP_ID=seu_app_id_aqui
```

## 6. Configuração Supabase

### 6.1 Atualizar Tabela app_users
```sql
-- Adicionar colunas para OneSignal
ALTER TABLE app_users 
ADD COLUMN onesignal_player_id TEXT,
ADD COLUMN push_token TEXT;

-- Índice para busca rápida
CREATE INDEX idx_app_users_onesignal_player_id ON app_users(onesignal_player_id);
```

### 6.2 Função para Envio de Notificações
```sql
-- Função para enviar notificações via OneSignal REST API
CREATE OR REPLACE FUNCTION enviar_notificacao_onesignal(
  player_ids TEXT[],
  titulo TEXT,
  mensagem TEXT,
  dados_adicionais JSONB DEFAULT '{}'::JSONB
) RETURNS JSONB AS $$
DECLARE
  resultado JSONB;
BEGIN
  -- Esta função deve fazer chamada HTTP para OneSignal REST API
  -- Implementar usando pg_net ou similar
  
  RETURN jsonb_build_object(
    'sucesso', true,
    'player_ids', player_ids,
    'titulo', titulo,
    'mensagem', mensagem
  );
END;
$$ LANGUAGE plpgsql;
```

## 7. Migração do Código Existente

### 7.1 Substituir Imports
```dart
// ANTES (Firebase)
import 'package:firebase_messaging/firebase_messaging.dart';
import '/custom_code/actions/fcm_service_completo.dart';

// DEPOIS (OneSignal)
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '/custom_code/actions/onesignal_service_completo.dart';
```

### 7.2 Substituir Chamadas de Função
```dart
// ANTES
await FCMServiceCompleto.instance.inicializarFCM();

// DEPOIS
await OneSignalServiceCompleto.instance.inicializarOneSignal('APP_ID');
```

## 8. Testes

### 8.1 Teste Manual
1. Execute o app em um dispositivo físico
2. Aceite as permissões de notificação
3. Verifique se o Player ID foi salvo no Supabase
4. Envie uma notificação teste pelo dashboard OneSignal

### 8.2 Teste Automatizado
```dart
// Em test/onesignal_test.dart
void main() {
  group('OneSignal Service', () {
    test('deve inicializar corretamente', () async {
      final resultado = await OneSignalServiceCompleto.instance
          .inicializarOneSignal('test_app_id');
      
      expect(resultado['sucesso'], true);
    });
  });
}
```

## 9. Monitoramento

### 9.1 Dashboard OneSignal
- Acompanhe métricas de entrega
- Monitore taxa de abertura
- Analise segmentação de usuários

### 9.2 Logs no App
```dart
// Habilitar logs detalhados em desenvolvimento
OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
```

## 10. Troubleshooting

### 10.1 Problemas Comuns

**Notificações não chegam:**
- Verificar se App ID está correto
- Confirmar permissões no dispositivo
- Checar se Player ID foi salvo no Supabase

**Erro de inicialização:**
- Verificar se dependência foi adicionada corretamente
- Confirmar configuração Android/iOS
- Checar logs do console

**Player ID nulo:**
- Aguardar alguns segundos após inicialização
- Verificar conexão com internet
- Reiniciar o app

### 10.2 Logs Úteis
```dart
// Verificar status
print('OneSignal inicializado: ${OneSignalServiceCompleto.instance.isInitialized}');
print('Player ID: ${OneSignalServiceCompleto.instance.playerId}');
print('Push Token: ${OneSignalServiceCompleto.instance.pushToken}');
```

## 11. Próximos Passos

1. ✅ Dependências adicionadas
2. ✅ Serviço OneSignal criado
3. ✅ Handlers configurados
4. 🔄 **ATUAL: Configurar App ID**
5. ⏳ Testar notificações
6. ⏳ Migrar código existente
7. ⏳ Remover dependências Firebase

## 12. Recursos Adicionais

- [Documentação OneSignal Flutter](https://documentation.onesignal.com/docs/flutter-sdk-setup)
- [OneSignal REST API](https://documentation.onesignal.com/reference/create-notification)
- [Dashboard OneSignal](https://app.onesignal.com)