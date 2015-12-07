require 'webrick'
require 'tmpdir'

class Server < WEBrick::HTTPServlet::AbstractServlet
  def self.start
    port = ENV['TEST_SERVER_PORT'] || 8000
    server = WEBrick::HTTPServer.new :Port => port.to_i, :DocumentRoot => Dir.tmpdir

    server.mount '/some-resource', self

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
    response.body = request.body.upcase
  end
end

Server.start
