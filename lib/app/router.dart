import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e2etest_flutter/app/scaffold_with_nav_bar.dart';
import 'package:e2etest_flutter/features/auth/presentation/login_screen.dart';
import 'package:e2etest_flutter/features/auth/providers/auth_provider.dart';
import 'package:e2etest_flutter/features/home/presentation/home_screen.dart';
import 'package:e2etest_flutter/features/transactions/presentation/transactions_list_screen.dart';
import 'package:e2etest_flutter/features/transactions/presentation/transaction_detail_screen.dart';
import 'package:e2etest_flutter/features/settings/presentation/settings_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const transactions = '/transactions';
  static const transactionDetail = ':id';
  static const settings = '/settings';

  static String transactionDetailPath(String id) => '/transactions/$id';
}

/// ログイン前にアクセスしようとしたディープリンク先を保持する
String? _pendingDeepLink;

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn && !isLoginRoute) {
        // ディープリンク先を保存してからログイン画面へ
        _pendingDeepLink = state.uri.toString();
        return AppRoutes.login;
      }

      if (isLoggedIn && isLoginRoute) {
        // 保存されたディープリンク先があればそちらへ遷移
        final pendingLink = _pendingDeepLink;
        if (pendingLink != null) {
          _pendingDeepLink = null;
          return pendingLink;
        }
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                builder: (context, state) => const TransactionsListScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.transactionDetail,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return TransactionDetailScreen(transactionId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});
