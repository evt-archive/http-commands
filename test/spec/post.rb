require 'ostruct'

require_relative './spec_init'

describe 'Post' do
  specify 'Without Response Body' do
    data = HTTP::Commands::Controls::Post::Data.text
    uri = HTTP::Commands::Controls::URI.example

    response = HTTP::Commands::Post.(data, uri)

    assert response.status_code == 201
    refute response.body
  end

  specify 'With Response Body' do
    data = HTTP::Commands::Controls::Post::Data.text
    uri = HTTP::Commands::Controls::URI.example '/upcase'

    response = HTTP::Commands::Post.(data, uri)

    assert response.status_code == 201
    assert response.body == data.upcase
  end
end
