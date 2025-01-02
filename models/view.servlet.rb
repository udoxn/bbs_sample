require 'webrick'
require_relative 'render_template'
require_relative 'db'
require_relative 'escape_html'

class ViewServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(req, res)
        # idがなければホームにリダイレクト
        if !(req.query.include?('id') || req.query['id'] == '')
            res.status = 302
            res['Location'] = '/'
        end

        id = req.query['id']

        # データベースから新着スレッド10件を取得する
        db = DB.new('bbs.db')
        thread = db.fetch_threads_by_id(id)
        replys = db.fetch_replys_by_thread_id(id)
        db.close

        res.status = 200
        res['Content-Type'] = 'text/html'
        res.body = render_template('view', {
            thread: thread[0],
            replys: replys
        })
    end
end