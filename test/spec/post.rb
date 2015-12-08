require_relative './spec_init'

describe 'Post' do
  specify 'Without Response Body' do
    connection, data, uri = HTTP::Commands::Controls::Connections.post

    response = HTTP::Commands::Post.(data, uri, connection: connection)

    assert connection.verify_request
    assert response.status_code == 201
    refute response.body
  end

  specify 'With Response Body' do
    response_body = 'some-response'
    connection, data, uri = HTTP::Commands::Controls::Connections.post response_body

    response = HTTP::Commands::Post.(data, uri, connection: connection)

    assert connection.verify_request
    assert response.status_code == 201
    assert response.body == response_body
  end
end
