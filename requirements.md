## 1. 目的と前提

### 目的

* Androidネイティブアプリとして動作する「利用明細確認＋設定」アプリを実装する
* **Fault Injection（意図的な不具合注入）** をアプリ側に仕込み、E2Eで再現できる
* **Maestroで安定してUI操作・検証できる**（アクセシビリティ/セマンティクス重視）
* AI agent（Maestro MCP）から、同一シナリオを

  * 正常系（fault off）
  * 異常系（fault=SORT_REVERSED）
    で実行し、差分をレポートできる

### 非目的（やらない）

* 送金/出金/実決済/秘密鍵/暗号資産
* 多要素認証の本実装（デモ用UIは可）
* サーバー必須の構成（オフラインでも動く）

### 対象

* **Android**（まずはAndroid Studio / emulator / 実機で動作）
* iOSは後回し（仕様としては拡張可能）

---

## 2. 画面一覧・機能要件

### 2.1 ログイン画面

**目的**：E2E開始点の固定化
**要素**

* Username（初期値：`demo_user`）
* Password（初期値空、正解は`password`）
* Loginボタン
* エラーメッセージ領域

**挙動**

* `demo_user/password` → 成功してホームへ
* それ以外 → エラー表示「ユーザー名またはパスワードが違います」

**テスト用セマンティクス（必須）**

* `login.username`
* `login.password`
* `login.submit`
* `login.error`

---

### 2.2 ホーム画面

**要素**

* ユーザー名表示
* 今月の支出合計（seedデータから算出）
* 最新明細3件（タップで明細一覧へ）
* 「利用明細へ」「設定へ」ボタン

**セマンティクス**

* `home.username`
* `home.monthlyTotal`
* `home.toTransactions`
* `home.toSettings`

---

### 2.3 利用明細一覧画面（主戦場）

**要素**

* 期間表示（例：`2026-01`固定でOK）
* 件数表示
* ソートラベル：**「日付：新しい順」**（固定表示）
* 明細リスト（加盟店 / 金額 / 日時 / ステータス）
* 検索（merchant部分一致）※任意（あるとE2Eが楽）
* カテゴリフィルタ（`Subscription`など1つだけでもOK）※任意

**正常仕様（fault off）**

* デフォルト並び：**timestamp 降順（新しい→古い）**
* 同一timestampの場合：`id` 降順

**fault on（SORT_REVERSED）**

* 明細が **timestamp 昇順（古い→新しい）** で表示される
* ただしソートラベルは **「日付：新しい順」のまま**（意図的に矛盾）

**E2E検証しやすさ要件（重要）**

* 各行に `timestampISO` を **そのまま表示**（例：`2026-01-29T10:00:00Z`）
* リスト先頭2件のtimestampを比較すれば、降順/昇順が確実に判定できる

**セマンティクス（必須）**

* `tx.list`
* `tx.sortLabel`
* `tx.row.<id>`（例：`tx.row.tx_0003`）
* `tx.row.<id>.timestamp`
* `tx.row.<id>.merchant`
* `tx.row.<id>.amount`

---

### 2.4 利用明細詳細画面

**要素**

* merchant
* amount / currency
* timestamp（ISO＋ローカル表示）
* category
* paymentMethodLabel（例：`Visa •••• 1234`）
* status（`Posted` or `Pending`）

**セマンティクス**

* `tx.detail.title`
* `tx.detail.timestamp`
* `tx.detail.amount`
* `tx.detail.status`

---

### 2.5 設定画面

**要素**

* 通知（ON/OFF）
* 金額マスク（ON/OFF）
* 生体認証（デモ用トグル）（ON/OFF）
* ログアウト

**永続化**

* SharedPreferences（またはHive）で保存
* 再ログイン後も保持

**セマンティクス**

* `settings.notifications`
* `settings.maskAmount`
* `settings.biometric`
* `settings.logout`

---

## 3. Fault Injection 設計（Androidネイティブ向け）

### 3.1 Fault種類

* `SORT_REVERSED`（今回の主題）

### 3.2 FaultのON/OFF方法（再現性重視）

最低1つは必須。おすすめは **(A) と (B)** の併用。

**(A) デバッグ画面（アプリ内）**

* 設定画面の最下部に「Debug」セクション（`debug.panel`）
* `debug.fault.sortReversed` トグルでON/OFF
* 現在のfault状態をテキスト表示（`debug.fault.status`）

**(B) 起動時フラグ（Android向け・CIでも使える）**

