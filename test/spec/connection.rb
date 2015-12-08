require_relative './spec_init'

describe 'Connection' do
  specify 'Non SSL' do
    HTTP::Commands::Controls::Server.run do |port, scheduler|
      uri = URI::HTTP.build(
        :host => 'localhost',
        :path => '/some-resource',
        :port => port
      )

      command = HTTP::Commands::Connect.build uri
      connection = command.connect scheduler

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

      command = HTTP::Commands::Connect.build uri, verify_certs: false
      connection = command.connect scheduler

      response = HTTP::Commands::Get.(uri, connection: connection)

      assert response.status_code == 200
      assert response.body == 'some-text'
    end
  end
end
