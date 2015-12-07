module HTTP
  module Commands
    module Controls
      module URI
        def self.example
          test_server_port = ENV['TEST_SERVER_PORT'] || 8000

          "http://localhost:#{test_server_port}/some-resource"
        end
      end
    end
  end
end
