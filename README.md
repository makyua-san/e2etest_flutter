# e2etest_flutter

Fault Injection機能を備えたE2Eテスト用デモアプリケーション

## 概要

このプロジェクトは、Maestro E2Eテストフレームワークでの自動テストを想定した、利用明細確認アプリです。意図的な不具合（Fault Injection）を注入し、正常系と異常系の両方をテストできる設計になっています。

### 主な機能

- **利用明細一覧・詳細表示**：固定シードデータによる取引履歴の表示
- **Fault Injection**：ソート順を反転させる不具合を意図的に注入
- **設定管理**：通知、金額マスク、生体認証のトグル（SharedPreferencesで永続化）
- **デバッグパネル**：Fault状態の確認と切り替え
- **セマンティクスラベル**：Maestroテスト用の一意なアクセシビリティラベル

## 技術スタック

- **Flutter** 3.2.6+
- **Riverpod** 2.5.0（状態管理）
- **go_router** 14.0.0（ルーティング）
- **shared_preferences** 2.2.0（永続化）
- **intl** 0.19.0（日時フォーマット）

## セットアップ

### 前提条件

- Flutter SDK 3.2.6以上
- Android Studio（Android開発の場合）
- Dart 3.2.6以上

### インストール

```bash
# 依存関係のインストール
flutter pub get

# Riverpodコード生成
dart run build_runner build --delete-conflicting-outputs
```

## 実行方法

### 通常起動（正常系）

```bash
flutter run
```

### Fault Injection有効化（異常系）

```bash
flutter run --dart-define=FAULT=SORT_REVERSED
```

このモードでは、利用明細のソート順が昇順（古い→新しい）に反転します。

### デバッグモード

アプリ内の設定画面下部にあるデバッグパネルから、Fault状態をトグルで切り替えることも可能です。

## Fault Injection仕様

### SORT_REVERSED

- **正常時**：取引履歴が降順（新しい→古い）で表示される
- **Fault時**：取引履歴が昇順（古い→新しい）で表示される
- **検証方法**：リスト先頭2件のタイムスタンプ（ISO 8601形式）を比較

### Fault制御方法

1. **起動時フラグ**：`--dart-define=FAULT=SORT_REVERSED`
2. **デバッグパネル**：設定画面の`debug.fault.sortReversed`トグル
3. **状態確認**：画面右上の「ⓘ Debug Info」ボタンから現在のFault状態を確認

## セマンティクスラベル

Maestro E2Eテスト用に、すべての主要UI要素に一意のセマンティクスラベルを付与しています。

### 主要ラベル

- **ログイン画面**：`login.username`, `login.password`, `login.submit`, `login.error`
- **ホーム画面**：`home.username`, `home.monthlyTotal`, `home.toTransactions`, `home.toSettings`
- **利用明細一覧**：`tx.list`, `tx.sortLabel`, `tx.row.<id>`, `tx.row.<id>.timestamp`
- **設定画面**：`settings.notifications`, `settings.maskAmount`, `settings.biometric`, `settings.logout`
- **デバッグ**：`debug.panel`, `debug.fault.sortReversed`, `debug.fault.status`, `debug.info.open`

詳細は[`lib/shared/semantics/semantics_labels.dart`](lib/shared/semantics/semantics_labels.dart)を参照してください。

## シードデータ

固定の11件の取引データを使用しています：

- **合計金額**：39,390 JPY
- **最新取引**：`tx_0010` (AWS, 2026-01-30T14:30:00Z)
- **最古取引**：`tx_0000`

詳細は[`lib/data/seed/seed_transactions.dart`](lib/data/seed/seed_transactions.dart)を参照してください。

## テスト

```bash
# すべてのテストを実行
flutter test

# 特定のテストファイルを実行
flutter test test/widget_test.dart
```

## プロジェクト構造

```
lib/
├── app/              # アプリケーション設定（ルーティング、テーマ）
├── data/             # データ層（Repository、DataSource、Seed）
├── domain/           # ドメイン層（Entity）
├── features/         # 機能別モジュール
│   ├── auth/         # 認証機能
│   ├── home/         # ホーム画面
│   ├── settings/     # 設定画面
│   └── transactions/ # 利用明細機能
├── infra/            # インフラ層（Fault制御、Storage）
└── shared/           # 共通コンポーネント（Semantics、Widgets）
```

## E2Eテストシナリオ例

### 正常系シナリオ

1. ログイン（`demo_user` / `password`）
2. 利用明細一覧へ遷移
3. 先頭2件のタイムスタンプを取得し、降順を検証
4. 先頭明細の詳細を開き、内容の一致を確認
5. 設定でトグルを変更し、再ログイン後も保持されることを確認

### 異常系シナリオ（Fault検出）

1. Faultを有効化（デバッグパネルまたは起動フラグ）
2. 利用明細一覧へ遷移
3. 先頭2件のタイムスタンプを取得し、昇順になっていることを検出
4. Debug Infoを開き、`fault=SORT_REVERSED`を証跡として記録

## 開発ガイドライン

### Riverpodプロバイダー変更時

プロバイダーを変更した場合は、必ずコード生成を実行してください：

```bash
dart run build_runner build --delete-conflicting-outputs

# または監視モード
dart run build_runner watch
```

### セマンティクスラベルの追加

新しいUI要素を追加する際は、[`SemanticsLabels`](lib/shared/semantics/semantics_labels.dart)クラスに定数を追加し、`Semantics`ウィジェットでラップしてください。

## 詳細ドキュメント

- [要件定義](requirements.md)：詳細な機能要件とアーキテクチャ設計
- [AGENTS.md](AGENTS.md)：AI Agentのための開発ガイド

## ライセンス

このプロジェクトはデモ目的で作成されています。
