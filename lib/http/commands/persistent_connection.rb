module HTTP
  module Commands
    class PersistentConnection
      attr_writer :connection
      attr_reader :host
      attr_reader :port
      attr_accessor :scheduler
      attr_reader :ssl_context

      dependency :logger, Telemetry::Logger

      def initialize(host, port, ssl_context=nil)
        @host = host
        @port = port
        @ssl_context = ssl_context
      end

      def self.build(*arguments)
        instance = new *arguments
        Telemetry::Logger.configure instance
        instance
      end

      def close
        connection.close
        self.connection = nil
      end

      def closed?
        connection.closed?
      end

      def connection
        @connection ||= Connection.client(
          host,
          port,
          scheduler: scheduler,
          ssl: ssl_context
        )
      end

      def read(*arguments)
        connection.read *arguments
      end

      def readline(*arguments)
        connection.readline *arguments
      end

      def write(*arguments)
        connection.write *arguments
      end
    end
  end
end
