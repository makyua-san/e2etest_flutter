import 'package:e2etest_flutter/data/datasources/local_transaction_datasource.dart';
import 'package:e2etest_flutter/data/repositories/transaction_repository.dart';
import 'package:e2etest_flutter/domain/entities/category.dart';
import 'package:e2etest_flutter/domain/entities/transaction.dart';
import 'package:e2etest_flutter/infra/fault/fault_controller.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final LocalTransactionDatasource _dataSource;
  final FaultController _faultController;

  TransactionRepositoryImpl({
    required LocalTransactionDatasource dataSource,
    required FaultController faultController,
  })  : _dataSource = dataSource,
        _faultController = faultController;

  /// Sort transactions based on fault state
  /// NORMAL: Descending order (newest first) - tx_0010 at top
  /// FAULT (sortReversed): Ascending order (oldest first) - tx_0000 at top
  List<Transaction> _applySorting(List<Transaction> transactions) {
    final sorted = List<Transaction>.from(transactions);
    if (_faultController.isSortReversed) {
      // FAULT: Ascending order (oldest first)
      sorted.sort((a, b) => a.timestampISO.compareTo(b.timestampISO));
    } else {
      // NORMAL: Descending order (newest first)
      sorted.sort((a, b) => b.timestampISO.compareTo(a.timestampISO));
    }
    return sorted;
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    final transactions = await _dataSource.getAll();
    return _applySorting(transactions);
  }

  @override
  Future<List<Transaction>> searchTransactions(String query) async {
    final transactions = await _dataSource.getAll();
    final lowerQuery = query.toLowerCase();
    final filtered = transactions
        .where((tx) => tx.merchant.toLowerCase().contains(lowerQuery))
        .toList();
    return _applySorting(filtered);
  }

  @override
  Future<List<Transaction>> filterByCategory(Category? category) async {
    final transactions = await _dataSource.getAll();
    if (category == null) {
      return _applySorting(transactions);
    }
    final filtered =
        transactions.where((tx) => tx.category == category).toList();
    return _applySorting(filtered);
  }

  @override
  Future<List<Transaction>> searchAndFilter(
      String query, Category? category) async {
    final transactions = await _dataSource.getAll();
    var filtered = transactions.toList();

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered
          .where((tx) => tx.merchant.toLowerCase().contains(lowerQuery))
          .toList();
    }

    if (category != null) {
      filtered = filtered.where((tx) => tx.category == category).toList();
    }

    return _applySorting(filtered);
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    return await _dataSource.getById(id);
  }

  @override
  Future<int> getMonthlyTotal() async {
    return await _dataSource.getMonthlyTotal();
  }
}
