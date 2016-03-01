module HTTP
  module Commands
    module Controls
      module Messages
        module Responses
          module Get
            def self.example(body=nil)
              ServerAllowsConnectionReuse.example body
            end

            module ServerAllowsConnectionReuse
              def self.example(body=nil)
                body ||= Resources.text

                <<-HTTP.chomp
HTTP/1.1 200 Ok\r
Content-Length: #{Commands.content_length(body)}\r
\r
#{body}
                HTTP
              end
            end

            module ServerClosesConnection
              def self.example(body=nil)
                body ||= Resources.text

                <<-HTTP.chomp
HTTP/1.1 200 Ok\r
Content-Length: #{Commands.content_length(body)}\r
Connection: close\r
\r
#{body}
                HTTP
              end
            end

            module JSON
              def self.example(resource=nil)
                resource ||= Resources.json
                body = ::JSON.pretty_generate resource

                <<-HTTP.chomp
HTTP/1.1 200 Ok\r
Content-Length: #{Commands.content_length(body)}\r
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
Content-Length: #{Commands.content_length(response_body)}\r
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
