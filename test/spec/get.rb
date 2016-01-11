require_relative './spec_init'

describe 'Get' do
  host = HTTP::Commands::Controls::Messages::Requests.host
  resource_target = HTTP::Commands::Controls::Messages::Requests.resource_target

  specify do
    resource = HTTP::Commands::Controls::Messages::Resources.text
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get.example resource

    get = HTTP::Commands::Get.new host, resource_target, {}
    get.connection.expect_write expected_request
    get.connection.expect_read expected_response

    response = get.()

    assert response.status_code == 200
    assert response.body == resource
  end

  specify 'Supplying Headers' do
    resource = HTTP::Commands::Controls::Messages::Resources.json
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get::JSON.example resource
    headers = { 'Accept' => 'application/json' }

    get = HTTP::Commands::Get.new host, resource_target, headers
    get.connection.expect_write expected_request
    get.connection.expect_read expected_response

    response = get.()

    assert response.status_code == 200
    assert JSON.parse(response.body) == resource
  end
end
