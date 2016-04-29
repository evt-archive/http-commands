require_relative '../bench_init'

context "Request Connection Lifecycle" do
  action = HTTP::Commands::Controls::Action.example
  uri = HTTP::Commands::Controls::URI.example
  control_time = HTTP::Commands::Controls::Time.example

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

  context "Timeout has been set by previous response" do
    context "Is not exceeded" do
      expected_request, expected_response = HTTP::Commands::Controls::Dialogs::PersistentConnection.example
      connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response
      connection.http_timeout = HTTP::Commands::Controls::Timeout::Within.example

      request = HTTP::Commands::Request.new(connection, action, uri)
      request.clock.now = HTTP::Commands::Controls::Timeout::Within.example

      request.()

      test "A new connection is established" do
        refute connection do
          closed?
        end
      end
    end

    context "Is exceeded" do
      expected_request, expected_response = HTTP::Commands::Controls::Dialogs::PersistentConnection.example
      connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response
      connection.http_timeout = HTTP::Commands::Controls::Timeout::Within.example

      request = HTTP::Commands::Request.new(connection, action, uri)
      request.clock.now = HTTP::Commands::Controls::Timeout::Exceeds.example

      request.()

      test "A new connection is established" do
        assert connection do
          closed?
        end
      end
    end
  end

  context "'Keep-Alive' response header is set" do
    context "timeout is supplied" do
      expected_request, expected_response = HTTP::Commands::Controls::Dialogs::PersistentConnection.example
      connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

      request = HTTP::Commands::Request.new connection, action, uri
      request.clock.now = HTTP::Commands::Controls::Time.example

      request.()

      test "Timeout is set on connection" do
        control_time = HTTP::Commands::Controls::Timeout::Time.example

        assert request.connection.http_timeout == control_time
      end
    end
  end

  context "'Connection' response header is not set to 'close'" do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::PersistentConnection.example
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    request = HTTP::Commands::Request.new connection, action, uri
    request.clock.now = control_time

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
