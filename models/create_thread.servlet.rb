require 'webrick'
require_relative 'render_template'
require_relative 'db'
require_relative 'valid_request'

class CreateThreadServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_POST(req, res)
        location = '/'

        if valid_request?(req.query, %w[name title content]) # 存在チェック&空白チェック
            # 直接データベースにいれると何故かBLOB型になるので,""で囲んでる(to_sも効かないがこれだと文字列として格納される)
            name = "#{req.query['name']}"
            title = "#{req.query['title']}"
            content = "#{req.query['content']}"

            # threadsテーブルに書き込む
            db = DB.new('bbs.db')
            if db.insert_thread(name, title, content)
                # Todo: あとでここに作成したスレッドにリダイレクトするようにLocationを変更するプログラムを追加する
                puts 'success'
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