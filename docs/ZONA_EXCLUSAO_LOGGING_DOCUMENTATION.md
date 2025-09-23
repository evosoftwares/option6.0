# Sistema de Logs Abrangente para Zonas de Exclusão

## Visão Geral

Este documento descreve o sistema de logging implementado para monitorar todas as operações relacionadas às zonas de exclusão dos motoristas no aplicativo. O sistema foi projetado para fornecer rastreabilidade completa, métricas de performance e capacidades de debugging avançadas.

## Componentes Implementados

### 1. Serviço de Logging Central (`zona_exclusao_logging_service.dart`)

**Localização:** `/lib/custom_code/actions/zona_exclusao_logging_service.dart`

#### Características Principais:
- **Logging Multi-nível:** DEBUG, INFO, WARNING, ERROR, SUCCESS
- **Persistência Dupla:** Console (desenvolvimento) + Database (produção)
- **Análise Inteligente:** Detecção automática de tipos de erro
- **Métricas de Performance:** Rastreamento de tempo de execução
- **Contexto Rico:** Informações detalhadas de sistema e usuário

#### Métodos Principais:

##### Criação de Zonas
```dart
ZonaExclusaoLoggingService.logZoneCreationStart()
ZonaExclusaoLoggingService.logInputValidation()
ZonaExclusaoLoggingService.logDuplicateCheck()
ZonaExclusaoLoggingService.logZoneCreationSuccess()
ZonaExclusaoLoggingService.logZoneCreationFailure()
```

##### Operações de Banco de Dados
```dart
ZonaExclusaoLoggingService.logDatabaseConnectionAttempt()
ZonaExclusaoLoggingService.logDatabaseSuccess()
ZonaExclusaoLoggingService.logDatabaseError()
```

##### Ações do Usuário
```dart
ZonaExclusaoLoggingService.logUserAction()
```

##### Métricas de Performance
```dart
ZonaExclusaoLoggingService.logPerformanceMetrics()
```

### 2. Implementação na Criação de Zonas (`add_zona_exclusao_widget.dart`)

#### Logs Implementados:

**Inicialização da Tela:**
- Abertura da tela
- Configuração de listeners
- Contexto de inicialização

**Interações do Usuário:**
- Mudanças no campo de texto
- Seleção de tipo de zona
- Pressionar botão salvar
- Saída sem salvar

**Processo de Validação:**
- Validação de entrada de dados
- Verificação de campos obrigatórios
- Análise de conteúdo (caracteres especiais, números)

**Verificação de Duplicatas:**
- Consulta de zonas existentes
- Análise de similaridade
- Detecção de duplicatas exatas

**Operações de Banco:**
- Tentativas de conexão
- Inserção de dados
- Tratamento de erros
- Verificação pós-inserção

**Métricas Coletadas:**
- Tempo total de operação
- Número de operações de banco
- Passos de validação
- Interações do usuário

### 3. Implementação na Listagem de Zonas (`zonasde_exclusao_motorista_widget.dart`)

#### Logs Implementados:

**Carregamento da Lista:**
- Abertura da tela
- Tentativas de consulta
- Timeouts e reconexões
- Sucessos e falhas

**Operações de Delete:**
- Pressionar botão delete
- Confirmação/cancelamento de dialog
- Execução da exclusão
- Verificação pós-exclusão
- Atualização da lista

**Refresh de Dados:**
- Tentativas de refresh
- Performance de consultas
- Contagem de registros

### 4. Banco de Dados (Tabela `zona_exclusao_logs`)

