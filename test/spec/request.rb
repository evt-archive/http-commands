require_relative './spec_init'

describe 'Request' do
  host = HTTP::Commands::Controls::Messages::Requests.host
  resource_target = HTTP::Commands::Controls::Messages::Requests.resource_target

  specify 'Leaving the Connection Open' do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get.example

    get = HTTP::Commands::Get.new host, resource_target, {}
    get.connection.expect_write expected_request
    get.connection.expect_read expected_response

    get.()

    refute get.connection.closed?
  end

  specify "Closing the Connection at Server's Request" do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get.connection_closed

    get = HTTP::Commands::Get.new host, resource_target, {}
    get.connection.expect_write expected_request
    get.connection.expect_read expected_response

    get.()

    assert get.connection.closed?
  end
end
