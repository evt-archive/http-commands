module HTTP
  module Commands
    module Controls
      module Connection
        def self.example
          host = Host.example
          port = Port.example
          ::Connection::Client.build(host, port)
        end
      end
    end
  end
end
