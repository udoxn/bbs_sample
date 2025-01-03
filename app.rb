require 'webrick'
require 'dotenv/load'

# servletを読み込み
require_relative './controllers/index_controller'
require_relative './controllers/view_controller'
require_relative './controllers/search_controller'
require_relative './controllers/post_thread_controller'
require_relative './controllers/post_reply_controller'
require_relative './controllers/error_controller'

# データベースが存在しない場合はテーブルと一緒に作成
require_relative './controllers/database/create_table'
dbname = ENV['SQLITE3_DATABASE_FILE']
error = false
if !(File.exist?(dbname))
    if create_table()
        puts "データベースを作成しました"
    else
        error = true
        puts "データベースの作成に失敗しました"
    end
end

if !(error)
    # サーバーの設定
    port = 8080
    server = WEBrick::HTTPServer.new(Port: port)

    # 静的ファイルを配信するための設定
    server.mount('/public', WEBrick::HTTPServlet::FileHandler, File.join(__dir__, 'public'))

    # ルーティング
    server.mount '/', IndexServlet
    server.mount '/create_thread', CreateThreadServlet
    server.mount '/error', ErrorServlet
    server.mount '/view', ViewServlet
    server.mount '/post_reply', PostReplyServlet
    server.mount '/search', SearchServlet

    # Ctrl+Cでサーバーを停止する
    trap('INT') { server.shutdown }

    puts "http://localhost:#{port}"

    server.start
end