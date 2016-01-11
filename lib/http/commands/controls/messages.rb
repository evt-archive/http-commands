module HTTP
  module Commands
    module Controls
      module Messages
        module Resources
          def self.example
            'some-message'
          end

          def self.json
            { 'some-key' => 'some-value' }
          end

          def self.text
            example
          end
        end

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

          module Post
            def self.example(body=nil)
              body ||= Resources.text

              <<-HTTP.chomp
POST /resource-target HTTP/1.1\r
Host: www.example.com\r
Content-Length: #{body.bytesize}\r
\r
#{body}
              HTTP
            end

            module JSON
              def self.example(resource=nil)
                resource ||= Resources.json
                request_body = ::JSON.pretty_generate resource

                <<-HTTP.chomp
POST /resource-target HTTP/1.1\r
Host: www.example.com\r
Content-Length: #{request_body.bytesize}\r
Content-Type: application/json\r
\r
#{request_body}
                HTTP
              end
            end
          end
        end

        module Responses
          module Get
            def self.connection_closed
              <<-HTTP
HTTP/1.1 200 Ok\r
Content-Length: 0\r
Connection: close\r
\r
              HTTP
            end

            def self.example(body=nil)
              body ||= Resources.text

              <<-HTTP.chomp
HTTP/1.1 200 Ok\r
Content-Length: #{body.bytesize}\r
\r
#{body}
              HTTP
            end

            module JSON
              def self.example(resource=nil)
                resource ||= Resources.json
                body = ::JSON.pretty_generate resource

                <<-HTTP.chomp
HTTP/1.1 200 Ok\r
Content-Length: #{body.bytesize}\r
\r
#{body}
              HTTP
              end
            end
          end

          module Post
            def self.example(response_body=nil)
              if response_body
                <<-HTTP.chomp
HTTP/1.1 201 Created\r
Content-Length: #{response_body.bytesize}\r
\r
#{response_body}
                HTTP
              else
                <<-HTTP
HTTP/1.1 201 Created\r
\r
                HTTP
              end
            end

            module JSON
              def self.example
                Post.example
              end
            end
          end
        end
      end
    end
  end
end
