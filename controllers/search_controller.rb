require 'webrick'
require_relative './database/db_connection'
require_relative './helpers/escape_html'
require_relative './helpers/render_template'
require_relative './helpers/valid_request'

class SearchServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(req, res)
        # qの存在&空白チェック
        if valid_request?(req.query, %w[q])
            db = DB.new('bbs.db')
            q = req.query['q']
            threads = db.fetch_threads_by_title(q)
            threads_length = threads.length
            db.close

            res.status = 200
            res['Content-Type'] = 'text/html'
            res.body = render_template('search', {
                q: q,
                threads: threads,
                threads_length: threads_length
            })
        else
            res.status = 302
            res['Location'] = '/'
        end
    end
end