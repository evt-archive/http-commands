module HTTP
  module Commands
    class Get
      attr_reader :headers
      attr_reader :host
      attr_reader :resource_target

      dependency :connection, Connection::Client
      dependency :logger

      def initialize(host, resource_target, headers)
        @headers = headers
        @host = host
        @resource_target = resource_target
      end

      def self.build(uri, headers={}, connection: nil)
        uri = URI(uri)

        resource_target = uri.request_uri
        host = uri.host

        new(host, resource_target, headers).tap do |instance|
          Telemetry::Logger.configure instance

          if connection
            instance.connection = connection
          else
            Connect.configure_connection instance, uri
          end
        end
      end

      def self.call(*arguments)
        instance = build(*arguments)
        instance.()
      end

      def call
        request = Request.build(
          connection,
          'GET',
          host,
          resource_target,
          headers: headers
        )
        request.()
      end
    end
  end
end
