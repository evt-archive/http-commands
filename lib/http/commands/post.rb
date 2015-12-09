module HTTP
  module Commands
    class Post
      attr_reader :body
      attr_reader :headers
      attr_reader :host
      attr_reader :resource_target

      dependency :connection, Connection::Client
      dependency :logger

      def initialize(body, host, resource_target, headers)
        @body = body
        @headers = headers
        @host = host
        @resource_target = resource_target
      end

      def self.build(body, uri, headers={}, connection: nil)
        uri = URI(uri)

        resource_target = uri.request_uri
        host = uri.host

        new(body, host, resource_target, headers).tap do |instance|
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
          'POST',
          host,
          resource_target,
          body: body,
          headers: headers
        )
        request.()
      end

      def length
        body.bytesize
      end
    end
  end
end
