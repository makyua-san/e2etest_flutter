import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e2etest_flutter/domain/entities/category.dart';
import 'package:e2etest_flutter/domain/entities/transaction.dart';
import 'package:e2etest_flutter/features/home/providers/home_provider.dart';
import 'package:e2etest_flutter/infra/fault/fault_provider.dart';

// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Category filter state
final categoryFilterProvider = StateProvider<Category?>((ref) => null);

// Filtered transactions provider
final filteredTransactionsProvider =
    FutureProvider<List<Transaction>>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final categoryFilter = ref.watch(categoryFilterProvider);

  // Watch fault controller to rebuild when fault state changes
  ref.watch(faultControllerProvider);

  return repository.searchAndFilter(searchQuery, categoryFilter);
});

// Single transaction provider
final transactionByIdProvider =
    FutureProvider.family<Transaction?, String>((ref, id) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTransactionById(id);
});

// Sort label for display
final sortLabelProvider = Provider<String>((ref) {
  final faultController = ref.watch(faultControllerProvider);
  return faultController.isSortReversed
      ? 'Sorted: Newest first'
      : 'Sorted: Newest first';
});