* `--dart-define=FAULT=SORT_REVERSED` をサポート
* 例：`flutter run --dart-define=FAULT=SORT_REVERSED`
* アプリ起動時に SharedPreferences に反映してもOK（起動毎に上書きする挙動は仕様として決める）

**(C) Deep Link（任意）**

* `demo-wallet://fault?name=SORT_REVERSED&enabled=1`
* MaestroでURL起動できる環境なら便利（ただし構築が少し増える）

### 3.3 faultの痕跡（報告を簡単にする）

* 画面右上に「ⓘ Debug Info」ボタン（`debug.info.open`）
* 押すとダイアログで

  * `fault=SORT_REVERSED` / `fault=none`
  * build version
  * seed version
    を表示（`debug.info.text`）
* エラーではないが「今どのfault状態か」を証跡として残せる

---

## 4. データ仕様（固定seed・毎回同じ）

### Transactionモデル

* `id: String`（例 `tx_0001`）
* `timestampISO: String`（Z固定推奨）
* `merchant: String`
* `amount: int`（JPY想定の整数）
* `currency: String = "JPY"`
* `category: enum { Subscription, Groceries, Transport, Shopping }`
* `paymentMethodLabel: String`（例 `Visa •••• 1234`）
* `status: enum { Posted, Pending }`

### Seed要件

* 10件以上
* timestampがバラける
* 最も新しい明細が分かりやすい（例：`AWS`が最新）

---

## 5. アーキテクチャ要件（Maestro向けに“壊れにくい”構成）

### 推奨構成（シンプルClean Architecture）

* `lib/`

  * `app/`（ルーティング、DI、テーマ）
  * `features/auth/`
  * `features/transactions/`
  * `features/settings/`
  * `data/`（Repositories, DataSources, seed）
  * `domain/`（Entities, UseCases）
  * `infra/`（FaultController, Storage, Logger）

### 状態管理

* Riverpod / Bloc / Provider のどれでもよい
  条件：**画面が再描画してもセマンティクスIDが安定すること**

### 擬似API層（重要）

* `TransactionsRepository.getTransactions(...)` が

  * 正常：降順で返す
  * fault：昇順で返す
* UI側にsortロジックを散らさない（バグの切り替え点を1箇所に固定）

---

## 6. MaestroでテストしやすくするUI/実装ルール（必須）

### 6.1 セマンティクスを最優先

* 主要なタップ要素・入力・表示に **一意のSemanticsラベル**を付与する
  例：`Semantics(label: 'login.submit', button: true, child: ElevatedButton(...))`
* リスト行も `tx.row.tx_0003` のように **一意**にする
* 金額・timestampは表示テキストをそのまま検証できるようにする（加工しすぎない）

### 6.2 テスト用に挙動を安定化

* アニメーションは最小（過剰なフェード/遷移は避ける）
* 初期ローディングは短め固定（例：200ms）でよいが、無限スピナーは作らない
* エラー表示や空状態は固定文言にする（文言がブレない）

### 6.3 “テストモード”を用意（任意だが強い）

* `--dart-define=E2E=1` のとき

  * ローディング短縮
  * デバッグパネル常時表示
  * seed固定強制
    などを有効化できる

---

## 7. 受け入れ条件（Acceptance Criteria）

### 正常系（fault off）

* ログイン成功→ホーム表示
* 明細一覧表示
* **先頭のtimestampが最大**（降順）である
* 明細詳細が一覧の選択内容と一致する
* 設定トグルが保存され、再ログイン後も保持される

### 異常系（fault=SORT_REVERSED）

* 明細一覧の順序が **昇順**になり、E2Eで検出できる
* ソートラベルは「日付：新しい順」のまま（矛盾）
* Debug Info に fault状態が表示され、証跡にできる

---

## 8. デモ用E2Eシナリオ（Maestro想定）

### シナリオA（正常）

1. ログイン
2. 明細一覧へ
3. `tx.row.<first>.timestamp` と `tx.row.<second>.timestamp` を取得して **降順**を検証
4. 先頭明細を開き詳細一致を確認
5. 設定で通知トグル変更→戻る→再ログイン→保持確認

### シナリオB（バグ検出）

1. faultをON（デバッグパネル or 起動フラグ）
2. 明細一覧へ
3. 同じ比較を行い **降順のはずが昇順**であることを検出
4. Debug Info を開き `fault=SORT_REVERSED` を証跡として取得
5. 期待/実際/再現手順をレポート
