require 'webrick'
require_relative './helpers/render'
require_relative './helpers/valid_request'

class ErrorServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(req, res)
        if valid_request?(req.query, %w[type])
            type = req.query['type']
            if type == 'empty' || type == 'db'
                res.status = 200
                res['Content-Type'] = 'text/html'
                res.body = render('error', {
                    type: type,
                    error_message: {
                        'empty' => '空白の値が入っています',
                        'db' =>  'データベースエラー,書き込みに失敗しました'
                        }
                    })
            else
                res.status = 302
                res['Location'] = '/'
            end
        else
            res.status = 302
            res['Location'] = '/'
        end
    end
end