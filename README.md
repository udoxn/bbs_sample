# bbs_sample

## 概要
`bbs_sample` は、RubyとWEBrickを使用した簡易的なWebアプリです。

## 使用している言語やライブラリ
- **Ruby**: 3.4.1
- **Gem**: 3.6.2
- **Bundler**: 2.6.2
- **その他のライブラリ情報**: [Gemfile](./Gemfile)をご参照ください

## インストールガイド

1. 下記のコマンドを実行して、正常に動作する環境を構築してください。

   ```bash
   bundle install             # 依存ライブラリのインストール
   bundle exec ruby create_table.rb  # SQLiteテーブルの作成
   bundle exec ruby app.rb    # アプリの起動
   ```

2. アプリが動作したら、ブラウザで `http://localhost:8080` にアクセスしてください。

## 注意
- **SQLite3**: 本アプリはSQLite3をデータベースとして使用しています。SQLite3がシステムにインストールされていることを確認してください。
- **Port**: デフォルトでは `8080` 番ポートを使用しています。これを変更する場合は `app.rb` 内の設定を編集してください。
