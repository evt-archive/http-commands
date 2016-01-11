module HTTP
  module Commands
    module Controls
      module Dialogs
        module Get
          def self.connection_closed
            request = Messages::Requests::Get.example
            response = Messages::Responses::Get.connection_closed

            return request, response
          end

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
