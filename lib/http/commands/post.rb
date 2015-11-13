module HTTP
  module Commands
    class Post
      attr_reader :body
      attr_reader :uri

      dependency :session
      dependency :logger

      def initialize(body, uri)
        @body = body
        @uri = uri
      end

      def self.build(body, uri)
        uri = URI(uri)
        new(body, uri).tap do |instance|
          Telemetry::Logger.configure instance
        end
      end

      def self.call(body, uri)
        instance = build(body, uri)
        instance.()
      end

      def call
        response = session.post uri, body
        response
      end
    end
  end
end
