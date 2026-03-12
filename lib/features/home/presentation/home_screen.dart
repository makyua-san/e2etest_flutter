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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
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
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.tertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 48,
                        color: colorScheme.onPrimary,
                      ),
                      const SizedBox(height: 8),
                      Semantics(
                        label: SemanticsLabels.homeUsername,
                        child: Text(
                          'ようこそ、${authState.username ?? 'User'}さん',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '今月の合計',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
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
                                  color: colorScheme.primary,
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
                  label: const Text('取引一覧を見る'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Semantics(
                label: SemanticsLabels.homeToSettings,
                child: OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.settings),
                  icon: const Icon(Icons.settings),
                  label: const Text('設定'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
