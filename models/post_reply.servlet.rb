require 'webrick'
require_relative 'render_template'
require_relative 'db'
require_relative 'valid_request'

class PostReplyServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_POST(req, res)
        location = '/'

        if valid_request?(req.query, %w[thread_id name content]) # 存在チェック&空白チェック
            # 直接データベースにいれると何故かBLOB型になるので,""で囲んでる(to_sも効かないがこれだと文字列として格納される)
            thread_id = req.query['thread_id'].to_i
            name = "#{req.query['name']}"
            content = "#{req.query['content']}"

            # threadsテーブルに書き込む
            db = DB.new('bbs.db')
            # 何番目のリプかを取得,計算
            reply_number = db.fetch_max_reply_number(thread_id).to_i + 1
            if db.insert_reply(thread_id, reply_number, name, content)
                location = "/view?id=#{thread_id}"
            else
                location = '/error?type=db'
            end
            db.close
        else
            location = '/error?type=empty' # 空白などがあった場合はエラーページにリダイレクト
        end

        # 処理が終わったらリダイレクト
        res.status = 302
        res['Location'] = location
    end
end