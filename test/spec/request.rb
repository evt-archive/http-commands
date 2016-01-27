require_relative './spec_init'

context 'Request' do
  host = HTTP::Commands::Controls::Messages::Requests.host
  resource_target = HTTP::Commands::Controls::Messages::Requests.resource_target

  test 'Leaving the Connection Open' do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get.example

    get = HTTP::Commands::Get.new host, resource_target, {}
    get.connection.expect_write expected_request
    get.connection.expect_read expected_response

    get.()

    assert !get.connection.closed?
  end

  test "Closing the Connection at Server's Request" do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get.connection_closed

    get = HTTP::Commands::Get.new host, resource_target, {}
    get.connection.expect_write expected_request
    get.connection.expect_read expected_response

    get.()

    assert get.connection.closed?
  end
end
