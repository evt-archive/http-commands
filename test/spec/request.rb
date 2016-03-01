require_relative './spec_init'

context "Request" do
  host = HTTP::Commands::Controls::Host.example
  resource_target = HTTP::Commands::Controls::ResourceTarget.example
  action = HTTP::Commands::Controls::Action.example

  test "Leaving the connection open" do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::PersistentConnection.example
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    request = HTTP::Commands::Request.new connection, action, host, resource_target

    request.()

    assert !request.connection.closed?
  end

  test "Closing the connection when the server closes it" do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::ServerClosesConnection.example
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    request = HTTP::Commands::Request.new connection, action, host, resource_target

    request.()

    assert request.connection.closed?
  end
end
