import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:e2etest_flutter/app/router.dart';
import 'package:e2etest_flutter/features/auth/providers/auth_provider.dart';
import 'package:e2etest_flutter/features/home/providers/home_provider.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';
import 'package:e2etest_flutter/shared/widgets/debug_info_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final monthlyTotalAsync = ref.watch(monthlyTotalProvider);
    final currencyFormat = NumberFormat.currency(locale: 'ja_JP', symbol: '¥');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [
          DebugInfoButton(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 48,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      Semantics(
                        label: SemanticsLabels.homeUsername,
                        child: Text(
                          'Welcome, ${authState.username ?? 'User'}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'Monthly Total',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      monthlyTotalAsync.when(
                        data: (total) => Semantics(
                          label: SemanticsLabels.homeMonthlyTotal,
                          child: Text(
                            currencyFormat.format(total),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text('Error: $e'),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Semantics(
                label: SemanticsLabels.homeToTransactions,
                child: ElevatedButton.icon(
                  onPressed: () => context.push(AppRoutes.transactions),
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('View Transactions'),
                ),
              ),
              const SizedBox(height: 12),
              Semantics(
                label: SemanticsLabels.homeToSettings,
                child: OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.settings),
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
