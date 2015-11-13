module HTTP
  module Commands
    class Connect
      attr_reader :host
      attr_reader :port
      attr_reader :ssl

      def initialize(host, port, ssl)
        @host = host
        @port = port
        @ssl = ssl
      end

      def self.build(uri)
        host = uri.host
        port = uri.port
        ssl = (uri.scheme == 'https')

        new(host, port, ssl)
      end

      def self.configure_connection(receiver, uri)
        instance = build(uri)
        connection = instance.connect
        receiver.connection = connection
        connection
      end

      def connect
        TCPSocket.new(host, port)
      end
    end
  end
end
