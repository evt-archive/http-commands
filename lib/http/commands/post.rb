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
        request = HTTP::Protocol::Request.new 'POST', resource_target
        request['Host'] = host
        request['Content-Length'] = length

        logger.trace "Writing Request (Size: #{length})"
        logger.data request
        logger.data body

        connection.write request
        connection.write body

        logger.debug "Wrote Request (Size: #{length})"

        logger.trace 'Reading Response'
        response_builder = HTTP::Protocol::Response::Builder.build
        response_builder << connection.readline until response_builder.finished_headers?

        response = response_builder.message
        content_length = response['Content-Length'].to_i

        logger.debug "Read Response (Status: #{response.status_code}, Length: #{content_length.inspect})"
        unless content_length.zero?
          body = connection.read content_length
        end
        logger.data response

        Response.new response, body
      end

      def length
        body.bytesize
      end

      class Response
        attr_reader :body
        attr_reader :response

        def initialize(response, body)
          @body = body
          @response = response
        end

        def method_missing(method_name, *arguments, &block)
          response.public_send method_name, *arguments, &block
        end

        def respond_to?(method_name)
          super || response.respond_to?(method_name)
        end
      end
    end
  end
end
