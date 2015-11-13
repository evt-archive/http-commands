require_relative 'spec_init'

describe "Post" do
  specify do
    data = HTTP::Commands::Controls::Post::Data.text
    uri = HTTP::Commands::Controls::URI.example

    response = HTTP::Commands::Post.(data, uri)
  end
end
