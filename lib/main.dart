import 'package:cardapio/administrativo/painel/painel_pedidos.dart';
import 'package:cardapio/carrinho/carrinho_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'providers/provider_login.dart';
import 'administrativo/admim_login.dart';
import 'administrativo/menu_adm.dart';
import 'produtos/produtos.dart';
import 'package:provider/provider.dart';
import 'providers/carrinho.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  usePathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarrinhoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      refreshListenable: AuthProvider.instance,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const CardapioPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const AdministrativoPage(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const MenuAdm(),
        ),
        GoRoute(
          path: '/pedidos',
          builder: (context, state) => const PainelPedidos(),
        ),
        GoRoute(
          path: '/carrinho',
          builder: (context, state) => const Cart(),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final auth = AuthProvider.instance;
        final goingToRoot = state.uri.path == '/';
        final goingToAdmin = state.uri.path == '/admin';
        final goingToLogin = state.uri.path == '/login';

        if (goingToAdmin && !auth.isLoggedIn) return '/login';
        if (auth.isLoggedIn && goingToLogin) return '/admin';
        if (goingToRoot) return '/';

        return null;
      },
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        primarySwatch: Colors.blue, // aqui você define a cor primária
      ),
    );
  }
}
