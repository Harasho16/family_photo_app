# 写真管理 & ツイート連携アプリ

Rails 8 を用いて構築した、  
**写真アップロード・一覧管理 + OAuth 連携によるツイート機能**を備えたサンプルアプリケーションです。

外部認証ライブラリ（Devise 等）は使用せず、  
**Rails 標準機能を中心に自前実装**しています。

---

## 使用技術

- Ruby 3.4.x
- Rails 8.1.x
- Active Storage（画像アップロード）
- SQLite（development / test）
- RSpec
- OAuth 2.0
- Net::HTTP（外部 API 通信）
- Propshaft（Rails 8 デフォルトのアセット管理）

---

## 主な機能

### ユーザー認証（自前実装）

- メールアドレス + パスワードによるログイン
- `has_secure_password` を利用
- メールアドレスは **大文字・小文字を区別しない**
- ログイン必須制御は `ApplicationController` に集約
- 未ログイン時はログイン画面へリダイレクト

---

### 写真アップロード

- タイトル・画像ファイルを指定してアップロード
- バリデーション
  - タイトル必須
  - タイトル最大 30 文字
  - 画像ファイル必須
- Active Storage による画像管理
- アップロード成功時は写真一覧へ遷移
- キャンセルで一覧画面へ戻る

---

### 写真一覧

- ログイン中ユーザーがアップロードした写真のみ表示
- アップロードした日時の降順で表示
- 表示内容
  - タイトル
  - サムネイル画像
- OAuth 連携済みの場合のみ「ツイート」ボタンを表示

---

### OAuth 連携

- 写真一覧ページから OAuth 認可ページへ遷移
- リダイレクト URI http://localhost:3000/oauth/callback
- 認可コードを用いてアクセストークンを取得
- アクセストークンは session に保存

---

### ツイート機能

- OAuth 連携済みの場合、写真ごとにツイート可能
- Net::HTTP を用いて外部 API へ POST
- Authorization ヘッダに Bearer トークンを付与
- ツイート内容

```json
{
  "text": "写真タイトル",
  "url": "画像URL"
}
```

- 成功時 / 失敗時はフラッシュメッセージを表示

---

## 環境構築

### 1. 必要なもの

- Ruby 3.4.x
- Rails 8.1.x
- SQLite
- libvips（Active Storage の画像処理で必須）

---

### 2. リポジトリを取得

```bash
git clone <repository-url>
cd <repository-name>
```

---

### 3. Ruby / Gem のセットアップ

```bash
bundle install
```

---

### 4. データベース作成・初期化

```bash
rails db:create
rails db:migrate
rails db:seed
```

---

### 5. libvips のインストール

Active Storage の variant（リサイズ等）を使うために libvips が必須です。

#### macOS（Homebrew を使わない場合）

公式バイナリをダウンロード
https://github.com/libvips/libvips/releases

dmg または zip を展開し、インストール

パスが通っていることを確認

```bash
vips -l
```

---

#### macOS（Homebrew を使う場合）

```bash
brew install vips
```

---

#### Windows

1. 以下から Windows 用バイナリをダウンロード.  
   https://github.com/libvips/build-win64-mxe/releases

2. zip を展開し、任意のディレクトリへ配置.  
   例：

```
C:\libvips
```

3. 環境変数 PATH に追加

```
C:\libvips\bin
```

4. 確認

```
vips -l
```

---

### 6. サーバ起動

```bash
rails server
```

ブラウザで以下にアクセス

```bash
http://localhost:3000
```

---

### 初期データ

db/seeds.rb にてテスト用ユーザーを作成しています。

---

### テスト

- RSpec（request spec 中心）
- テスト対象
  - ログイン・認可制御
  - 写真一覧表示
  - 写真アップロード
  - OAuth callback
  - ツイート処理
- 外部 API 通信は実行しない（スタブ）

```bash
bundle exec rspec
```

---

## 今後の改善点（TODO）

- OAuth トークンの有効期限管理
- リフレッシュトークン対応
- ページネーション
- エラーハンドリングの共通化
- 本番向けログ設計（構造化ログ）

以上
