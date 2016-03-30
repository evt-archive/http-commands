require_relative '../bench_init'

context "Request Connection Lifecycle" do
  action = HTTP::Commands::Controls::Action.example
  uri = HTTP::Commands::Controls::URI.example

  context "Shared connection" do
    connection = HTTP::Commands::Controls::Connection.example

    test "Is established prior to building the request" do
      request = HTTP::Commands::Request.build(action, uri, connection: connection)
      assert request.connection == connection
    end
  end

  context "Exclusive connection" do
    request = HTTP::Commands::Request.build(action, uri)

    test "A connection is established" do
      assert request.connection
    end

    test "The 'Connection' request header is set to 'close'" do
      assert request.headers['Connection'] == 'close'
    end
  end

  context "'Connection' response header is not set to 'close'" do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::PersistentConnection.example
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    request = HTTP::Commands::Request.new connection, action, uri

    request.()

    test "Client connection remains open" do
      assert !request.connection.closed?
    end
  end

  context "'Connection' response header is set to 'close'" do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::ServerClosesConnection.example
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    request = HTTP::Commands::Request.new connection, action, uri

    request.()

    test "Closes the client connection" do
      assert request.connection.closed?
    end
  end
end
