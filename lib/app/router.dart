import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  static const transactionDetail = '/transactions/:id';
  static const settings = '/settings';

  static String transactionDetailPath(String id) => '/transactions/$id';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn && !isLoginRoute) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isLoginRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.transactions,
        builder: (context, state) => const TransactionsListScreen(),
      ),
      GoRoute(
        path: '/transactions/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TransactionDetailScreen(transactionId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});
