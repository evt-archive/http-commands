module HTTP
  module Commands
    class Post
      attr_reader :body
      attr_reader :host
      attr_reader :resource_target

      dependency :connection, Connection::Client
      dependency :logger

      def initialize(body, host, resource_target)
        @body = body
        @host = host
        @resource_target = resource_target
      end

      def self.build(body, uri, connection: nil)
        uri = URI(uri)

        resource_target = uri.request_uri
        host = uri.host

        new(body, host, resource_target).tap do |instance|
          Telemetry::Logger.configure instance

          if connection
            instance.connection = connection
          else
            Connect.configure_connection instance, uri
          end
        end
      end

      def self.call(body, uri, connection: nil)
        instance = build(body, uri, connection: connection)
        instance.()
      end

      def call
        request = Request.build connection, 'POST', host, resource_target, body
        request.()
      end

      def length
        body.bytesize
      end
    end
  end
end
