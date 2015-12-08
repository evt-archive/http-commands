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

        def self.build(port=nil, ssl_context: nil)
          port ||= 8000

          instance = new port, ssl_context
          Telemetry::Logger.configure instance
          instance
        end

        def self.run(ssl: nil, &block)
          ssl ||= false

          if ssl
            ssl_context = Connection::Controls::SSL.server_context
            server = build ssl_context: ssl_context
          else
            server = build
          end

          client = Client.build &block

          cooperation = ProcessHost::Cooperation.build
          cooperation.register server, 'server'
          cooperation.register client, 'client'
          cooperation.start
        end

        def start
          logger.trace "Waiting for Client (Port: #{port.inspect})"
          client_connection = server_connection.accept
          logger.debug "Client Connected (Port: #{port.inspect})"

          logger.trace "Receiving Request (Port: #{port.inspect})"
          request_builder = HTTP::Protocol::Request::Builder.build
          until request_builder.finished_headers?
            logger.focus "About to Readline"
            line = client_connection.readline
            request_builder << line
            logger.focus "Header (Line: #{line.inspect})"
          end
          request = request_builder.message
          content_length = request['Content-Length'].to_i
          client_connection.read content_length
          logger.debug "Received Request (Action: #{request.action.inspect}, Length: #{content_length.inspect}, Port: #{port.inspect})"
          logger.data request

          logger.trace "Sending Response (Port: #{port.inspect})"
          response = HTTP::Protocol::Response.new '200', 'OK'
          response['Connection'] = 'close'
          response['Content-Length'] = 9
          client_connection.write response
          client_connection.write 'some-text'
          logger.debug "Sent Response (Port: #{port.inspect})"

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

        class Client
          attr_reader :block
          attr_reader :port
          attr_accessor :scheduler

          def initialize(block, port)
            @block = block
            @port = port
          end

          def self.build(port=nil, &block)
            port ||= 8000
            instance = new block, port
            instance
          end

          def start
            block.(port, scheduler)
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
end
