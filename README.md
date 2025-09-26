
# Documentação: Refatoração de API com Edge Functions (Proxy Seguro)

**Autor:** Marcelo V.  
**Data:** 26 de Setembro de 2025

## 1. Objetivo

O objetivo desta refatoração foi eliminar as chaves de API secretas (`access_token` do Asaas) que estavam expostas ("hardcoded") no código do aplicativo Flutter (`api_calls.dart`). Esta mudança aumenta drasticamente a segurança do aplicativo, impedindo que as credenciais sejam extraídas por engenharia reversa.

Esta implementação cumpre o requisito da **Seção 5.1 do "Plano de Implementação: Bootstrap Financeiro com Asaas"**.

## 2. Arquitetura da Solução

A estratégia adotada foi o padrão de **Proxy Seguro**, onde o aplicativo não se comunica mais diretamente com a API externa, mas sim com o nosso próprio backend, que atua como um intermediário confiável.

#### Arquitetura Antiga (Insegura)

`App Flutter` → `API Externa (Asaas)`  
*(A chave de API viajava junto com a requisição, presente no código do app)*

#### Nova Arquitetura (Segura)

`App Flutter` → `Supabase Edge Function (com Auth JWT)` → `API Externa (Asaas)`  
*(O app se autentica com a Edge Function usando o token do usuário. A Edge Function, no servidor, usa a chave de API secreta para se comunicar com o Asaas.)*

## 3. Componentes Implementados

### 3.1. Edge Functions (Backend)

Foram criadas e publicadas **6 novas Edge Functions** no Supabase. Cada uma é responsável por intermediar uma chamada específica para a API do Asaas.

**Endereçamento e Responsabilidades:**

- **`criar-cobranca-asaas`**  
  - **Endpoint:** `https://qlbwacmavngtonauxnte.supabase.co/functions/v1/criar-cobranca-asaas`  
  - **Responsabilidade:** Recebe os dados de uma nova cobrança do app, adiciona a chave de API e os envia para o endpoint `/v3/payments` do Asaas.

- **`criar-cliente-asaas`**  
  - **Endpoint:** `https://qlbwacmavngtonauxnte.supabase.co/functions/v1/criar-cliente-asaas`  
  - **Responsabilidade:** Recebe os dados de um novo cliente, adiciona a chave de API e os envia para o endpoint `/v3/customers` do Asaas.

- **`iniciar-saque-asaas`**  
  - **Endpoint:** `https://qlbwacmavngtonauxnte.supabase.co/functions/v1/iniciar-saque-asaas`  
  - **Responsabilidade:** Recebe os dados de uma solicitação de saque, adiciona a chave de API e os envia para o endpoint `/v3/transfers` do Asaas.

- **`obter-qr-code`**  
  - **Endpoint:** `https://qlbwacmavngtonauxnte.supabase.co/functions/v1/obter-qr-code`  
  - **Responsabilidade:** Recebe um ID de pagamento (`paymentId`), adiciona a chave de API e consulta o endpoint `/v3/payments/{id}/pixQrCode` do Asaas.

- **`checar-status-cobranca`**  
  - **Endpoint:** `https://qlbwacmavngtonauxnte.supabase.co/functions/v1/checar-status-cobranca`  
  - **Responsabilidade:** Recebe um ID de pagamento (`paymentId`), adiciona a chave de API e consulta o endpoint `/v3/payments/{id}/status` do Asaas.

### 3.2. Módulo Compartilhado

Para evitar a repetição de código, foi criado um módulo de configuração de CORS compartilhado.

- **Arquivo:** `supabase/functions/_shared/cors.ts`  
- **Responsabilidade:** Exporta os cabeçalhos `corsHeaders` necessários para que os navegadores possam fazer requisições para as Edge Functions. Todas as funções importam este módulo.

### 3.3. Refatoração no App Flutter (`api_calls.dart`)

O arquivo que define as chamadas de API do aplicativo foi completamente refatorado.

**Exemplo da Mudança (Classe `SaqueCall`):**

**Antes:**

```dart
// Chamava diretamente o Asaas e expunha a chave
apiUrl: 'https://api.asaas.com/v3/transfers',
headers: {
  'access_token': '[CHAVE_EXPOSTA_AQUI]',
  //...
},
```

**Depois:**

```dart
// Chama a nossa Edge Function segura e não contém chaves
apiUrl: 'https://qlbwacmavngtonauxnte.supabase.co/functions/v1/iniciar-saque-asaas',
headers: {
  'Content-Type': 'application/json',
},
```

Este padrão foi aplicado a todas as classes de chamadas para o Asaas.

## 4. Configurações de Segurança

### 4.1. Autenticação de Funções (JWT)

As novas Edge Functions foram configuradas no painel do Supabase com a opção **"Verify JWT with legacy secret" ATIVADA**. Isso cria uma camada de segurança que garante que apenas usuários autenticados no aplicativo possam chamar essas funções.

### 4.2. Supabase Secrets

A chave de API principal do Asaas (`ASAAS_API_KEY`) foi armazenada de forma segura no Supabase usando o comando `npx supabase secrets set`. As Edge Functions acessam essa chave em tempo de execução, garantindo que ela nunca seja exposta no código do app ou no repositório Git.
