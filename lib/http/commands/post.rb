module HTTP
  module Commands
    class Post
      attr_accessor :connection

      dependency :logger, Telemetry::Logger

      def self.build(connection=nil)
        new.tap do |instance|
          Telemetry::Logger.configure instance

          instance.connection = connection if connection
        end
      end

      def self.call(body, uri, headers=nil, connection: nil)
        instance = build connection
        instance.(body, uri, headers)
      end

      def call(body, uri, headers=nil)
        headers ||= {}

        uri = URI(uri)
        connection = self.connection || Connect.(uri)

        resource_target = uri.request_uri
        host = uri.host

        Request.(
          connection,
          'POST',
          host,
          resource_target,
          body: body,
          headers: headers
        )
      end
    end
  end
end
