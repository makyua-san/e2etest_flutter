import 'package:e2etest_flutter/domain/entities/category.dart';
import 'package:e2etest_flutter/domain/entities/transaction_status.dart';

class Transaction {
  final String id;
  final String timestampISO;
  final String merchant;
  final int amount;
  final Category category;
  final TransactionStatus status;

  const Transaction({
    required this.id,
    required this.timestampISO,
    required this.merchant,
    required this.amount,
    required this.category,
    required this.status,
  });

  DateTime get timestamp => DateTime.parse(timestampISO);

  Transaction copyWith({
    String? id,
    String? timestampISO,
    String? merchant,
    int? amount,
    Category? category,
    TransactionStatus? status,
  }) {
    return Transaction(
      id: id ?? this.id,
      timestampISO: timestampISO ?? this.timestampISO,
      merchant: merchant ?? this.merchant,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
