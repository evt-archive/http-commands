require_relative '../bench_init'

context "Configure Get" do
  receiver = OpenStruct.new

  context "Default receiver attribute name" do
    HTTP::Commands::Get.configure receiver

    test "Receiver is configured" do
      assert receiver.get.is_a?(HTTP::Commands::Get)
    end
  end

  context "Specialized receiver attribute name" do
    HTTP::Commands::Get.configure receiver, :some_attr

    test "Receiver is configured" do
      assert receiver.some_attr.is_a?(HTTP::Commands::Get)
    end
  end
end
