module HTTP
  module Commands
    module Controls
      class Server
        class Run
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

          def self.call(server, port: nil, &block)
            client = build port, &block

            cooperation = ProcessHost::Cooperation.build
            cooperation.register server, 'server'
            cooperation.register client, 'client'
            cooperation.start
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
