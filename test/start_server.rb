require 'webrick'
require 'tmpdir'

class Server < WEBrick::HTTPServlet::AbstractServlet
  def self.start
    server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => Dir.tmpdir

    server.mount '/', self

    trap 'INT' do server.shutdown end

    server.start
  end

  def do_GET(request, response)
    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = "OK\n"
  end

  def do_POST(request, response)
    response.status = 201
  end
end

Server.start
