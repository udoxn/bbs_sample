require 'webrick'
require_relative './database/db_connection'
require_relative './helpers/render_template'
require_relative './helpers/escape_html'

def replace_reply_links(text)
    # 正規表現で ">>数字" を検出し、リンクタグに置き換える
    text.gsub(/&gt;&gt;(\d+)/) do |match|
      "<a href='#reply-#{$1}'>>>#{$1}</a>"
    end
end

class ViewServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(req, res)
        # idがなければホームにリダイレクト
        if !(req.query.include?('id') || req.query['id'] == '')
            res.status = 302
            res['Location'] = '/'
        end

        id = req.query['id']

        # スレッド情報とスレッドへのリプライを取得
        db = DB.new('bbs.db')
        thread = db.fetch_threads_by_id(id)
        replys = db.fetch_replys_by_thread_id(id)
        db.close

        # スレッドが存在しない場合はリダイレクト
        if thread.length == 0
            res.status = 302
            res['Location'] = '/'
        else
            res.status = 200
            res['Content-Type'] = 'text/html'
            res.body = render_template('view', {
                thread: thread[0],
                replys: replys
            })
        end
    end
end