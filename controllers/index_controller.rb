require 'webrick'
require_relative './database/db_connection'
require_relative './helpers/render_template'
require_relative './helpers/escape_html'

class IndexServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(req, res)
        # データベースから新着スレッド20件を取得する
        db = DB.new('bbs.db')
        threads = db.fetch_latest_threads(20)
        db.close

        res.status = 200
        res['Content-Type'] = 'text/html'
        res.body = render_template('index', {
            threads: threads
        })
    end
end