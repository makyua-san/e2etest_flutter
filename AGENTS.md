# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Fault Injection System (Critical for E2E Testing)

**Fault activation via dart-define:**
```bash
flutter run --dart-define=FAULT=SORT_REVERSED
```
- Fault is applied in [`main.dart`](lib/main.dart:16) via `String.fromEnvironment('FAULT')`
- Fault state is stored in [`FaultController`](lib/infra/fault/fault_controller.dart) (ChangeNotifier)
- Sorting logic is centralized in [`TransactionRepositoryImpl._applySorting()`](lib/data/repositories/transaction_repository_impl.dart:20-30)
  - Normal: Descending (newest first) - `tx_0010` at top
  - FAULT: Ascending (oldest first) - `tx_0000` at top

**Debug panel access:**
- Settings screen has debug panel at bottom with semantics label `debug.panel`
- Toggle fault via `debug.fault.sortReversed`
- View status via `debug.fault.status`

## Semantics Labels (Maestro E2E)

All UI elements use centralized labels from [`SemanticsLabels`](lib/shared/semantics/semantics_labels.dart):
- Transaction rows use dynamic IDs: `SemanticsLabels.txRow(id)` → `tx.row.tx_0010`
- Timestamp display: `SemanticsLabels.txRowTimestamp(id)` → `tx.row.tx_0010.timestamp`

**Critical:** Transaction list displays ISO timestamps directly (e.g., `2026-01-30T14:30:00Z`) for E2E verification.

## Riverpod Code Generation

**MUST run after modifying providers:**
```bash
dart run build_runner build --delete-conflicting-outputs
```
- Providers use `riverpod_annotation` with `@riverpod` decorator
- Generated files: `*.g.dart` (gitignored)
- Watch mode: `dart run build_runner watch`

## Seed Data

Fixed seed in [`seed_transactions.dart`](lib/data/seed/seed_transactions.dart):
- 11 transactions, total: 39,390 JPY
- Newest: `tx_0010` (AWS, 2026-01-30)
- Oldest: `tx_0000` (not shown in excerpt)
- IDs are sequential but timestamps are not

## Testing

```bash
flutter test                    # Run all tests
flutter test test/widget_test.dart  # Run specific test