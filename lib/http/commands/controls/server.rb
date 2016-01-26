module HTTP
  module Commands
    module Controls
      class Server
        attr_reader :port
        attr_reader :ssl_context
        attr_accessor :scheduler
        attr_accessor :server_connection

        dependency :logger, Telemetry::Logger

        def initialize(port, ssl_context)
          @port = port
          @ssl_context = ssl_context
        end

        def self.build(ssl_context: nil)
          port = 8000

          instance = new port, ssl_context
          Telemetry::Logger.configure instance
          instance
        end

        def self.run(ssl: nil, &block)
          ssl ||= false

          if ssl
            ssl_context = HTTP::Commands::Controls::SSL::Context::Server.example
            server = build ssl_context: ssl_context
          else
            server = build
          end

          Run.(server, &block)
        end

        def start
          logger.opt_trace "Waiting for Client (Port: #{port.inspect})"
          client_connection = server_connection.accept
          logger.opt_debug "Client Connected (Port: #{port.inspect})"

          logger.opt_trace "Receiving Request (Port: #{port.inspect})"
          request_builder = HTTP::Protocol::Request::Builder.build
          request_builder << client_connection.readline until request_builder.finished_headers?
          request = request_builder.message
          content_length = request['Content-Length'].to_i
          client_connection.read content_length
          logger.opt_debug "Received Request (Action: #{request.action.inspect}, Length: #{content_length.inspect}, Port: #{port.inspect})"
          logger.opt_data request

          logger.opt_trace "Sending Response (Port: #{port.inspect})"
          response = HTTP::Protocol::Response.new '200', 'OK'
          response['Connection'] = 'close'
          response['Content-Length'] = 9
          client_connection.write response
          client_connection.write 'some-text'
          logger.opt_debug "Sent Response (Port: #{port.inspect})"

        ensure
          client_connection.close if client_connection
          server_connection.close
        end

        def server_connection
          @server_connection ||= Connection.server(
            port,
            scheduler: scheduler,
            ssl_context: ssl_context
          )
        end

        module ProcessHostIntegration
          def change_connection_scheduler(scheduler)
            self.scheduler = scheduler
          end
        end
      end
    end
  end
end
