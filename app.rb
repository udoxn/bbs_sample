require 'webrick'

# servletを読み込み
require_relative './models/index.servlet'
require_relative './models/create_thread.servlet'
require_relative './models/error.servlet'
require_relative './models/view.servlet'
require_relative './models/post_reply.servlet'
require_relative './models/search.servlet'

# サーバーの設定
port = 8080
server = WEBrick::HTTPServer.new(
    Port: port,                # ポート番号
)

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
