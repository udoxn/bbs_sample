require 'sqlite3'

class DB
    def initialize(db_name)
        @db = SQLite3::Database.new(db_name)
        @db.results_as_hash = true
        @db.encoding = 'UTF-8'
    rescue => e
        puts "Error initializing database: #{e.message}"
        false
    end

    # threadsにname, title, contentをインサートする
    def insert_thread(name, title, content)
        # ユニコードをUTF-8に変換
        name = name.force_encoding('UTF-8')
        title = title.force_encoding('UTF-8')
        content = content.force_encoding('UTF-8')
        datetime = Time.now.to_s

        @db.execute("INSERT INTO threads (name, title, content, datetime) VALUES (?, ?, ?, ?)", [name, title, content, datetime])
        true
    rescue => e
        puts "Error inserting thread: #{e.message}"
        false
    end

    # threadsから新しい順10件を取得する
    def fetch_latest_threads(limit = 10)
        # 最新のスレッドを制限数まで取得し、max_reply_numberを計算して含める
        @db.execute(<<-SQL, [limit])
            SELECT
                threads.id,
                threads.title,
                threads.datetime,
                COALESCE(MAX(replys.reply_number), 0) AS max_reply_number
            FROM
                threads
            LEFT JOIN
                replys
            ON
                threads.id = replys.thread_id
            GROUP BY
                threads.id, threads.title, threads.datetime
            ORDER BY
                threads.datetime DESC
            LIMIT ?
        SQL
    rescue => e
        puts "Error fetching latest threads: #{e.message}"
        false
    end

    # idを指定してthreadsから取得
    def fetch_threads_by_id(id)
        @db.execute("SELECT id,title,name,content,datetime FROM threads WHERE id=?", [id.to_i])
    rescue => e
        puts "Error fetching threads by id: #{e.message}"
        false
    end

    # threadsの特定のtitleを含む列をすべて取得する
    def fetch_threads_by_title(q)
        @db.execute("SELECT * FROM threads WHERE title LIKE ?", ["%#{q.force_encoding('UTF-8')}%"])
    rescue => e
        puts "Error fetching threads by title: #{e.message}"
        false
    end

    # replysの特定のthread_idの中で,最大の数字のreply_numberを取得する
    def fetch_max_reply_number(thread_id)
        result = @db.execute("SELECT MAX(datetime), reply_number FROM replys WHERE thread_id = ?", [thread_id.to_i])

        # 存在しなければ0を返す
        if !(result[0]['reply_number'] == nil)
            result[0]['reply_number']
        else
            1
        end
    rescue => e
        puts "Error fetching max reply number: #{e.message}"
        false
    end

    # replysにthread_id, reply_number, name, contentをインサートする
    def insert_reply(thread_id, reply_number, name, content)
        thread_id = thread_id.to_i
        reply_number = reply_number.to_i
        name = name.force_encoding('UTF-8')
        content = content.force_encoding('UTF-8')

        @db.execute("INSERT INTO replys (thread_id, reply_number, name, content) VALUES (?, ?, ?, ?)", [thread_id, reply_number, name, content])
        true
    rescue => e
        puts "Error inserting reply: #{e.message}"
        false
    end

    # replysの特定のthread_idを含む列をすべて取得する
    def fetch_replys_by_thread_id(thread_id)
        @db.execute("SELECT * FROM replys WHERE thread_id = ? ORDER BY reply_number ASC", [thread_id.to_i])
    rescue => e
        puts "Error fetching replies by thread ID: #{e.message}"
        false
    end

    def close
        @db.close if @db
        true
    rescue => e
        puts "Error closing database: #{e.message}"
        false
    end
end

# 使用例
# db = DB.new('bbs.db')
# db.insert_thread('Alice', 'First Post', 'Hello, this is the first thread!')
# db.fetch_latest_threads.each { |thread| puts thread }
# db.insert_reply(1, 1, 'Bob', 'This is a reply to the first thread.')
# db.fetch_replies_by_thread_id(1).each { |reply| puts reply }
