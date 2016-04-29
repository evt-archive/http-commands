# TODO Why are connections in a Dialogs namespace [Scott, Wed Mar 30 2016]
# Postulation: Connection may be in a Dialog namespace in the connection library

module HTTP
  module Commands
    module Controls
      module Dialogs
        def self.example
          PersistentConnection.example
        end

        module ClientClosesConnection
          def self.example
            request = Messages::Requests::Get::ClientClosesConnection.example
            response = Messages::Responses::Get::ServerClosesConnection.example

            return request, response
          end
        end

        module PersistentConnection
          def self.example
            Get.example
          end
        end

        module ServerClosesConnection
          def self.example
            request = Messages::Requests::Get::ClientAllowsConnectionReuse.example
            response = Messages::Responses::Get::ServerClosesConnection.example

            return request, response
          end
        end

        module Connection
          def self.example(expected_request=nil, expected_response=nil)
            if expected_request.nil? && expected_response.nil?
              expected_request, expected_response = Get.example
            end

            connection = ::Connection::Client::Substitute.build
            connection.extend HTTP::Commands::Connection
            connection.expect_write expected_request
            connection.expect_read expected_response
            connection
          end
        end

        module Get
          def self.example(response_resource=nil)
            request = Messages::Requests::Get.example
            response = Messages::Responses::Get.example response_resource

            return request, response
          end

          module JSON
            def self.example(response_resource=nil)
              request = Messages::Requests::Get::JSON.example
              response = Messages::Responses::Get::JSON.example response_resource

              return request, response
            end
          end
        end

        module Post
          def self.example(request_body=nil, response_body=nil)
            request = Messages::Requests::Post.example request_body
            response = Messages::Responses::Post.example response_body

            return request, response
          end

          module JSON
            def self.example(request_body=nil)
              request = Messages::Requests::Post::JSON.example request_body
              response = Messages::Responses::Post::JSON.example

              return request, response
            end
          end
        end
      end
    end
  end
end
