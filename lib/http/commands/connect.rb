module HTTP
  module Commands
    class Connect
      attr_reader :host
      attr_reader :port
      attr_reader :ssl_context

      dependency :logger, Telemetry::Logger

      def initialize(host, port, ssl_context=nil)
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

        instance = new(host, port, ssl_context)

        Telemetry::Logger.configure instance

        instance
      end

      def self.configure(receiver, attr_name=nil)
        attr_name ||= :connect

        instance = build
        receiver.public_send "#{attr_name}=", instance
        instance
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def call
        logger.opt_trace "Establishing connection (Host: #{host}, Port: #{port}, SSL: #{!!ssl_context})"

        connection = Connection::Client.build(
          host,
          port,
          ssl: ssl_context
        )

        logger.opt_debug "Established connection (Host: #{host}, Port: #{port}, SSL: #{!!ssl_context})"

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
    end
  end
end
