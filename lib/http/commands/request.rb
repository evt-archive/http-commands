module HTTP
  module Commands
    class Request
      attr_reader :action
      attr_reader :connection
      attr_reader :body
      attr_reader :host
      attr_reader :target

      dependency :logger, Telemetry::Logger

      def initialize(connection, action, host, target, body=nil)
        @action = action
        @body = body
        @host = host
        @connection = connection
        @target = target
      end

      def self.build(*arguments)
        instance = new *arguments
        Telemetry::Logger.configure instance
        instance
      end

      def call
        send_request
        response, body = receive_response
        Response.new response, body
      end

      def send_request
        request = HTTP::Protocol::Request.new action, target
        request['Host'] = host
        request['Content-Length'] = length

        logger.trace "Send Request (Resource: #{target.inspect}, Size: #{length})"
        logger.data request
        logger.data body if body

        connection.write request
        connection.write body if body

        logger.debug "Sent Request (Resource: #{target.inspect}, Size: #{length})"
      end

      def receive_response
        logger.trace "Receiving Response (Resource: #{target.inspect})"

        response_builder = HTTP::Protocol::Response::Builder.build
        response_builder << connection.readline until response_builder.finished_headers?

        response = response_builder.message

        content_length = response['Content-Length'].to_i

        logger.debug "Received Response (Status: #{response.status_code}, Length: #{content_length.inspect}, Resource: #{target.inspect})"
        unless content_length.zero?
          body = connection.read content_length
        end
        logger.data response

        return response, body
      end

      def length
        return unless body
        body.bytesize
      end
    end
  end
end
