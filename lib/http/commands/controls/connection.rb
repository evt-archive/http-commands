module HTTP
  module Commands
    module Controls
      module Connection
        def self.example(host=nil)
          host ||= Host.example
          ::Connection::Client.build(host, 80)
        end
      end
    end
  end
end
