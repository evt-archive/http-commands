require_relative './spec_init'

describe 'Get' do
  specify do
    expected_body = HTTP::Commands::Controls::Get::Data.text
    uri = HTTP::Commands::Controls::URI.example

    response = HTTP::Commands::Get.(uri)

    assert response.status_code == 200
    assert response.body == expected_body
  end
end
