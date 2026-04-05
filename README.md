# e2etest_flutter

E2Eテスト用デモアプリケーション

## 概要

<<<<<<< HEAD
このプロジェクトは、Maestro E2Eテストフレームワークでの自動テストを想定した、利用明細確認アプリです。
=======
このプロジェクトは、**Mobile MCP**を使ったE2Eテストを想定した、利用明細確認アプリです。意図的な不具合（Fault Injection）を注入し、正常系と異常系の両方をテストできる設計になっています。
>>>>>>> fb95bde6bc02c6c4ef04bc5d83ffec6da0970daa

### 主な機能

- **利用明細一覧・詳細表示**：固定シードデータによる取引履歴の表示
- **設定管理**：通知、金額マスク、生体認証のトグル（SharedPreferencesで永続化）
<<<<<<< HEAD
- **セマンティクスラベル**：Maestroテスト用の一意なアクセシビリティラベル
=======
- **デバッグパネル**：Fault状態の確認と切り替え
- **セマンティクスラベル**：E2Eテスト用の一意なアクセシビリティラベル
- **ディープリンク**：`e2etestflutter://` スキームによる画面直接遷移
>>>>>>> fb95bde6bc02c6c4ef04bc5d83ffec6da0970daa

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

<<<<<<< HEAD
- FVM（Flutter Version Management）がインストール済みであること[^fvm-docs]
- Android Studio（Android開発の場合）
=======
- Flutter SDK 3.2.6以上
- Android Studio（エミュレータ使用時）
- Android SDK & Platform Tools（`adb` コマンド）
- Mobile MCPサーバーが起動済みであること
>>>>>>> fb95bde6bc02c6c4ef04bc5d83ffec6da0970daa

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

<<<<<<< HEAD
## 実行方法

### Android Studio エミュレーター起動（参考）

```bash
# 利用可能なエミュレーター一覧
fvm flutter emulators

# 指定したエミュレーターを起動（例）
fvm flutter emulators --launch <emulator_id>
```

`<emulator_id>` は `fvm flutter emulators` の出力に表示される ID を指定してください。

### アプリ起動

```bash
fvm flutter run
```

=======
#### Step 2: エミュレータの準備

```bash
# 利用可能なエミュレータ一覧を確認
flutter emulators

# エミュレータの起動（例: Pixel_7_API_34）
flutter emulators --launch Pixel_7_API_34

# または Android Studio の AVD Manager からエミュレータを起動
# Android Studio > Tools > Device Manager > ▶ ボタン
```

#### Step 3: エミュレータの接続確認

```bash
# デバイスが認識されているか確認
adb devices

# 出力例:
# List of devices attached
# emulator-5554  device
```

`device` と表示されていれば接続OK。`offline` や `unauthorized` の場合は対処が必要。

#### Step 4: アプリのビルド・インストール

```bash
# 正常系（Fault OFF）でビルド＆実行
flutter run

# 異常系（Fault ON）でビルド＆実行
flutter run --dart-define=FAULT=SORT_REVERSED
```

#### Step 5: Mobile MCPの起動と接続確認

1. Mobile MCPサーバーを起動する
2. エミュレータが Mobile MCP から認識されていることを確認する
3. **テスト用のスクリーンショットを1枚撮影**し、画面が正しく映っているか確認する
4. スクリーンショット上の座標がエミュレータの座標とマッチしていることを確認する

---

### 実機でテストする場合

#### Step 1: プロジェクトのセットアップ

エミュレータの場合と同じです（上記 Step 1 参照）。

#### Step 2: 実機の準備

1. **開発者オプションを有効化**
   - 設定 > デバイス情報 > ビルド番号を7回タップ
2. **USBデバッグを有効化**
   - 設定 > 開発者向けオプション > USBデバッグ ON
3. **USBケーブルで接続**
   - PCとAndroid端末をUSBケーブルで接続
   - 端末に表示される「USBデバッグを許可しますか？」で「許可」をタップ

#### Step 3: 実機の接続確認

```bash
# デバイスが認識されているか確認
adb devices

# 出力例:
# List of devices attached
# XXXXXXXXXXXXXXX  device
```

#### Step 4: アプリのビルド・インストール

```bash
# 正常系でビルド＆実行（実機に自動インストール）
flutter run

# 異常系でビルド＆実行
flutter run --dart-define=FAULT=SORT_REVERSED
```

#### Step 5: Mobile MCPの起動と接続確認

