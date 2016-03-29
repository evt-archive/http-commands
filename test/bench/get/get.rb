require_relative '../bench_init'

context "Get" do
  uri = HTTP::Commands::Controls::Messages::Requests.uri

  get = HTTP::Commands::Get.build

  test "Get a request target" do
    resource = HTTP::Commands::Controls::Messages::Resources.text
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get.example resource

    get.connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    response = get.(uri)

    assert response.status_code == 200
    assert response.body == resource
  end

  test "Supplying Headers" do
    resource = HTTP::Commands::Controls::Messages::Resources.json
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Get::JSON.example resource

    get.connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    response = get.(uri, 'Accept' => 'application/json', :connection => connection)

    assert response.status_code == 200
    assert JSON.parse(response.body) == resource
  end

  context "One-time connection" do
    get = HTTP::Commands::Get.build

    test "Get command isn't created with a connection" do
      assert get.connnection.nil?
    end

    context "Execute the command" do
      response, connection = get.('http://www.example.com')

      test "Connection is created" do
        assert connection
      end

      test "Connection gets closed" do
        assert connection.closed?
      end

      test "Remote closes the connection" do
        assert response['Connection'] == 'close'
      end
    end
  end
end
