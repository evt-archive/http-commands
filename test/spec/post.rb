require 'ostruct'

require_relative './spec_init'

describe "Post" do
  specify do
    data = HTTP::Commands::Controls::Post::Data.text
    uri = HTTP::Commands::Controls::URI.example

    response = HTTP::Commands::Post.(data, uri)

    assert response.status_code == 201
    assert response.body == data.upcase
  end
end
