import 'package:e2etest_flutter/domain/entities/category.dart';
import 'package:e2etest_flutter/domain/entities/transaction.dart';
import 'package:e2etest_flutter/domain/entities/transaction_status.dart';

/// Seed data for 11 transactions
/// Total: 39,390 JPY
final List<Transaction> seedTransactions = [
  const Transaction(
    id: 'tx_0010',
    timestampISO: '2026-01-30T14:30:00Z',
    merchant: 'AWS',
    amount: 12800,
    category: Category.subscription,
    status: TransactionStatus.completed,
  ),
  const Transaction(
    id: 'tx_0009',
    timestampISO: '2026-01-29T10:00:00Z',
    merchant: 'Netflix',
    amount: 1490,
    category: Category.subscription,
    status: TransactionStatus.completed,
  ),
  const Transaction(
    id: 'tx_0008',
    timestampISO: '2026-01-28T18:45:00Z',
    merchant: 'Uber Eats',
    amount: 2350,
    category: Category.groceries,
    status: TransactionStatus.completed,
  ),
  const Transaction(
    id: 'tx_0007',
    timestampISO: '2026-01-27T09:15:00Z',
    merchant: 'JR East',
    amount: 1580,
    category: Category.transport,
    status: TransactionStatus.completed,
  ),
  const Transaction(
    id: 'tx_0006',
    timestampISO: '2026-01-25T16:20:00Z',
    merchant: 'Amazon',
    amount: 8900,
    category: Category.shopping,
    status: TransactionStatus.completed,
  ),
  const Transaction(
    id: 'tx_0005',
    timestampISO: '2026-01-23T12:00:00Z',
    merchant: 'Spotify',
    amount: 980,
    category: Category.subscription,
    status: TransactionStatus.completed,
  ),
  const Transaction(
    id: 'tx_0004',
    timestampISO: '2026-01-20T08:30:00Z',
    merchant: 'Starbucks',
    amount: 650,
    category: Category.groceries,
    status: TransactionStatus.completed,
  ),
  const Transaction(
    id: 'tx_0003',
    timestampISO: '2026-01-18T19:45:00Z',
    merchant: 'Uniqlo',
    amount: 5990,
    category: Category.shopping,
    status: TransactionStatus.completed,
  ),
  const Transaction(
    id: 'tx_0002',
    timestampISO: '2026-01-15T11:00:00Z',
    merchant: 'GitHub',
    amount: 1200,
    category: Category.subscription,
    status: TransactionStatus.completed,
  ),
  const Transaction(
    id: 'tx_0001',
    timestampISO: '2026-01-10T07:00:00Z',
    merchant: 'Lawson',
    amount: 450,
    category: Category.groceries,
    status: TransactionStatus.completed,
  ),
  const Transaction(
    id: 'tx_0000',
    timestampISO: '2026-01-05T15:30:00Z',
    merchant: 'Suica Charge',
    amount: 3000,
    category: Category.transport,
    status: TransactionStatus.completed,
  ),
];

/// Monthly total: 39,390 JPY
const int seedMonthlyTotal = 39390;
