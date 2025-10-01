import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';

import '/backend/push_notifications/push_notifications_handler.dart'
    show PushNotificationsHandler;
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/custom_code/actions/validar_documentos_motorista.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? MainMotoristaWidget() : LoginWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) {
            if (!appStateNotifier.loggedIn) return LoginWidget();

            // Determine user_type on first load and return appropriate main screen.
            return FutureBuilder<String?>(
              future: (() async {
                try {
                  // Try lookup by email first
                  List<AppUsersRow> appUsers = [];
                  if (currentUserEmail.trim().isNotEmpty) {
                    appUsers = await AppUsersTable().queryRows(
                      queryFn: (q) => q.eq('email', currentUserEmail.trim()).limit(1),
                    );
                  }

                  // Fallback to Firebase UID column
                  if (appUsers.isEmpty) {
                    appUsers = await AppUsersTable().queryRows(
                      queryFn: (q) => q.eq('currentUser_UID_Firebase', currentUserUid).limit(1),
                    );
                  }

                  // Legacy fallback to fcm_token
                  if (appUsers.isEmpty) {
                    appUsers = await AppUsersTable().queryRows(
                      queryFn: (q) => q.eq('fcm_token', currentUserUid).limit(1),
                    );
                  }

                  if (appUsers.isEmpty) return '';
                  return appUsers.first.userType;
                } catch (e) {
                  debugPrint('ROUTE_INIT: erro ao resolver app_user user_type: $e');
                  return '';
                }
              })()
                  .timeout(const Duration(seconds: 8), onTimeout: () => ''),
              builder: (context, snapshot) {
                // While resolving, show splash/loading
                if (!snapshot.hasData) {
                  return Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Image.asset(
                        'assets/images/Logotipo_Vertical_Color.png',
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }

                final userTypeRaw = snapshot.data ?? '';
                final userType = userTypeRaw.trim().toLowerCase();
                if (userType.isEmpty) {
                  return const SelecaoPerfilWidget();
                }
                if (userType == 'passenger' || userType == 'passageiro') {
                  return MainPassageiroWidget();
                }
                if (userType == 'driver' || userType == 'motorista') {
                  return MainMotoristaWidget();
                }
                // Qualquer valor inesperado cai para seleção de perfil
                return const SelecaoPerfilWidget();
              },
            );
          },
        ),
        FFRoute(
          name: CadastrarWidget.routeName,
          path: CadastrarWidget.routePath,
          builder: (context, params) => CadastrarWidget(),
        ),
        FFRoute(
          name: LoginWidget.routeName,
          path: LoginWidget.routePath,
          builder: (context, params) => LoginWidget(),
        ),
        FFRoute(
          name: SuporteRecuperacaoWidget.routeName,
          path: SuporteRecuperacaoWidget.routePath,
          builder: (context, params) => SuporteRecuperacaoWidget(),
        ),
        FFRoute(
          name: EsqueceuSenhaWidget.routeName,
          path: EsqueceuSenhaWidget.routePath,
          builder: (context, params) => EsqueceuSenhaWidget(),
        ),

        FFRoute(
          name: SelecaoPerfilWidget.routeName,
          path: SelecaoPerfilWidget.routePath,
          builder: (context, params) => const SelecaoPerfilWidget(),
        ),
        FFRoute(
          name: UploadFotoWidget.routeName,
          path: UploadFotoWidget.routePath,
          builder: (context, params) => const UploadFotoWidget(),
        ),

        FFRoute(
          name: MainMotoristaWidget.routeName,
          path: MainMotoristaWidget.routePath,
          builder: (context, params) => MainMotoristaWidget(),
        ),
        FFRoute(
          name: ACaminhoDoPassageiroWidget.routeName,
          path: ACaminhoDoPassageiroWidget.routePath,
          builder: (context, params) => ACaminhoDoPassageiroWidget(),
        ),
        FFRoute(
          name: EsperandoMotoristaWidget.routeName,
          path: EsperandoMotoristaWidget.routePath,
          builder: (context, params) => EsperandoMotoristaWidget(),
        ),
        FFRoute(
          name: DocumentosMotoristaWidget.routeName,
          path: DocumentosMotoristaWidget.routePath,
          builder: (context, params) => DocumentosMotoristaWidget(),
        ),
        FFRoute(
          name: ZonasdeExclusaoMotoristaWidget.routeName,
          path: ZonasdeExclusaoMotoristaWidget.routePath,
          builder: (context, params) => ZonasdeExclusaoMotoristaWidget(),
        ),
        FFRoute(
          name: EscolhaMotoristaWidget.routeName,
          path: EscolhaMotoristaWidget.routePath,
          builder: (context, params) => EscolhaMotoristaWidget(
            origem: params.getParam(
              'origem',
              ParamType.FFPlace,
            ),
            destino: params.getParam(
              'destino',
              ParamType.FFPlace,
            ),
            paradas: params.getParam(
              'paradas',
              ParamType.FFPlace,
              isList: true,
            ),
            distancia: params.getParam(
              'distancia',
              ParamType.double,
            ),
            duracao: params.getParam(
              'duracao',
              ParamType.int,
            ),
            preco: params.getParam(
              'preco',
              ParamType.double,
            ),
            vehicleCategory: params.getParam(
              'vehicleCategory',
              ParamType.String,
            ),
            paymentMethod: params.getParam(
              'paymentMethod',
              ParamType.String,
            ),
            needsPet: params.getParam(
              'needsPet',
              ParamType.bool,
            ),
            needsGrocerySpace: params.getParam(
              'needsGrocerySpace',
              ParamType.bool,
            ),
            needsAc: params.getParam(
              'needsAc',
              ParamType.bool,
            ),
            needsCondoAccess: params.getParam(
              'needsCondoAccess',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: SearchScreenWidget.routeName,
          path: SearchScreenWidget.routePath,
          builder: (context, params) => SimpleSearchScreenWidget(
            origemDestinoParada: params.getParam(
              'origemDestinoParada',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AddZonaExclusaoWidget.routeName,
          path: AddZonaExclusaoWidget.routePath,
          builder: (context, params) => AddZonaExclusaoWidget(),
        ),
        FFRoute(
          name: MainPassageiroWidget.routeName,
          path: MainPassageiroWidget.routePath,
          builder: (context, params) => MainPassageiroWidget(),
        ),
        FFRoute(
          name: MenuMotoristaWidget.routeName,
          path: MenuMotoristaWidget.routePath,
          builder: (context, params) => MenuMotoristaWidget(),
        ),
        FFRoute(
          name: MenuPassageiroWidget.routeName,
          path: MenuPassageiroWidget.routePath,
          builder: (context, params) => MenuPassageiroWidget(),
        ),
        FFRoute(
          name: MeuVeiculoWidget.routeName,
          path: MeuVeiculoWidget.routePath,
          builder: (context, params) => MeuVeiculoWidget(
            driver: params.getParam<DriversRow>(
              'driver',
              ParamType.SupabaseRow,
            ),
          ),
        ),
        FFRoute(
          name: MinhasViagensWidget.routeName,
          path: MinhasViagensWidget.routePath,
          builder: (context, params) => MinhasViagensWidget(),
        ),
        FFRoute(
          name: MinhasViagensPaxWidget.routeName,
          path: MinhasViagensPaxWidget.routePath,
          builder: (context, params) => MinhasViagensPaxWidget(),
        ),
        FFRoute(
          name: CarteiraPassageiroWidget.routeName,
          path: CarteiraPassageiroWidget.routePath,
          builder: (context, params) => CarteiraPassageiroWidget(),
        ),

        FFRoute(
          name: AvaliarMotoristaWidget.routeName,
          path: AvaliarMotoristaWidget.routePath,
          builder: (context, params) => AvaliarMotoristaWidget(
            tripId: params.getParam(
              'tripId',
              ParamType.String,
            )!,
            motoristaNome: params.getParam(
              'motoristaNome',
              ParamType.String,
            ),
            veiculoInfo: params.getParam(
              'veiculoInfo',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AvaliarPassageiroWidget.routeName,
          path: AvaliarPassageiroWidget.routePath,
          builder: (context, params) => AvaliarPassageiroWidget(
            tripId: params.getParam(
              'tripId',
              ParamType.String,
            )!,
            passageiroNome: params.getParam(
              'passageiroNome',
              ParamType.String,
            ),
            origemDestino: params.getParam(
              'origemDestino',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PreferenciasPassageiroWidget.routeName,
          path: PreferenciasPassageiroWidget.routePath,
          builder: (context, params) => PreferenciasPassageiroWidget(
            origem: params.getParam(
              'origem',
              ParamType.FFPlace,
            ),
            destino: params.getParam(
              'destino',
              ParamType.FFPlace,
            ),
            paradas: params.getParam(
              'paradas',
              ParamType.FFPlace,
              isList: true,
            ),
            distancia: params.getParam(
              'distancia',
              ParamType.double,
            ),
            duracao: params.getParam(
              'duracao',
              ParamType.int,
            ),
            preco: params.getParam(
              'preco',
              ParamType.double,
            ),
          ),
        ),
        FFRoute(
          name: PreferenciasMotoristaWidget.routeName,
          path: PreferenciasMotoristaWidget.routePath,
          builder: (context, params) => PreferenciasMotoristaWidget(),
        ),
        FFRoute(
          name: EditarPerfilWidget.routeName,
          path: EditarPerfilWidget.routePath,
          builder: (context, params) => const EditarPerfilWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) async {
          print('🚏 [ROUTE_REDIRECT] Verificando redirecionamento para rota: ${state.uri}');

          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            print('🔄 [ROUTE_REDIRECT] Redirecionamento pendente: $redirectLocation');
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            print('🚫 [ROUTE_REDIRECT] Usuário não logado - redirecionando para login');
            return '/login';
          }

          // Prevenção de loops: não validar user_type se já estamos em rotas de configuração
          final currentRoute = state.uri.toString();
          if (_isConfigurationRoute(currentRoute)) {
            print('⚙️ [ROUTE_REDIRECT] Rota de configuração detectada - pulando validações');
            return null;
          }

          // Verificar user_type para rotas protegidas com debounce
          if (appStateNotifier.loggedIn && _requiresAppUserValidation(currentRoute)) {
            print('🔍 [ROUTE_REDIRECT] Rota protegida detectada - validando user_type');
            
            // Implementar debounce para evitar múltiplas validações
            if (_isValidationInProgress) {
              print('⏳ [ROUTE_REDIRECT] Validação já em progresso - aguardando');
              return null;
            }
            
            _isValidationInProgress = true;
            
            try {
              bool hasValidUserType = await _validateAppUser();

              if (!hasValidUserType) {
                print('🚫 [ROUTE_REDIRECT] user_type inválido/vazio - redirecionando para escolha de perfil');
                appStateNotifier.setRedirectLocationIfUnset(currentRoute);
                return '/escolhaSeuPerfil';
              } else {
                print('✅ [ROUTE_REDIRECT] user_type válido - permitindo acesso à rota');
              }
            } finally {
              _isValidationInProgress = false;
            }
          }

          // Verificar documentos obrigatórios para motoristas
          if (appStateNotifier.loggedIn && _requiresDriverDocumentValidation(currentRoute)) {
            print('🔍 [ROUTE_REDIRECT] Rota de motorista detectada - validando documentos');

            bool isDriver = await isCurrentUserDriver();
            if (isDriver) {
              bool hasAllDocuments = await validarDocumentosMotorista();

              if (!hasAllDocuments) {
                print('🚫 [ROUTE_REDIRECT] Documentos obrigatórios faltando - redirecionando para tela de documentos');
                appStateNotifier.setRedirectLocationIfUnset(currentRoute);
                return '/documentos_motorista';
              } else {
                print('✅ [ROUTE_REDIRECT] Todos os documentos aprovados - permitindo acesso à rota');
              }
            }
          }

          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Image.asset(
                      'assets/images/Logotipo_Vertical_Color.png',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : PushNotificationsHandler(child: page);

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(
    hasTransition: true,
    transitionType: PageTransitionType.rightToLeft,
    duration: const Duration(milliseconds: 300),
  );
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

/// Valida se o usuário atual tem user_type válido na tabela app_users
Future<bool> _validateAppUser() async {
  try {
    print('🔍 [NAV_GUARD] Validando user_type para navegação');
    print('🔑 [NAV_GUARD] currentUserUid: $currentUserUid');
    print('📧 [NAV_GUARD] currentUserEmail: $currentUserEmail');

    if (currentUserUid.isEmpty) {
      print('⚠️ [NAV_GUARD] currentUserUid vazio - user_type não pode ser validado');
      return false;
    }

    // Buscar por email primeiro
    List<AppUsersRow> appUsers = [];
    if (currentUserEmail.trim().isNotEmpty) {
      appUsers = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('email', currentUserEmail.trim()).limit(1),
      );
    }

    // Fallback primário: buscar por Firebase UID na coluna correta
    if (appUsers.isEmpty) {
      print('📟 [NAV_GUARD] Nenhum registro encontrado por email. Tentando por Firebase UID...');
      appUsers = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('currentUser_UID_Firebase', currentUserUid).limit(1),
      );
    }

    // Fallback legado: buscar por fcm_token igual ao Firebase UID (compatibilidade)
    if (appUsers.isEmpty) {
      print('📱 [NAV_GUARD] Nenhum registro encontrado por Firebase UID. Tentando por fcm_token (legado)...');
      appUsers = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('fcm_token', currentUserUid).limit(1),
      );
    }

    if (appUsers.isNotEmpty) {
      final appUser = appUsers.first;
      String? userType = appUser.userType;

      // Verificar especificamente se user_type está preenchido corretamente
      bool isUserTypeValid = (userType?.trim().isNotEmpty ?? false) &&
                             (userType == 'driver' || userType == 'passenger');

      print('📊 [NAV_GUARD] app_user encontrado: ${appUser.id}');
      print('👥 [NAV_GUARD] user_type atual: "$userType"');
      print('✅ [NAV_GUARD] user_type é válido: $isUserTypeValid');

      if (!isUserTypeValid) {
        print('⚠️ [NAV_GUARD] app_user existe mas user_type está vazio/inválido');
      }

      return isUserTypeValid;
    } else {
      print('❌ [NAV_GUARD] Nenhum app_user encontrado');
      return false;
    }

  } catch (e) {
    print('💥 [NAV_GUARD] Erro ao validar user_type: $e');
    return false;
  }
}

/// Variável global para controle de debounce de validação
bool _isValidationInProgress = false;

/// Verifica se a rota é de configuração e não deve ser validada
bool _isConfigurationRoute(String route) {
  final configurationRoutes = {
    '/login',
    '/cadastrar', 
    '/selecao-perfil',
    '/esqueceuSenha',
    '/suporteRecuperacao',
    '/documentos_motorista',
    '/',
  };
  return configurationRoutes.contains(route);
}

/// Rotas que não precisam de validação de user_type
final Set<String> _routesWithoutAppUserValidation = {
  '/login',
  '/esqueceuSenha',
  '/suporteRecuperacao',
  '/selecao-perfil',
  '/',
};

/// Verifica se a rota precisa de validação de user_type
bool _requiresAppUserValidation(String route) {
  return !_routesWithoutAppUserValidation.contains(route);
}

/// Rotas específicas de motorista que precisam de validação de documentos
final Set<String> _driverRoutes = {
  '/mainMotorista',
  '/a_caminho_do_passageiro',
  '/zonasde_exclusao_motorista',
  '/add_zona_exclusao',
  '/menu_motorista',
  '/meu_veiculo',
  '/minhas_viagens',
};

/// Verifica se a rota precisa de validação de documentos obrigatórios para motoristas
bool _requiresDriverDocumentValidation(String route) {
  // A tela de documentos não deve validar documentos (para evitar loops)
  if (route == '/documentos_motorista') {
    return false;
  }

  return _driverRoutes.contains(route);
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
