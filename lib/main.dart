import 'package:cardapio/administrativo/painel/painel_pedidos.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'providers/provider_login.dart';
import 'administrativo/admim_login.dart';
import 'administrativo/menu_adm.dart';
import 'produtos/produtos.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const CardapioPage()),
        GoRoute(
            path: '/login',
            builder: (context, state) => const AdministrativoPage()),
        GoRoute(path: '/admin', builder: (context, state) => const MenuAdm()),
        GoRoute(
            path: '/admin', builder: (context, state) => const PainelPedidos()),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final auth = AuthProvider.instance; // Singleton
        final goingToAdmin = state.uri.path == '/admin';
        final goingToLogin = state.uri.path == '/login';

        if (goingToAdmin && !auth.isLoggedIn) return '/login';
        if (auth.isLoggedIn && goingToLogin) return '/admin';
        return null;
      },
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
