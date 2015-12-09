require_relative './spec_init'

describe 'Get' do
  specify do
    connection, response_body, uri = HTTP::Commands::Controls::Connections.get
    response = HTTP::Commands::Get.(uri, connection: connection)

    assert connection.verify_request
    assert response.status_code == 200
    assert response.body == response_body
  end

  specify 'Supplying Headers' do
    connection, response_body, uri = HTTP::Commands::Controls::Connections.get_json
    response = HTTP::Commands::Get.(
      uri,
      'Accept' => 'application/json',
      connection: connection
    )

    assert connection.verify_request
    assert response.status_code == 200
    assert response.body == response_body
  end
end