#### Estrutura da Tabela:
```sql
CREATE TABLE zona_exclusao_logs (
    id BIGSERIAL PRIMARY KEY,
    driver_id TEXT NOT NULL,
    action_type TEXT NOT NULL,
    log_level TEXT NOT NULL DEFAULT 'INFO',
    log_data JSONB NOT NULL,
    session_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### Índices de Performance:
- `idx_zona_exclusao_logs_driver_id`
- `idx_zona_exclusao_logs_action_type`
- `idx_zona_exclusao_logs_created_at`
- `idx_zona_exclusao_logs_log_level`
- `idx_zona_exclusao_logs_session_id`
- `idx_zona_exclusao_logs_driver_date` (composto)
- `idx_zona_exclusao_logs_data_gin` (JSONB)

#### Row Level Security (RLS):
- Motoristas só acessam seus próprios logs
- Proteção contra acesso não autorizado

### 5. Views de Relatórios

#### `zona_exclusao_activity_summary`
Resumo de atividades por motorista/dia:
- Contagem de ações por tipo
- Primeira e última ação do dia
- Agrupamento por nível de log

#### `zona_exclusao_error_metrics`
Métricas de erro dos últimos 7 dias:
- Contagem de erros por tipo
- Tempo médio/máximo de operações falhadas
- Tipos de erro mais comuns

#### `zona_exclusao_performance_metrics`
Análise de performance dos últimos 30 dias:
- Tempo médio/mediano de operações
- Percentil 95 de performance
- Tendências por dia

### 6. Funções Utilitárias

#### `cleanup_old_zona_exclusao_logs()`
- Limpeza automática de logs com mais de 90 dias
- Preserva dados recentes para análise
- Log da própria operação de limpeza

#### `get_driver_zona_exclusao_stats(driver_id, days)`
Estatísticas completas por motorista:
- Total de operações
- Taxa de sucesso/erro
- Tempo médio de resposta
- Ação mais comum
- Zonas criadas/deletadas
- Taxa de erro

## Tipos de Logs Capturados

### Logs de Criação de Zona

1. **ZONE_CREATION_START**
   - Início do processo
   - Dados de entrada
   - Contexto da sessão

2. **INPUT_VALIDATION**
   - Validação de campos
   - Erros encontrados
   - Análise de conteúdo

3. **DUPLICATE_CHECK**
   - Verificação de duplicatas
   - Zonas existentes
   - Análise de similaridade

4. **DATABASE_CONNECTION_ATTEMPT**
   - Tentativas de conexão
   - Tipo de operação
   - Timestamp

5. **DATABASE_SUCCESS/ERROR**
   - Resultado da operação
   - Dados inseridos/erro
   - Tempo de execução

6. **ZONE_CREATION_SUCCESS/FAILURE**
   - Resultado final
   - Contexto completo
   - Dados da zona criada

### Logs de Exclusão de Zona

1. **DELETE_BUTTON_PRESSED**
   - Zona selecionada para exclusão
   - Contexto da ação

2. **DELETE_CANCELLED/CONFIRMED**
   - Decisão do usuário no dialog
   - Dados da zona

3. **ZONE_DELETED_SUCCESSFULLY**
   - Exclusão bem-sucedida
   - Contagem final de zonas

4. **ZONE_DELETION_FAILED**
   - Falha na exclusão
   - Detalhes do erro

### Logs de Ações do Usuário

1. **SCREEN_OPENED**
   - Abertura de telas
   - Contexto de navegação

2. **TEXT_INPUT_CHANGED**
   - Mudanças em campos de texto
   - Comprimento do texto

3. **ZONE_TYPE_SELECTED**
   - Seleção de tipo de zona
   - Opções disponíveis

4. **SCREEN_EXIT_***
   - Saída com/sem salvar
   - Percentual de preenchimento

### Logs de Performance

1. **PERFORMANCE_METRICS**
   - Duração de operações
   - Classificação de performance
   - Métricas adicionais

2. **Classificações de Performance:**
   - EXCELLENT: < 1s
   - GOOD: 1-3s
   - ACCEPTABLE: 3-5s
   - SLOW: 5-10s
   - VERY_SLOW: > 10s

## Análises de Erro Implementadas

### Detecção Automática de Tipos de Erro

1. **Erros de Rede:**
   - "network", "connection", "timeout", "unreachable"

2. **Erros de Permissão:**
   - "permission", "unauthorized", "forbidden", "access denied"

3. **Erros de Timeout:**
   - "timeout", "deadline exceeded", "request timeout"

4. **Erros do Usuário:**
   - "validation", "invalid input", "duplicate", "required field"

5. **Erros de Sistema:**
   - "internal server", "database", "service unavailable"

### Análise de Ações Recomendadas

- **shouldRetry():** Determina se operação deve ser repetida
- **isUserActionable():** Identifica se usuário pode corrigir
- **Performance Rating:** Classifica performance da operação

## Como Usar os Logs

### Para Desenvolvimento

1. **Console Logs:**
   ```
   🚀 [ZONA_EXCLUSAO] [INFO] Zona criada com sucesso
   📊 Dados: {dados_completos_json}
   ```

2. **Debug Mode:**
   - Logs detalhados no developer console
   - Stack traces completos
   - Contexto de execução

### Para Produção

1. **Consulta de Logs:**
   ```sql
   SELECT * FROM zona_exclusao_logs
   WHERE driver_id = 'driver_id'
   ORDER BY created_at DESC;
   ```

2. **Análise de Erros:**
   ```sql
   SELECT * FROM zona_exclusao_error_metrics
   WHERE driver_id = 'driver_id';
   ```

3. **Métricas de Performance:**
   ```sql
   SELECT * FROM zona_exclusao_performance_metrics
   WHERE driver_id = 'driver_id'
   AND activity_date >= CURRENT_DATE - INTERVAL '7 days';
   ```

### Relatórios Prontos

1. **Estatísticas do Motorista:**
   ```sql
   SELECT * FROM get_driver_zona_exclusao_stats('driver_id', 30);
   ```

2. **Resumo de Atividades:**
   ```sql
   SELECT * FROM zona_exclusao_activity_summary
   WHERE driver_id = 'driver_id';
   ```

## Benefícios do Sistema

### Para Desenvolvimento
- **Debug Avançado:** Rastreamento completo de bugs
- **Performance Monitoring:** Identificação de gargalos
- **User Experience:** Análise de comportamento do usuário

### Para Operação
- **Monitoramento Proativo:** Detecção precoce de problemas
- **Análise de Tendências:** Padrões de uso e erro
- **Métricas de Qualidade:** KPIs de performance e confiabilidade

### Para Suporte
- **Troubleshooting:** Contexto completo para resolução
- **Reprodução de Bugs:** Dados suficientes para replicar problemas
- **Análise de Impacto:** Entendimento do alcance de problemas

## Manutenção

### Limpeza Automática
- Logs mantidos por 90 dias
- Limpeza semanal automática (se configurado cron)
- Preservação de dados críticos

### Monitoramento
- Views de relatório atualizadas automaticamente
- Índices otimizados para performance
- RLS garantindo segurança dos dados

### Extensibilidade
- Fácil adição de novos tipos de log
- Estrutura JSONB permite campos flexíveis
- Sistema modular para novas funcionalidades

## Configuração para Uso

1. **Execute o SQL:** `zona_exclusao_logs_table.sql` no Supabase
2. **Import do Service:** Já implementado nos widgets
3. **Verificação:** Logs aparecerão automaticamente após primeira operação

## Exemplos de Uso em Código

```dart
// Log básico de ação do usuário
await ZonaExclusaoLoggingService.logUserAction(
  driverId: currentUserUid,
  action: 'CUSTOM_ACTION',
  actionData: {'key': 'value'},
);

// Log com tratamento de erro
try {
  // operação
  await ZonaExclusaoLoggingService.logDatabaseSuccess(/*...*/);
} catch (error) {
  await ZonaExclusaoLoggingService.logDatabaseError(/*...*/);
}

// Log de performance
final startTime = DateTime.now();
// operação
final duration = DateTime.now().difference(startTime).inMilliseconds;
await ZonaExclusaoLoggingService.logPerformanceMetrics(
  driverId: currentUserUid,
  operation: 'CUSTOM_OPERATION',
  durationMs: duration,
);
```

Este sistema de logging fornece visibilidade completa sobre todas as operações relacionadas às zonas de exclusão, permitindo monitoramento proativo, debugging eficiente e análise detalhada de performance e comportamento do usuário.