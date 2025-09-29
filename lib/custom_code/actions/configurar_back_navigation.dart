import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Configuração avançada para navegação de volta (OnBackInvokedCallback)
class BackNavigationConfig {
  static final BackNavigationConfig _instance = BackNavigationConfig._internal();
  
  factory BackNavigationConfig() => _instance;
  
  BackNavigationConfig._internal();

  bool _isConfigured = false;
  final Map<String, VoidCallback> _customBackHandlers = {};

  /// Configura o sistema de navegação de volta
  void configure(BuildContext context) {
    if (_isConfigured) return;

    try {
      // Configurar handler global para navegação de volta
      SystemChannels.platform.setMethodCallHandler((call) async {
        if (call.method == 'SystemNavigator.pop') {
          return _handleSystemBack(context);
        }
        return null;
      });

      _isConfigured = true;
      debugPrint('✅ [BACK_NAV] Sistema de navegação configurado');
    } catch (e) {
      debugPrint('❌ [BACK_NAV] Erro ao configurar navegação: $e');
    }
  }

  /// Registra handler customizado para uma rota específica
  void registerCustomHandler(String route, VoidCallback handler) {
    _customBackHandlers[route] = handler;
    debugPrint('📝 [BACK_NAV] Handler customizado registrado para: $route');
  }

  /// Remove handler customizado
  void unregisterCustomHandler(String route) {
    _customBackHandlers.remove(route);
    debugPrint('🗑️ [BACK_NAV] Handler removido para: $route');
  }

  /// Manipula navegação de volta do sistema
  Future<bool> _handleSystemBack(BuildContext context) async {
    try {
      final router = GoRouter.of(context);
      final currentLocation = _getCurrentLocationSafely(router);
      
      debugPrint('🔙 [BACK_NAV] Processando volta do sistema para: $currentLocation');

      // Verificar se existe handler customizado para a rota atual
      if (_customBackHandlers.containsKey(currentLocation)) {
        _customBackHandlers[currentLocation]!();
        return true;
      }

      // Lógica padrão baseada na rota atual
      return _handleDefaultBack(context, currentLocation);
    } catch (e) {
      debugPrint('❌ [BACK_NAV] Erro ao processar volta: $e');
      return false;
    }
  }

  String _getCurrentLocationSafely(GoRouter router) {
    // Obtém a localização atual de forma resiliente sem depender de getters inexistentes na versão do go_router
    try {
      return router.routerDelegate.currentConfiguration.uri.toString();
    } catch (_) {
      // Fallback simples
      return '/';
    }
  }
  
  /// Lógica padrão de navegação de volta
  bool _handleDefaultBack(BuildContext context, String currentRoute) {
    final router = GoRouter.of(context);

    // Rotas que devem ter comportamento especial
    switch (currentRoute) {
      case '/login':
        // No login, sair do app
        SystemNavigator.pop();
        return true;

      case '/mainMotorista':
      case '/mainPassageiro':
        // Nas telas principais, confirmar saída
        _showExitConfirmation(context);
        return true;

      default:
        // Comportamento padrão: tentar voltar na pilha
        try {
          if (router.canPop()) {
            router.pop();
            return true;
          }
        } catch (_) {}

        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return true;
        } else {
          // Se não pode voltar, ir para tela inicial apropriada
          _navigateToHome(context);
          return true;
        }
    }
  }

  /// Mostra diálogo de confirmação de saída
  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair do App'),
          content: const Text('Deseja realmente sair do aplicativo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  /// Mostra diálogo informando que não é possível voltar
  void _showCannotGoBackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Processo Obrigatório'),
          content: const Text('É necessário completar este processo para continuar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Navega para a tela inicial apropriada
  void _navigateToHome(BuildContext context) {
    final router = GoRouter.of(context);
    
    // Determinar tela inicial baseada no estado de autenticação
    // Esta lógica deve ser sincronizada com nav.dart
    router.go('/');
  }

  /// Limpa configurações
  void dispose() {
    _customBackHandlers.clear();
    _isConfigured = false;
    debugPrint('🧹 [BACK_NAV] Configurações limpas');
  }
}

/// Widget wrapper que configura navegação de volta automaticamente
class BackNavigationWrapper extends StatefulWidget {
  final Widget child;
  final String? routeName;
  final VoidCallback? customBackHandler;

  const BackNavigationWrapper({
    Key? key,
    required this.child,
    this.routeName,
    this.customBackHandler,
  }) : super(key: key);

  @override
  State<BackNavigationWrapper> createState() => _BackNavigationWrapperState();
}

class _BackNavigationWrapperState extends State<BackNavigationWrapper> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final config = BackNavigationConfig();
      config.configure(context);
      
      if (widget.routeName != null && widget.customBackHandler != null) {
        config.registerCustomHandler(widget.routeName!, widget.customBackHandler!);
      }
    });
  }

  @override
  void dispose() {
    if (widget.routeName != null) {
      BackNavigationConfig().unregisterCustomHandler(widget.routeName!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final config = BackNavigationConfig();
        return await config._handleSystemBack(context);
      },
      child: widget.child,
    );
  }
}

/// Função de ação para configurar navegação de volta
Future<void> configurarBackNavigation(BuildContext context) async {
  try {
    final config = BackNavigationConfig();
    config.configure(context);
    debugPrint('✅ [BACK_NAV] Navegação de volta configurada com sucesso');
  } catch (e) {
    debugPrint('❌ [BACK_NAV] Erro ao configurar navegação de volta: $e');
  }
}

/// Função de ação para registrar handler customizado
Future<void> registrarHandlerCustomizado(String route, VoidCallback handler) async {
  try {
    final config = BackNavigationConfig();
    config.registerCustomHandler(route, handler);
    debugPrint('✅ [BACK_NAV] Handler customizado registrado para: $route');
  } catch (e) {
    debugPrint('❌ [BACK_NAV] Erro ao registrar handler: $e');
  }
}