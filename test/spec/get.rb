require_relative './spec_init'

context 'Get' do
  uri = HTTP::Commands::Controls::Messages::Requests.uri

  test do
    resource = HTTP::Commands::Controls::Messages::Resources.text
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get.example resource
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    get = HTTP::Commands::Get.new
    get.connection = connection

    response = get.(uri)

    assert response.status_code == 200
    assert response.body == resource
  end

  test 'Supplying Headers' do
    resource = HTTP::Commands::Controls::Messages::Resources.json
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get::JSON.example resource
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    get = HTTP::Commands::Get.new
    get.connection = connection

    response = get.(uri, 'Accept' => 'application/json')

    assert response.status_code == 200
    assert JSON.parse(response.body) == resource
  end
end
