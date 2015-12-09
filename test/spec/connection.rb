require_relative './spec_init'

describe 'Connection' do
  specify 'Non SSL' do
    HTTP::Commands::Controls::Server.run do |port, scheduler|
      uri = URI::HTTP.build(
        :host => 'localhost',
        :path => '/some-resource',
        :port => port
      )

      connection = HTTP::Commands::Connect.(uri, scheduler: scheduler)

      response = HTTP::Commands::Get.(uri, connection: connection)

      assert response.status_code == 200
      assert response.body == 'some-text'
    end
  end

  specify 'SSL' do
    HTTP::Commands::Controls::Server.run ssl: true do |port, scheduler|
      uri = URI::HTTPS.build(
        :host => 'localhost',
        :path => '/some-resource',
        :port => port
      )

      connection = HTTP::Commands::Connect.(
        uri,
        scheduler: scheduler,
        verify_certs: false
      )

      response = HTTP::Commands::Get.(uri, connection: connection)

      assert response.status_code == 200
      assert response.body == 'some-text'
    end
  end

  specify 'Establishing Connection Internally' do
    response = HTTP::Commands::Get.("https://www.google.com")
    assert response.status_code == 200
  end
end
