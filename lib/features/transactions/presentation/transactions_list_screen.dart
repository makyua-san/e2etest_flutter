import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e2etest_flutter/app/router.dart';
import 'package:e2etest_flutter/features/transactions/providers/transactions_provider.dart';
import 'package:e2etest_flutter/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:e2etest_flutter/features/transactions/presentation/widgets/transaction_search_bar.dart';
import 'package:e2etest_flutter/features/transactions/presentation/widgets/category_filter.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';
import 'package:e2etest_flutter/shared/widgets/debug_info_button.dart';

class TransactionsListScreen extends ConsumerWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final sortLabel = ref.watch(sortLabelProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('取引一覧'),
        actions: const [
          DebugInfoButton(),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const TransactionSearchBar(),
                  const SizedBox(height: 12),
                  const CategoryFilter(),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Semantics(
                      label: SemanticsLabels.txSortLabel,
                      child: Text(
                        sortLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const Center(
                    child: Text('取引が見つかりません'),
                  );
                }

                return Semantics(
                  label: SemanticsLabels.txList,
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionListItem(
                        transaction: transaction,
                        onTap: () {
                          context.push(
                            AppRoutes.transactionDetailPath(transaction.id),
                          );
                        },
                      );
                    },
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
          ),
        ],
      ),
    );
  }
}