エミュレータの場合と同じ手順で接続を確認する。
実機特有の注意点：
- 画面解像度がエミュレータと異なるため、座標のキャリブレーションは特に重要
- 画面の明るさやダークモード設定がスクリーンショットに影響する場合がある
- USB接続が不安定な場合はケーブルを変えて再試行

---

### E2Eテスト実行手順

#### テスト開始前チェックリスト

- [ ] Mobile MCPサーバーが起動している
- [ ] デバイス（エミュレータ/実機）が接続されている（`adb devices` で確認）
- [ ] アプリがデバイスにインストールされている
- [ ] 最初のスクリーンショットで画面と座標が一致することを確認済み

#### テストシナリオA: 正常系

1. **ログイン**
   - アプリを起動し、ログイン画面を表示
   - Username: `demo_user`、Password: `password` を入力
   - 「Login」ボタンをタップ
   - **→ スクリーンショットで確認**: ホーム画面が表示されること

2. **利用明細一覧へ遷移**
   - 「利用明細へ」ボタンまたはボトムタブの「取引」をタップ
   - **→ スクリーンショットで確認**: 利用明細一覧が表示されること

3. **ソート順の検証（降順）**
   - 先頭2件のタイムスタンプ（ISO 8601形式）を読み取る
   - 1件目のタイムスタンプが2件目より新しいことを確認
   - **期待値**: 1件目 > 2件目（降順）

4. **明細詳細の整合確認**
   - 先頭の明細をタップして詳細画面へ遷移
   - merchant / amount / timestamp / status が一覧の値と一致することを確認
   - **→ スクリーンショットで確認**: 詳細画面の内容

5. **設定の永続化確認**
   - 設定画面でトグルを変更（例: 通知 ON → OFF）
   - ログアウト → 再ログイン
   - 設定が保持されていることを確認

#### テストシナリオB: 異常系（Fault検出）

1. **Faultの有効化**
   - 設定画面のデバッグパネルで `debug.fault.sortReversed` をONにする
   - または `flutter run --dart-define=FAULT=SORT_REVERSED` で起動

2. **利用明細一覧でソート順の検証**
   - 先頭2件のタイムスタンプを読み取る
   - **期待結果**: 1件目のタイムスタンプが2件目より古い（昇順 = バグ）
   - ソートラベルは「日付：新しい順」のまま（矛盾が存在する）

3. **証跡の記録**
   - 画面右上の「ⓘ Debug Info」ボタンをタップ
   - `fault=SORT_REVERSED` と表示されていることを確認
   - **→ スクリーンショットで証跡を保存**

#### テストシナリオC: ディープリンク

1. **ディープリンクでの直接遷移**
   - **Chromeブラウザを起動**し、アドレスバーに以下を入力して開く:
     `e2etestflutter:///transactions/tx_0006`
   - **注意**: アドレスバーでそのままEnter/Submitすると**Google検索**になってしまう。URLとしてリンクを開くこと
   - または`adb`コマンドで実行:
     ```bash
     adb shell am start -a android.intent.action.VIEW -d "e2etestflutter:///transactions/tx_0006"
     ```
   - ログイン画面が表示されたらログインする
   - **→ スクリーンショットで確認**: ログイン後、ホーム画面ではなく明細詳細画面（Amazon, tx_0006）に直接遷移すること

---

## Fault Injection仕様

### SORT_REVERSED

- **正常時**：取引履歴が降順（新しい→古い）で表示される
- **Fault時**：取引履歴が昇順（古い→新しい）で表示される
- **検証方法**：リスト先頭2件のタイムスタンプ（ISO 8601形式）を比較

### Fault制御方法

1. **起動時フラグ**：`--dart-define=FAULT=SORT_REVERSED`
2. **デバッグパネル**：設定画面の`debug.fault.sortReversed`トグル
3. **状態確認**：画面右上の「ⓘ Debug Info」ボタンから現在のFault状態を確認

>>>>>>> fb95bde6bc02c6c4ef04bc5d83ffec6da0970daa
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

<<<<<<< HEAD
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

=======
>>>>>>> fb95bde6bc02c6c4ef04bc5d83ffec6da0970daa
## 詳細ドキュメント

- [要件定義](requirements.md)：詳細な機能要件とアーキテクチャ設計
- [AGENTS.md](AGENTS.md)：AI Agentのための開発ガイド（Mobile MCP E2Eテストガイド含む）
- [E2E手順書](e2etest/howto.md)：正常系E2Eテストの詳細手順

## 参照（公式）

[^fvm-docs]: [FVM Documentation（公式）](https://fvm.app/docs/getting_started/installation)

## ライセンス

このプロジェクトはデモ目的で作成されています。
