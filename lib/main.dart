import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/supabase_auth/auth_util.dart';

import '/backend/supabase/supabase.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/custom_code/actions/sistema_monitoramento_performance.dart';
import '/custom_code/actions/configurar_back_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  // Load environment variables (.env) before any services initialize
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // Fallback if .env is missing; do not crash the app
    debugPrint('Warn: .env not found or failed to load: $e');
  }

  await SupaFlow.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  // Inicializar sistema de monitoramento de performance
  await iniciarMonitoramentoPerformance();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser?> userStream;

  final authUserSub = authenticatedUserStream.listen((_) {});
  // Removido fcmTokenSub pois não usamos mais Firebase FCM

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    
    // Inicializar OneSignal - TODO: Adicionar APP_ID do OneSignal
    // OneSignalService.instance.initialize('YOUR_ONESIGNAL_APP_ID');
    
    // Inicializar o usuário imediatamente para evitar travamento na splash screen
    _initializeUser();
    
    userStream = authManager.userStream
      ..listen((user) {
        if (user != null) {
          _appStateNotifier.update(user);
        }
      });
    jwtTokenStream.listen((_) {});
    
    // Timer para remover a splash screen
    Future.delayed(
      Duration(milliseconds: 3000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void _initializeUser() async {
    try {
      // Verificar se já existe um usuário logado no Supabase
      final currentUser = authManager.currentUser;
      if (currentUser != null) {
        _appStateNotifier.update(currentUser);
      }
      // Se não há usuário logado, não fazemos nada - o AppStateNotifier já trata user como null
    } catch (e) {
      // Em caso de erro, apenas logar - não precisamos atualizar com null
      debugPrint('Erro na inicialização do usuário: $e');
    }
  }

  @override
  void dispose() {
    authUserSub.cancel();
    // fcmTokenSub removido - não usamos mais Firebase FCM
    super.dispose();
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return BackNavigationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'option',
        localizationsDelegates: [
          FFLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FallbackMaterialLocalizationDelegate(),
          FallbackCupertinoLocalizationDelegate(),
        ],
        locale: _locale,
        supportedLocales: const [
          Locale('pt'),
        ],
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: false,
        ),
        themeMode: _themeMode,
        routerConfig: _router,
      ),
    );
  }
}
