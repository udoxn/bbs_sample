require 'sqlite3'

def create_table()
    # SQLite3データベースに接続
    db = SQLite3::Database.new "bbs.db"

    # threadsテーブルの作成
    db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS threads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        datetime DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    SQL

    # replysテーブルの作成
    db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS replys (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        thread_id INTEGER NOT NULL,
        reply_number INTEGER NOT NULL,
        name TEXT NOT NULL,
        content TEXT NOT NULL,
        datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (thread_id) REFERENCES threads(id)
    );
    SQL

    true
rescue => e
    puts "Error create table : #{e.message}"
    false
ensure
    # DBを閉じる
    db.close
end