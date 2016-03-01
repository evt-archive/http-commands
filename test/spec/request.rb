require_relative './spec_init'

context "Request" do
  host = HTTP::Commands::Controls::Host.example
  resource_target = HTTP::Commands::Controls::ResourceTarget.example
  action = HTTP::Commands::Controls::Action.example

  context "Client connection supports persistent connections" do
    test "Leaving the connection open" do
      expected_request, expected_response = HTTP::Commands::Controls::Dialogs::PersistentConnection.example
      connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

      request = HTTP::Commands::Request.new connection, action, host, resource_target
      request.persistent_connection.persistent = true

      request.()

      assert !request.connection.closed?
    end

    test "Closing the connection when the server closes it" do
      expected_request, expected_response = HTTP::Commands::Controls::Dialogs::ServerClosesConnection.example
      connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

      request = HTTP::Commands::Request.new connection, action, host, resource_target
      request.persistent_connection.persistent = true

      request.()

      assert request.connection.closed?
    end
  end

  context "Client connection does not support persistent connections" do
    test "Connection is not allowed to be reused" do
      expected_request, expected_response = HTTP::Commands::Controls::Dialogs::ClientClosesConnection.example
      connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

      request = HTTP::Commands::Request.new connection, action, host, resource_target
      request.persistent_connection.persistent = false

      request.()

      assert request.connection.closed?
    end
  end
end
