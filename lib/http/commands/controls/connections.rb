module HTTP
  module Commands
    module Controls
      module Connections
        extend self

        def get(response_headers=nil)
          uri = 'http://www.example.com/some-path'
          response_body = Controls::Data.text

          expected_request = <<-EXPECTED_REQUEST
GET /some-path HTTP/1.1\r
Host: www.example.com\r
\r
          EXPECTED_REQUEST

          response_headers ||= {}
          response_headers['Content-Length'] = response_body.bytesize

          headers = response_headers.reduce '' do |string, (field_name, field_value)|
            string << "#{field_name}: #{field_value}\r\n"
          end

          connection = SubstituteConnection.build expected_request, <<-RESPONSE.chomp("\n")
HTTP/1.1 200 OK\r
Content-Length: #{response_body.bytesize}\r
#{headers}\r
#{response_body}
          RESPONSE

          return connection, response_body, uri
        end

        def get_json
          uri = 'http://www.example.com/some-path'
          response_body = Controls::Data.json

          expected_request = <<-EXPECTED_REQUEST
GET /some-path HTTP/1.1\r
Host: www.example.com\r
Accept: application/json\r
\r
          EXPECTED_REQUEST

          connection = SubstituteConnection.build expected_request, <<-RESPONSE.chomp("\n")
HTTP/1.1 200 OK\r
Content-Length: #{response_body.bytesize}\r
Content-Type: application/json\r
\r
#{response_body}
          RESPONSE

          return connection, response_body, uri
        end

        def post(response_body=nil)
          uri = 'http://www.example.com/some-path'
          request_body = Controls::Data.text

          expected_request = <<-EXPECTED_REQUEST.chomp("\n")
POST /some-path HTTP/1.1\r
Host: www.example.com\r
Content-Length: #{request_body.bytesize}\r
\r
#{request_body}
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

          return connection, request_body, uri
        end

        def post_json
          uri = 'http://www.example.com/some-path'
          request_body = Controls::Data.json

          expected_request = <<-EXPECTED_REQUEST.chomp("\n")
POST /some-path HTTP/1.1\r
Host: www.example.com\r
Content-Length: #{request_body.bytesize}\r
Content-Type: application/json\r
\r
#{request_body}
          EXPECTED_REQUEST

          response = <<-RESPONSE
HTTP/1.1 201 Created\r
\r
          RESPONSE

          connection = SubstituteConnection.build expected_request, response

          return connection, request_body, uri
        end
      end
    end
  end
end
