require_relative './spec_init'

describe 'Request' do
  specify 'Leaving the Connection Open' do
    connection, response_body, uri = HTTP::Commands::Controls::Connections.get
    request = HTTP::Commands::Request.build(
      connection,
      'GET',
      'www.example.com',
      '/some-path'
    )

    request.()

    refute connection.closed?
  end

  specify "Closing the Connection at Server's Request" do
    connection, response_body, uri = HTTP::Commands::Controls::Connections.get('Connection' => 'close')
    request = HTTP::Commands::Request.build(
      connection,
      'GET',
      'www.example.com',
      '/some-path'
    )

    request.()

    assert connection.closed?
  end
end
