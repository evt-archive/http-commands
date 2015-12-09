module HTTP
  module Commands
    class Connect
      attr_reader :host
      attr_reader :port
      attr_reader :ssl_context

      def initialize(host, port, ssl_context)
        @host = host
        @port = port
        @ssl_context = ssl_context
      end

      def self.build(uri, verify_certs: nil)
        verify_certs = true if verify_certs.nil?

        host = uri.host
        port = uri.port

        if uri.scheme == 'https'
          ssl_context = self.ssl_context verify_certs
        end

        new(host, port, ssl_context)
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def self.configure_connection(receiver, uri)
        instance = self.build uri
        connection = instance.connect
        receiver.connection = connection
        connection
      end

      def self.ssl_context(verify_certs)
        ssl_context = OpenSSL::SSL::SSLContext.new

        if verify_certs
          ssl_context.set_params verify_mode: OpenSSL::SSL::VERIFY_PEER
        else
          ssl_context.set_params verify_mode: OpenSSL::SSL::VERIFY_NONE
        end

        ssl_context
      end

      def connect(scheduler=nil)
        connection = PersistentConnection.build(host, port, ssl_context)
        connection.scheduler = scheduler if scheduler
        connection
      end
    end
  end
end
