require_relative './spec_init'

describe 'Get' do
  host = HTTP::Commands::Controls::Messages::Requests.host
  resource_target = HTTP::Commands::Controls::Messages::Requests.resource_target

  specify do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get.example

    get = HTTP::Commands::Get.new host, resource_target, {}
    get.connection.expect_write expected_request
    get.connection.expect_read expected_response

    response = get.()

    assert response.status_code == 200
    assert response.body == 'some-message'
  end

  specify 'Supplying Headers' do
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get::JSON.example
    headers = { 'Accept' => 'application/json' }

    get = HTTP::Commands::Get.new host, resource_target, headers
    get.connection.expect_write expected_request
    get.connection.expect_read expected_response

    response = get.()

    assert response.status_code == 200
    assert JSON.parse(response.body)['some-key'] == 'some-value'
  end
end
