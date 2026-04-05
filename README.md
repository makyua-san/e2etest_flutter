# e2etest_flutter

E2Eテスト用デモアプリケーション

## 概要

このプロジェクトは、**Mobile MCP**を使ったE2Eテストを想定した、利用明細確認アプリです。

### 主な機能

- **利用明細一覧・詳細表示**：固定シードデータによる取引履歴の表示
- **設定管理**：通知、金額マスク、生体認証のトグル（SharedPreferencesで永続化）
- **デバッグパネル**：Fault状態の確認と切り替え
- **セマンティクスラベル**：E2Eテスト用の一意なアクセシビリティラベル
- **ディープリンク**：`e2etestflutter://` スキームによる画面直接遷移

## 技術スタック

- **Flutter** 3.16.9（固定）
- **Riverpod** 2.5.0（状態管理）
- **go_router** 14.0.0（ルーティング）
- **shared_preferences** 2.2.0（永続化）
- **intl** 0.19.0（日時フォーマット）

---

## E2Eテスト手順書（Mobile MCP）

### Mobile MCPとは

Mobile MCPは、AIエージェントがモバイルデバイス（エミュレータ・実機）を直接操作できるツールです。スクリーンショット撮影、座標タップ、テキスト入力、スワイプなどの操作をプログラム的に実行できます。

### 前提条件

- FVM（Flutter Version Management）がインストール済みであること[^fvm-docs]
- Android Studio（Android開発の場合）
- Mobile MCPサーバーが起動済みであること


---

### エミュレータでテストする場合

#### Step 1: プロジェクトのセットアップ

#### FVMでFlutter / Dartを固定バージョンにする

まず FVM をインストールします（環境に合わせてどちらかを実行）。

```bash
# macOS (Homebrew)
brew tap leoafarias/fvm
brew install fvm
# Windows / Linux など（Dart経由）
dart pub global activate fvm
```

```bash
# プロジェクトで使用するFlutterを固定
fvm install 3.16.9
fvm use 3.16.9

# バージョン確認（Flutter 3.16.9 / Dart 3.2.6）
fvm flutter --version
fvm dart --version
```

#### プロジェクト依存関係のインストール

```bash
# リポジトリのクローン
git clone <repository-url>
cd e2etest_flutter

# 依存関係のインストール
fvm flutter pub get

# Riverpodコード生成
fvm dart run build_runner build --delete-conflicting-outputs
```

#### Step 2: エミュレータの準備

```bash
# 利用可能なエミュレータ一覧を確認
fvm flutter emulators

# エミュレータの起動（例: Pixel_7_API_34）
fvm flutter emulators --launch Pixel_7_API_34

# または Android Studio の AVD Manager からエミュレータを起動
# Android Studio > Tools > Device Manager > ▶ ボタン
```

#### Step 3: エミュレータの接続確認

```bash
# デバイスが認識されているか確認
fvm flutter devices
```

#### Step 4: アプリのビルド・インストール

```bash
fvm flutter run

# 異常系（Fault ON）でビルド＆実行
fvm flutter run --dart-define=FAULT=SORT_REVERSED
```

#### Step 5: Mobile MCPの起動と接続確認

1. Mobile MCPサーバーを起動する
2. エミュレータが Mobile MCP から認識されていることを確認する
3. **テスト用のスクリーンショットを1枚撮影**し、画面が正しく映っているか確認する
4. スクリーンショット上の座標がエミュレータの座標とマッチしていることを確認する

## セマンティクスラベル

E2Eテスト用に、すべての主要UI要素に一意のセマンティクスラベルを付与しています。

### 主要ラベル

- **ログイン画面**：`login.username`, `login.password`, `login.submit`, `login.error`
- **ホーム画面**：`home.username`, `home.monthlyTotal`, `home.toTransactions`, `home.toSettings`
- **利用明細一覧**：`tx.list`, `tx.sortLabel`, `tx.row.<id>`, `tx.row.<id>.timestamp`
- **設定画面**：`settings.notifications`, `settings.maskAmount`, `settings.biometric`, `settings.logout`

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
├── infra/            # インフラ層（Storage）
└── shared/           # 共通コンポーネント（Semantics、Widgets）
```


## E2Eテストシナリオ例

### 正常系シナリオ

1. ログイン（`demo_user` / `password`）
2. 利用明細一覧へ遷移
3. 先頭2件のタイムスタンプを取得し、降順を検証
4. 先頭明細の詳細を開き、内容の一致を確認
5. 設定でトグルを変更し、再ログイン後も保持されることを確認

## 開発ガイドライン

### Riverpodプロバイダー変更時

プロバイダーを変更した場合は、必ずコード生成を実行してください：

```bash
fvm dart run build_runner build --delete-conflicting-outputs

# または監視モード
fvm dart run build_runner watch
```

### セマンティクスラベルの追加

新しいUI要素を追加する際は、[`SemanticsLabels`](lib/shared/semantics/semantics_labels.dart)クラスに定数を追加し、`Semantics`ウィジェットでラップしてください。

## 詳細ドキュメント

- [要件定義](requirements.md)：詳細な機能要件とアーキテクチャ設計
- [AGENTS.md](AGENTS.md)：AI Agentのための開発ガイド（Mobile MCP E2Eテストガイド含む）
- [E2E手順書](e2etest/howto.md)：正常系E2Eテストの詳細手順
[^fvm-docs]: [FVM Documentation（公式）](https://fvm.app/docs/getting_started/installation)


## ライセンス

このプロジェクトはデモ目的で作成されています。
