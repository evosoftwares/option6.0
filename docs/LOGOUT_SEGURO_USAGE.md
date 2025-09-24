# Logout Seguro - Guia de Uso

Este documento explica como usar o sistema de logout seguro implementado no aplicativo.

## Funcionalidades Implementadas

### 1. Logout Seguro (`logout_seguro.dart`)

Função principal que realiza o logout completo e seguro:

- ✅ Desabilita FCM e limpa todos os tokens
- ✅ Marca dispositivos como inativos no Supabase
- ✅ Limpa dados locais (SharedPreferences, SecureStorage)
- ✅ Faz logout do Firebase Auth
- ✅ Limpa redirecionamentos pendentes
- ✅ Redireciona para tela de login
- ✅ Tratamento de erros robusto

### 2. Componentes de UI

#### `LogoutButtonWidget`
Botão completo e customizável para logout:

```dart
LogoutButtonWidget(
  buttonText: 'Sair da Conta',
  showConfirmDialog: true,
  buttonColor: Colors.red,
  iconData: Icons.logout,
  onLogoutComplete: () {
    print('Logout concluído!');
  },
)
```

#### `SimpleLogoutWidget`
Item de menu simples para logout:

```dart
SimpleLogoutWidget(
  onLogoutComplete: () {
    // Ação após logout
  },
)
```

#### `AppBarLogoutWidget`
Ícone de logout para app bar:

```dart
AppBar(
  title: Text('Minha Conta'),
  actions: [
    AppBarLogoutWidget(),
  ],
)
```

## Como Integrar

### 1. Importar os Componentes

```dart
import '/index.dart'; // Já inclui todos os componentes de logout
```

### 2. Usar em Telas Existentes

#### Em um Menu (Drawer/Sidebar)

```dart
Drawer(
  child: ListView(
    children: [
      // ... outros itens do menu
      Divider(),
      SimpleLogoutWidget(
        onLogoutComplete: () {
          // Opcional: ações após logout
        },
      ),
    ],
  ),
)
```

#### Em uma Tela de Configurações

```dart
Column(
  children: [
    // ... outras configurações
    SizedBox(height: 20),
    LogoutButtonWidget(
      buttonText: 'Sair da Conta',
      showConfirmDialog: true,
      buttonColor: FlutterFlowTheme.of(context).error,
    ),
  ],
)
```

#### Na AppBar

```dart
AppBar(
  title: Text('Perfil'),
  actions: [
    AppBarLogoutWidget(
      onLogoutComplete: () {
        // Opcional: limpar cache, etc.
      },
    ),
  ],
)
```

### 3. Uso Programático

Para fazer logout via código (sem UI):

```dart
// Logout seguro completo
final result = await logoutSeguro(context);
if (result['sucesso']) {
  print('Logout realizado com sucesso');
} else {
  print('Erro no logout: ${result['erro']}');
}

// Logout forçado (emergência)
await forceLogout(context);

// Verificar status do logout
final isLoggedOut = await verificarStatusLogout();
print('Usuário está deslogado: $isLoggedOut');
```

## Exemplos de Integração

### Menu do Motorista

```dart
// Em menu_motorista_widget.dart
class _MenuMotoristaWidgetState extends State<MenuMotoristaWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ... outros itens do menu
          
          // Botão de logout
          Padding(
            padding: EdgeInsets.all(16),
            child: LogoutButtonWidget(
              buttonText: 'Sair da Conta',
              showConfirmDialog: true,
              onLogoutComplete: () {
                // Limpar dados específicos do motorista se necessário
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### Menu do Passageiro

```dart
// Em menu_passageiro_widget.dart
Drawer(
  child: ListView(
    children: [
      UserAccountsDrawerHeader(
        accountName: Text('Nome do Usuário'),
        accountEmail: Text('email@exemplo.com'),
      ),
      
      // ... outros itens
      
      Divider(),
      SimpleLogoutWidget(),
    ],
  ),
)
```

### Tela de Configurações

```dart
// Em qualquer tela de configurações
ListTile(
  title: Text('Conta'),
  subtitle: Text('Gerenciar conta e sair'),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Opções da Conta',
              style: FlutterFlowTheme.of(context).headlineSmall,
            ),
            SizedBox(height: 20),
            LogoutButtonWidget(
              buttonText: 'Sair da Conta',
              showConfirmDialog: true,
            ),
          ],
        ),
      ),
    );
  },
)
```

## Personalização

### Cores e Estilo

```dart
LogoutButtonWidget(
  buttonText: 'Logout Personalizado',
  buttonColor: Colors.orange,
  textColor: Colors.white,
  iconData: Icons.exit_to_app,
  showConfirmDialog: false, // Sem confirmação
)
```

### Callback Personalizado

```dart
LogoutButtonWidget(
  onLogoutComplete: () {
    // Limpar cache específico
    // Enviar analytics
    // Mostrar mensagem personalizada
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Até logo! 👋'),
        backgroundColor: Colors.blue,
      ),
    );
  },
)
```

## Tratamento de Erros

O sistema possui tratamento robusto de erros:

1. **Erro na limpeza de tokens**: Continua com logout básico
2. **Erro na limpeza local**: Continua com logout do Firebase
3. **Erro no logout Firebase**: Tenta logout forçado
4. **Erro completo**: Navega diretamente para login

## Logs e Debugging

O sistema gera logs detalhados:

```
🚪 Iniciando logout seguro...
🔕 Desabilitando FCM e limpando tokens...
✅ Tokens FCM limpos do Supabase
🧹 Limpando dados locais...
✅ Dados locais limpos
🔄 Preparando logout do Firebase...
✅ Logout do Firebase realizado
🏠 Redirecionando para login...
✅ Logout seguro concluído com sucesso
```

## Segurança

- ✅ Limpa todos os tokens de autenticação
- ✅ Desativa dispositivos no backend
- ✅ Remove dados sensíveis localmente
- ✅ Mantém apenas configurações essenciais do app
- ✅ Redireciona seguramente para login

## Testes

Para testar o logout:

1. Faça login no app
2. Use qualquer componente de logout
3. Verifique se foi redirecionado para login
4. Tente acessar telas protegidas (deve redirecionar para login)
5. Verifique logs no console para confirmar limpeza completa

## Troubleshooting

### Problema: Logout não redireciona
**Solução**: Verificar se `context.mounted` está sendo usado corretamente

### Problema: Tokens não são limpos
**Solução**: Verificar conexão com Supabase e permissões

### Problema: App trava durante logout
**Solução**: Usar `forceLogout()` como fallback

### Problema: Usuário ainda aparece logado
**Solução**: Usar `verificarStatusLogout()` para debug