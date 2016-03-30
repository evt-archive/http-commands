require_relative '../bench_init'

context "Configure Post" do
  receiver = OpenStruct.new

  context "Default receiver attribute name" do
    HTTP::Commands::Post.configure receiver

    test "Receiver is configured" do
      assert receiver.post.is_a?(HTTP::Commands::Post)
    end
  end

  context "Specialized receiver attribute name" do
    HTTP::Commands::Post.configure receiver, :some_attr

    test "Receiver is configured" do
      assert receiver.some_attr.is_a?(HTTP::Commands::Post)
    end
  end
end
