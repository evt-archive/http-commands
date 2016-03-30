require_relative '../bench_init'

context 'Post' do
  uri = HTTP::Commands::Controls::URI.example

  test 'Without Response Body' do
    request_body = HTTP::Commands::Controls::Messages::Resources.example
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Post.example request_body
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    response = HTTP::Commands::Post.(request_body, uri, :connection => connection)

    assert response.status_code == 201
    assert response.body.nil?
  end

  test 'With Response Body' do
    request_body = 'some-request'
    response_body = 'some-response'
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Post.example request_body, response_body
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    response = HTTP::Commands::Post.(request_body, uri, :connection => connection)

    assert response.status_code == 201
    assert response.body == response_body
  end

  test 'Supplying Headers' do
    headers = { 'Content-Type' => 'application/json' }

    resource = HTTP::Commands::Controls::Messages::Resources.json
    request_body = JSON.pretty_generate resource
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Post::JSON.example resource
    connection = HTTP::Commands::Controls::Dialogs::Connection.example expected_request, expected_response

    response = HTTP::Commands::Post.(request_body, uri, headers, :connection => connection)

    assert response.status_code == 201
    assert response.body.nil?
  end
end
