import 'package:e2etest_flutter/domain/entities/transaction.dart';
import 'package:e2etest_flutter/data/seed/seed_transactions.dart';

class LocalTransactionDatasource {
  final List<Transaction> _transactions = List.from(seedTransactions);

  Future<List<Transaction>> getAll() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_transactions);
  }

  Future<Transaction?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _transactions.firstWhere((tx) => tx.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<int> getMonthlyTotal() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return seedMonthlyTotal;
  }
}
