require 'ostruct'

require_relative 'spec_init'

describe "Post" do
  specify do
    data = HTTP::Commands::Controls::Post::Data.text
    uri = HTTP::Commands::Controls::URI.example

    # connection = Connection::Client.build host, port
    # response = HTTP::Commands::Post.(data, uri, connection: connection)

    response = HTTP::Commands::Post.(data, uri)

    assert(response.status_code == 200)
  end
end
