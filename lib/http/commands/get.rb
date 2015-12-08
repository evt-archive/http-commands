module HTTP
  module Commands
    class Get
      attr_reader :host
      attr_reader :resource_target

      dependency :connection, Connection::Client
      dependency :logger

      def initialize(host, resource_target)
        @host = host
        @resource_target = resource_target
      end

      def self.build(uri, connection: nil)
        uri = URI(uri)

        resource_target = uri.request_uri
        host = uri.host

        new(host, resource_target).tap do |instance|
          Telemetry::Logger.configure instance

          if connection
            instance.connection = connection
          else
            Connect.configure_connection instance, uri
          end
        end
      end

      def self.call(uri, connection: nil)
        instance = build(uri, connection: connection)
        instance.()
      end

      def call
        request = Request.build connection, 'GET', host, resource_target
        request.()
      end
    end
  end
end
