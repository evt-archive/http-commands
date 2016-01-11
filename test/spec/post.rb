require_relative './spec_init'

describe 'Post' do
  host = HTTP::Commands::Controls::Messages::Requests.host
  resource_target = HTTP::Commands::Controls::Messages::Requests.resource_target

  specify 'Without Response Body' do
    request_body = HTTP::Commands::Controls::Messages::Resources.example
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Post.example request_body

    post = HTTP::Commands::Post.new request_body, host, resource_target, {}
    post.connection.expect_write expected_request
    post.connection.expect_read expected_response

    response = post.()

    assert response.status_code == 201
    assert response.body.nil?
  end

  specify 'With Response Body' do
    request_body = 'some-request'
    response_body = 'some-response'

    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Post.example request_body, response_body

    post = HTTP::Commands::Post.new request_body, host, resource_target, {}
    post.connection.expect_write expected_request
    post.connection.expect_read expected_response

    response = post.()

    assert response.status_code == 201
    assert response.body == response_body
  end

  specify 'Supplying Headers' do
    headers = { 'Content-Type' => 'application/json' }

    resource = HTTP::Commands::Controls::Messages::Resources.json
    request_body = JSON.pretty_generate resource
    expected_request, expected_response = HTTP::Commands::Controls::Dialogs::Post::JSON.example resource

    post = HTTP::Commands::Post.new request_body, host, resource_target, headers
    post.connection.expect_write expected_request
    post.connection.expect_read expected_response

    response = post.()

    assert response.status_code == 201
    assert response.body.nil?
  end
end
