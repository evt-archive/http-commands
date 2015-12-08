require 'webrick'
require 'tmpdir'

require_relative './test_init'

class Server < WEBrick::HTTPServlet::AbstractServlet
  def self.start
    port = ENV['TEST_SERVER_PORT'] || 8000
    server = WEBrick::HTTPServer.new :Port => port.to_i, :DocumentRoot => Dir.tmpdir

    server.mount '/', self

    trap 'INT' do server.shutdown end

    server.start
  end

  def do_GET(request, response)
    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = HTTP::Commands::Controls::Get::Data.text
  end

  def do_POST(request, response)
    response.status = 201

    if request.path == '/upcase'
      response.body = request.body.upcase
    end
  end
end

Server.start
