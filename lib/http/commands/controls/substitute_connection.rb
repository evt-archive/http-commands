module HTTP
  module Commands
    module Controls
      class SubstituteConnection
        include Minitest::Assertions

        attr_reader :expected_request
        attr_reader :response

        dependency :logger, Telemetry::Logger

        def initialize(expected_request, response)
          @expected_request = expected_request
          @response = response
        end

        def self.build(expected_request, response_string)
          response = StringIO.new response_string

          instance = new expected_request, response
          Telemetry::Logger.configure instance
          instance
        end

        def actual_request
          request.string
        end

        def readline(*arguments)
          response.readline(*arguments)
        end

        def request
          @request ||= StringIO.new
        end

        def verify_request
          return true if expected_request == actual_request

          diff = self.diff expected_request, actual_request
          logger.fail 'Request data did not match expected data:'
          logger.fail diff

          false
        end

        def read(*arguments)
          response.read(*arguments)
        end

        def write(*arguments)
          request.write *arguments
        end
      end
    end
  end
end
