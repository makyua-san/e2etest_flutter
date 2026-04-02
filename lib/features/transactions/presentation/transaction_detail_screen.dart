import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:e2etest_flutter/app/category_colors.dart';
import 'package:e2etest_flutter/app/router.dart';
import 'package:e2etest_flutter/features/transactions/providers/transactions_provider.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionByIdProvider(transactionId));
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm:ss');
    final currencyFormat = NumberFormat.currency(locale: 'ja_JP', symbol: '¥');
    final colorScheme = Theme.of(context).colorScheme;

    final canPop = GoRouter.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        leading: canPop
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go(AppRoutes.transactions),
              ),
        title: Semantics(
          label: SemanticsLabels.txDetailTitle,
          child: const Text('取引の詳細'),
        ),
      ),
      body: transactionAsync.when(
        data: (transaction) {
          if (transaction == null) {
            return const Center(
              child: Text('取引が見つかりません'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppCategoryColors.forCategory(transaction.category.name)
                                    .withOpacity(0.9),
                                AppCategoryColors.forCategory(transaction.category.name)
                                    .withOpacity(0.5),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getCategoryIcon(transaction.category.name),
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          transaction.merchant,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(transaction.category.displayName),
                          backgroundColor:
                              AppCategoryColors.forCategory(transaction.category.name)
                                  .withOpacity(0.1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _DetailRow(
                          label: '金額',
                          semanticLabel: SemanticsLabels.txDetailAmount,
                          child: Text(
                            currencyFormat.format(transaction.amount),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                          ),
                        ),
                        Divider(color: colorScheme.outlineVariant),
                        _DetailRow(
                          label: '日時',
                          semanticLabel: SemanticsLabels.txDetailTimestamp,
                          child: Text(
                            dateFormat
                                .format(transaction.timestamp.toLocal()),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Divider(color: colorScheme.outlineVariant),
                        _DetailRow(
                          label: 'ステータス',
                          semanticLabel: SemanticsLabels.txDetailStatus,
                          child: Chip(
                            label: Text(transaction.status.displayName),
                            backgroundColor:
                                AppStatusColors.forStatus(transaction.status.name)
                                    .withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: AppStatusColors.forStatus(transaction.status.name),
                            ),
                          ),
                        ),
                        Divider(color: colorScheme.outlineVariant),
                        _DetailRow(
                          label: '取引ID',
                          child: Text(
                            transaction.id,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontFamily: 'monospace',
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!canPop) ...[
                  const SizedBox(height: 24),
                  Semantics(
                    label: SemanticsLabels.txDetailToList,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go(AppRoutes.transactions),
                      icon: const Icon(Icons.list_alt),
                      label: const Text('取引一覧を見る'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'subscription':
        return Icons.subscriptions;
      case 'groceries':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      default:
        return Icons.receipt;
    }
  }

}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? semanticLabel;
  final Widget child;

  const _DetailRow({
    required this.label,
    this.semanticLabel,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          if (semanticLabel != null)
            Semantics(
              label: semanticLabel,
              child: child,
            )
          else
            child,
        ],
      ),
    );
  }
}
