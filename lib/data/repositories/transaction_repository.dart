import 'package:e2etest_flutter/domain/entities/category.dart';
import 'package:e2etest_flutter/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions();
  Future<List<Transaction>> searchTransactions(String query);
  Future<List<Transaction>> filterByCategory(Category? category);
  Future<List<Transaction>> searchAndFilter(String query, Category? category);
  Future<Transaction?> getTransactionById(String id);
  Future<int> getMonthlyTotal();
}
