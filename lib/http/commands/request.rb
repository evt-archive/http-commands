module HTTP
  module Commands
    class Request
      attr_reader :action
      attr_reader :connection
      attr_reader :body
      attr_reader :host
      attr_reader :target

      dependency :logger, Telemetry::Logger

      def initialize(connection, action, host, target, body, headers)
        @action = action
        @body = body
        @headers = headers
        @host = host
        @connection = connection
        @target = target
      end

      def self.build(connection, action, host, target, body: nil, headers: nil)
        instance = new connection, action, host, target, body, headers
        Telemetry::Logger.configure instance
        instance
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def call
        send_request
        response, body = receive_response
        connection.close if response['Connection'] == 'close'
        Response.new response, body
      end

      def headers
        @headers ||= {}
      end

      def send_request
        request = HTTP::Protocol::Request.new action, target
        request['Host'] = host
        request['Content-Length'] = request_message_length

        headers.each do |field_name, field_value|
          request[field_name] = field_value
        end

        logger.opt_trace "Send Request (Resource: #{target.inspect}, Message Length: #{request_message_length.inspect})"
        logger.opt_data request
        logger.opt_data body if body

        connection.write request
        connection.write body if body

        logger.opt_debug "Sent Request (Resource: #{target.inspect}, Message Length: #{request_message_length.inspect})"
      end

      def receive_response
        logger.opt_trace "Receiving Response (Resource: #{target.inspect})"

        response_builder = HTTP::Protocol::Response::Builder.build
        response_builder << connection.readline until response_builder.finished_headers?

        response = response_builder.message

        content_length = response['Content-Length'].to_i

        logger.opt_debug "Received Response (Status: #{response.status_code}, Content Length: #{content_length.inspect}, Resource: #{target.inspect})"
        unless content_length.zero?
          body = connection.read content_length
        end
        logger.opt_data response

        return response, body
      end

      def request_message_length
        return unless body
        Commands.content_length(body)
      end
    end
  end
end
