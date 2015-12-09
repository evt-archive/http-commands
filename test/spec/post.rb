require_relative './spec_init'

describe 'Post' do
  specify 'Without Response Body' do
    connection, request_body, uri = HTTP::Commands::Controls::Connections.post

    response = HTTP::Commands::Post.(request_body, uri, connection: connection)

    assert connection.verify_request
    assert response.status_code == 201
    refute response.body
  end

  specify 'With Response Body' do
    response_body = 'some-response'
    connection, request_body, uri = HTTP::Commands::Controls::Connections.post response_body

    response = HTTP::Commands::Post.(request_body, uri, connection: connection)

    assert connection.verify_request
    assert response.status_code == 201
    assert response.body == response_body
  end

  specify 'Supplying Headers' do
    connection, request_body, uri = HTTP::Commands::Controls::Connections.post_json

    response = HTTP::Commands::Post.(
      request_body,
      uri,
      'Content-Type' => 'application/json',
      connection: connection
    )

    assert connection.verify_request
    assert response.status_code == 201
    refute response.body
  end
end
