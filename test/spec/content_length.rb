require_relative './spec_init'

describe "Content Length" do
  specify "Is the count of bytes in a string representation of the content" do
    content = HTTP::Commands::Controls::Messages::Resources::Multibyte.example
    control_length = HTTP::Commands::Controls::Messages::Resources::Multibyte.length

    length = HTTP::Commands.content_length(content)

    assert(length == control_length)
  end
end
