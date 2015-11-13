module HTTP
  module Commands
    class Post
      attr_reader :body
      attr_reader :origin

      dependency :connection, Connection::Client
      dependency :logger

      def initialize(body, origin)
        @body = body
        @origin = origin
      end

      def self.build(body, uri, connection: nil)
        uri = URI(uri)

        origin = uri.request_uri

        new(body, origin).tap do |instance|
          Telemetry::Logger.configure instance

          unless connection
            Connect.configure_connection instance, uri
          else
            instance.connection = connection
          end
        end
      end

      def self.call(body, uri, connection: nil)
        instance = build(body, uri, connection: connection)
        instance.()
      end

      def call
        response = OpenStruct.new
        response.status_code = 200
        response
      end
    end
  end
end
