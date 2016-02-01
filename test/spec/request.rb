require_relative './spec_init'

context 'Request' do
  uri = HTTP::Commands::Controls::Messages::Requests.uri

  test 'Leaving the Connection Open' do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get.example
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    get = HTTP::Commands::Get.new
    get.connection = connection

    get.(uri)

    assert !get.connection.closed?
  end

  test "Closing the Connection at Server's Request" do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get.connection_closed
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    get = HTTP::Commands::Get.new
    get.connection = connection

    get.(uri)

    assert get.connection.closed?
  end
end
