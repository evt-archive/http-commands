module HTTP
  module Commands
    class Request
      attr_reader :connection
      attr_reader :action
      attr_reader :uri
      attr_reader :body

      def headers
        @headers ||= {}
      end

      def resource_target
        uri.request_uri
      end

      def host
        uri.host
      end

      dependency :clock, Clock::UTC
      dependency :logger, Telemetry::Logger

      def initialize(connection, action, uri, body=nil, headers=nil)
        @connection = connection
        @action = action
        @uri = uri
        @body = body
        @headers = headers
      end

      def self.build(action, uri, body: nil, headers: nil, connection: nil)
        headers ||= {}

        uri = URI(uri)

        unless connection
          connection = Connect.(uri)
          headers['Connection'] ||= 'close'
        end

        instance = new connection, action, uri, body, headers

        Clock::UTC.configure instance
        Telemetry::Logger.configure instance

        instance
      end

      def self.call(*arguments)
        instance = build *arguments
        instance.()
      end

      def call
        connection.extend Connection unless connection.is_a? Connection

        check_timeout

        send_request

        response, body = receive_response

        update_timeout response

        connection.close if response['Connection'] == 'close'

        Response.new response, body
      end

      def send_request
        request = HTTP::Protocol::Request.new action, resource_target
        request['Host'] = host
        request['Content-Length'] = request_message_length

        headers.each do |field_name, field_value|
          request[field_name] = field_value
        end

        logger.opt_trace "Send Request (Resource: #{resource_target.inspect}, Message Length: #{request_message_length.inspect})"
        logger.opt_data request
        logger.opt_data body if body

        connection.write request
        connection.write body if body

        logger.opt_debug "Sent Request (Resource: #{resource_target.inspect}, Message Length: #{request_message_length.inspect})"
      end

      def receive_response
        logger.opt_trace "Receiving Response (Resource: #{resource_target.inspect})"

        response_builder = HTTP::Protocol::Response::Builder.build
        response_builder << connection.readline until response_builder.finished_headers?

        response = response_builder.message

        content_length = response['Content-Length'].to_i

        logger.opt_debug "Received Response (Status: #{response.status_code}, Content Length: #{content_length.inspect}, Resource: #{resource_target.inspect})"
        unless content_length.zero?
          body = connection.read content_length
        end
        logger.opt_data response

        return response, body

      rescue Errno::ECONNRESET => error
        logger.error "Connection reset by peer (Action: #{action}, URI: #{uri.to_s.inspect}, Connection: #{connection.fileno}, Timeout: #{connection.http_timeout&.iso8601 3})"
        raise error
      end

      def update_timeout(response)
        keep_alive = response.parse_header 'Keep-Alive'

        timeout_seconds = keep_alive[:timeout]

        return if timeout_seconds.nil?

        http_timeout = clock.now + timeout_seconds

        connection.http_timeout = http_timeout
      end

      def check_timeout
        return false if connection.http_timeout.nil?

        if connection.http_timeout < clock.now
          logger.warn "Timeout exceeded; reconnecting (Action: #{action}, URI: #{uri.to_s.inspect}, Connection: #{connection.fileno}, Timeout: #{connection.http_timeout.iso8601 3})"
          connection.close
          connection.http_timeout = nil
        end
      end

      def request_message_length
        return unless body
        Commands.content_length(body)
      end
    end
  end
end
