import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e2etest_flutter/domain/entities/transaction.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');
    final currencyFormat = NumberFormat.currency(locale: 'ja_JP', symbol: '¥');

    return Semantics(
      label: SemanticsLabels.txRow(transaction.id),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(transaction.category.name)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(transaction.category.name),
                    color: _getCategoryColor(transaction.category.name),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        label: SemanticsLabels.txRowMerchant(transaction.id),
                        child: Text(
                          transaction.merchant,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Semantics(
                        label: SemanticsLabels.txRowTimestamp(transaction.id),
                        child: Text(
                          dateFormat.format(transaction.timestamp.toLocal()),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Semantics(
                  label: SemanticsLabels.txRowAmount(transaction.id),
                  child: Text(
                    currencyFormat.format(transaction.amount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
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
}
