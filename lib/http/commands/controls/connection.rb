module HTTP
  module Commands
    module Controls
      module Connection
        def self.example
          host = Host.example
          port = Port.example

          raw = ::Connection::Client.build(host, port)
          raw.extend HTTP::Commands::Connection
          raw
        end
      end
    end
  end
end
