module HTTP
  module Commands
    module Controls
      module Messages
        module Requests
          def self.host
            'www.example.com'
          end

          def self.resource_target
            '/resource-target'
          end

          module Get
            def self.example
              <<-HTTP
GET /resource-target HTTP/1.1\r
Host: www.example.com\r
\r
              HTTP
            end

            module JSON
              def self.example
                <<-HTTP
GET /resource-target HTTP/1.1\r
Host: www.example.com\r
Accept: application/json\r
\r
                HTTP
              end
            end
          end
        end

        module Responses
          module Get
            def self.example
              <<-HTTP.chomp
HTTP/1.1 200 Ok\r
Content-Length: 12\r
\r
some-message
              HTTP
            end

            module JSON
              def self.example
                json = ::JSON.pretty_generate('some-key' => 'some-value')

                <<-HTTP.chomp
HTTP/1.1 200 Ok\r
Content-Length: #{json.bytesize}\r
\r
#{json}
              HTTP
              end
            end
          end
        end
      end
    end
  end
end
