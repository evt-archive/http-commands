require_relative './spec_init'

context "Persistent connection" do
  persistent_connection = HTTP::Commands::PersistentConnection.new

  test "Connections that reconnect when closed are able to be persistent" do
    connection = HTTP::Commands::Controls::Connection::Persistent.example

    persistent = persistent_connection.(connection)

    assert persistent
  end

  test "Connections that never reconnect are not able to be persistent" do
    connection = HTTP::Commands::Controls::Connection::NotPersistent.example

    persistent = persistent_connection.(connection)

    assert !persistent
  end

  test "Connections that have no reconnect policy are not able to be persistent" do
    connection = StringIO.new

    persistent = persistent_connection.(connection)

    assert !persistent
  end
end
