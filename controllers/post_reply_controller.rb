require 'webrick'
require 'dotenv/load'
require_relative './database/db_connection'
require_relative './helpers/valid_request'

class PostReplyServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_POST(req, res)
        location = '/'

        if valid_request?(req.query, %w[thread_id name content]) # 存在チェック&空白チェック

            # thread_idの型をIntegerに変換
            thread_id = req.query['thread_id']
            begin
                thread_id = Integer(thread_id)
            rescue => e
                puts "Numeric conversion error : #{e.message}"
                thread_id = nil
            end

            # 直接データベースにいれると何故かBLOB型になるので,""で囲んでる(to_sも効かないがこれだと文字列として格納される)
            name = "#{req.query['name']}"
            content = "#{req.query['content']}"

            db = DB.new(ENV['SQLITE3_DATABASE_FILE'])
            # 指定されたthread_idのthreadが存在するか確認
            thread_exist = (db.fetch_threads_by_id(id).length == 0) ? false : true
            if thread_exist
                # 何番目のリプかを取得,計算
                reply_number = db.fetch_max_reply_number(thread_id).to_i + 1
                # threadsテーブルに書き込む
                if db.insert_reply(thread_id, reply_number, name, content)
                    location = "/view?id=#{thread_id}"
                else
                    location = '/error?type=db'
                end
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