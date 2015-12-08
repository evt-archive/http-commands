require_relative './spec_init'

describe 'Get' do
  specify do
    connection, uri = HTTP::Commands::Controls::Connections.get
    response = HTTP::Commands::Get.(uri, connection: connection)

    assert connection.verify_request
    assert response.status_code == 200
    assert response.body == 'some-text'
  end
end
