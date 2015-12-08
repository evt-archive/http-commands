module HTTP
  module Commands
    module Controls
      module Connections
        def self.get
          uri = 'http://www.example.com/some-path'

          expected_request = <<-EXPECTED_REQUEST
GET /some-path HTTP/1.1\r
Host: www.example.com\r
\r
          EXPECTED_REQUEST

          connection = SubstituteConnection.build expected_request, <<-RESPONSE
HTTP/1.1 200 OK\r
Content-Length: 9\r
\r
some-text
          RESPONSE

          return connection, uri
        end

        def self.post(response_body=nil)
          uri = 'http://www.example.com/some-path'
          body = 'some-text'

          expected_request = <<-EXPECTED_REQUEST.chomp("\n")
POST /some-path HTTP/1.1\r
Host: www.example.com\r
Content-Length: #{body.bytesize}\r
\r
#{body}
          EXPECTED_REQUEST

          if response_body
            response = <<-RESPONSE
HTTP/1.1 201 Created\r
Content-Length: #{response_body.bytesize}\r
\r
#{response_body}
            RESPONSE
          else
            response = <<-RESPONSE
HTTP/1.1 201 Created\r
\r
            RESPONSE
          end

          connection = SubstituteConnection.build expected_request, response

          return connection, body, uri
        end
      end
    end
  end
end
