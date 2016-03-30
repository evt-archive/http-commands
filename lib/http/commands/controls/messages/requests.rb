module HTTP
  module Commands
    module Controls
      module Messages
        module Requests
          def self.uri
            URI.example
          end

          module Get
            def self.example
              ClientAllowsConnectionReuse.example
            end

            module ClientAllowsConnectionReuse
              def self.example
                <<-HTTP
GET #{ResourceTarget.example} HTTP/1.1\r
Host: #{Host.example}\r
\r
                HTTP
              end
            end

            module ClientClosesConnection
              def self.example
                <<-HTTP
GET #{ResourceTarget.example} HTTP/1.1\r
Host: #{Host.example}\r
Connection: close\r
\r
                HTTP
              end
            end

            module JSON
              def self.example
                <<-HTTP
GET #{ResourceTarget.example} HTTP/1.1\r
Host: #{Host.example}\r
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
POST #{ResourceTarget.example} HTTP/1.1\r
Host: #{Host.example}\r
Content-Length: #{Commands.content_length(body)}\r
\r
#{body}
              HTTP
            end

            module JSON
              def self.example(resource=nil)
                resource ||= Resources.json
                request_body = ::JSON.pretty_generate resource

                <<-HTTP.chomp
POST #{ResourceTarget.example} HTTP/1.1\r
Host: #{Host.example}\r
Content-Length: #{Commands.content_length(request_body)}\r
Content-Type: application/json\r
\r
#{request_body}
                HTTP
              end
            end
          end
        end
      end
    end
  end
end
