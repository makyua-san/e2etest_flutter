import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e2etest_flutter/data/datasources/local_transaction_datasource.dart';
import 'package:e2etest_flutter/data/repositories/transaction_repository.dart';
import 'package:e2etest_flutter/data/repositories/transaction_repository_impl.dart';
import 'package:e2etest_flutter/infra/fault/fault_provider.dart';

final localTransactionDatasourceProvider =
    Provider<LocalTransactionDatasource>((ref) {
  return LocalTransactionDatasource();
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final datasource = ref.watch(localTransactionDatasourceProvider);
  final faultController = ref.watch(faultControllerProvider);
  return TransactionRepositoryImpl(
    dataSource: datasource,
    faultController: faultController,
  );
});

final monthlyTotalProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getMonthlyTotal();
});
