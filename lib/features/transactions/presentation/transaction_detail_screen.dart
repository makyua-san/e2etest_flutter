import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: SemanticsLabels.txDetailTitle,
          child: const Text('Transaction Detail'),
        ),
      ),
      body: transactionAsync.when(
        data: (transaction) {
          if (transaction == null) {
            return const Center(
              child: Text('Transaction not found'),
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
                            color: _getCategoryColor(transaction.category.name)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getCategoryIcon(transaction.category.name),
                            size: 40,
                            color:
                                _getCategoryColor(transaction.category.name),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          transaction.merchant,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(transaction.category.displayName),
                          backgroundColor:
                              _getCategoryColor(transaction.category.name)
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
                          label: 'Amount',
                          semanticLabel: SemanticsLabels.txDetailAmount,
                          child: Text(
                            currencyFormat.format(transaction.amount),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                        const Divider(),
                        _DetailRow(
                          label: 'Date & Time',
                          semanticLabel: SemanticsLabels.txDetailTimestamp,
                          child: Text(
                            dateFormat
                                .format(transaction.timestamp.toLocal()),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const Divider(),
                        _DetailRow(
                          label: 'Status',
                          semanticLabel: SemanticsLabels.txDetailStatus,
                          child: Chip(
                            label: Text(transaction.status.displayName),
                            backgroundColor:
                                _getStatusColor(transaction.status.name)
                                    .withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: _getStatusColor(transaction.status.name),
                            ),
                          ),
                        ),
                        const Divider(),
                        _DetailRow(
                          label: 'Transaction ID',
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'subscription':
        return Colors.purple;
      case 'groceries':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'shopping':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
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
                  color: Colors.grey,
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
