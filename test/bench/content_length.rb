require_relative './bench_init'

context "Content Length" do
  test "Is the count of bytes in a string representation of the content" do
    content = HTTP::Commands::Controls::Messages::Resources::Multibyte.example
    control_length = HTTP::Commands::Controls::Messages::Resources::Multibyte.length

    length = HTTP::Commands.content_length(content)

    assert(length == control_length)
  end
end
