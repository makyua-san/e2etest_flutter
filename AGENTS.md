# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## アプリケーション概要

このアプリは **Fault Injection機能を備えたE2Eテスト用デモアプリケーション**（利用明細確認アプリ）です。

- **対象プラットフォーム**: Android（エミュレータ / 実機）
- **技術スタック**: Flutter + Riverpod + go_router + SharedPreferences
- **主な機能**: ログイン、利用明細一覧・詳細表示、設定管理、Fault Injection（ソート順反転）
- **テスト用アカウント**: `demo_user` / `password`
- **シードデータ**: 11件の固定取引データ（合計 39,390 JPY）
- **ディープリンク**: `e2etestflutter://` スキームをサポート

アプリはオフラインで動作し、サーバー不要。固定シードデータを使用するため、毎回同じ状態でテストできます。

---

## E2Eテスト（Mobile MCP）ガイド — 必読

このアプリのE2Eテストは **Mobile MCP** を使って実施します。以下のガイドラインを**必ず**遵守してください。

### 1. テスト開始前の確認事項

#### 1.1 Mobile MCPの利用可否確認
テスト実施前に、**必ずユーザーに以下を確認**すること：

- Mobile MCPサーバーが起動しているか
- 対象デバイス（エミュレータまたは実機）が接続・認識されているか
- `adb devices` でデバイスが表示されるか

**確認せずにテストを開始してはいけません。**

#### 1.2 スクリーンショットと座標のキャリブレーション
テスト開始時に、**最初のスクリーンショットを撮影**し、以下をユーザーに確認すること：

- スクリーンショットに表示されている画面が実際のデバイス画面と一致するか
- スクリーンショット上の座標とデバイス上の実際の座標がマッチしているか
- デバイスの解像度・画面サイズが想定通りか

**座標のずれはテスト失敗の最大原因です。最初に必ず検証してください。**

### 2. スクリーンショット運用ルール（厳守）

#### 2.1 基本原則：行動するたびにスクリーンショットを撮る

- **すべての操作の前後**でスクリーンショットを撮影する
- **画面遷移のたび**にスクリーンショットを撮影し、正しい画面にいることを確認する
- **入力操作の後**にスクリーンショットを撮影し、入力値が反映されたことを確認する
- **スクロール操作の後**にスクリーンショットを撮影し、表示内容を確認する

#### 2.2 座標タップ時の必須手順

座標指定による操作は**特に慎重に**行うこと：

1. **操作前**: スクリーンショットを撮影し、タップ対象の要素と座標を確認する
2. **操作実行**: 確認した座標でタップする
3. **操作後**: スクリーンショットを撮影し、意図した要素が操作されたことを確認する
4. **不一致時**: 想定と異なる場合は、再度スクリーンショットで現在の画面状態を確認してから次の操作に進む

**キャッシュした座標を使い回さないこと。画面状態が変わるたびに座標を再確認すること。**

#### 2.3 スクリーンショットは監査証跡として保存する

- 撮影したスクリーンショットは**すべて監査対象として保存**する
- テスト完了後にスクリーンショットを削除しない
- 各スクリーンショットには、どのステップで撮影したものかが分かるようにする
- テスト結果のレポートにスクリーンショットを証跡として含める

### 3. エラー発生時の対応（必須）

**エラーが発生したら、以下を必ず実施する：**

1. **即座にスクリーンショットを撮影**して現在の画面状態を記録する
2. **スクリーンショットと座標の整合性を再チェック**する（座標ずれが原因でないか確認）
3. エラーの原因を特定する（座標ずれ / 画面遷移の失敗 / アプリのクラッシュ / タイミングの問題）
4. 必要に応じてスクリーンショットを撮り直し、現在の正確な画面状態を把握してからリトライする

**エラー発生時にスクリーンショットと座標の確認を省略してはいけません。これは毎回必ず行うルールです。**

### 4. Mobile MCP操作のベストプラクティス

- **タップ操作**: セマンティクスラベルが使える場合はラベルを優先する。座標タップは最終手段とする
- **待機**: 画面遷移やアニメーション後は適切に待機してからスクリーンショットを撮る
- **テキスト入力**: 入力フィールドをタップして選択状態にしてからテキストを入力する
- **スクロール**: リスト全体を確認する必要がある場合は、スクロールしながらスクリーンショットを撮る
- **戻る操作**: Androidの戻るボタンやナビゲーションバーの戻るを使用する
- **ディープリンク**: ディープリンクを開く際は**Chromeブラウザのアドレスバーに入力**して開くこと。アドレスバーでそのままSubmit/Enterすると検索になってしまうため、必ず `chrome` アプリを起動し、アドレスバーにURLを入力した上でリンクとして開く。`adb shell am start` コマンドでも可

### 5. テストシナリオ実行時の注意

- 各テストシナリオは**独立して**実行できるようにする
- テスト開始時は必ず**ログイン画面から**スタートする
- Fault Injectionのテストでは、**Debug Info画面のスクリーンショット**を証跡として必ず残す
- テスト結果は「合格/不合格」を明確にし、不合格の場合はスクリーンショットとともに具体的な差分を報告する

---

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

## Semantics Labels (E2E)

All UI elements use centralized labels from [`SemanticsLabels`](lib/shared/semantics/semantics_labels.dart):
- Transaction rows use dynamic IDs: `SemanticsLabels.txRow(id)` → `tx.row.tx_0010`
- Timestamp display: `SemanticsLabels.txRowTimestamp(id)` → `tx.row.tx_0010.timestamp`

**Critical:** Transaction list displays ISO timestamps directly (e.g., `2026-01-30T14:30:00Z`) for E2E verification.

### 主要セマンティクスラベル一覧

- **ログイン画面**: `login.username`, `login.password`, `login.submit`, `login.error`
- **ホーム画面**: `home.username`, `home.monthlyTotal`, `home.toTransactions`, `home.toSettings`
- **利用明細一覧**: `tx.list`, `tx.sortLabel`, `tx.row.<id>`, `tx.row.<id>.timestamp`
- **利用明細詳細**: `tx.detail.title`, `tx.detail.timestamp`, `tx.detail.amount`, `tx.detail.status`
- **設定画面**: `settings.notifications`, `settings.maskAmount`, `settings.biometric`, `settings.logout`
- **デバッグ**: `debug.panel`, `debug.fault.sortReversed`, `debug.fault.status`, `debug.info.open`

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
- Oldest: `tx_0000`
- IDs are sequential but timestamps are not

## Testing

```bash
flutter test                    # Run all tests
flutter test test/widget_test.dart  # Run specific test
```
