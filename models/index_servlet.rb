require 'webrick'
require_relative 'render_template'
require_relative 'db'
require_relative 'escape_html'

class IndexServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(req, res)
        # データベースから新着スレッド10件を取得する
        db = DB.new('bbs.db')
        threads = db.fetch_latest_threads(10)
        db.close

        res.status = 200
        res['Content-Type'] = 'text/html'
        res.body = render_template('index', {
            threads: threads
        })
    end
end