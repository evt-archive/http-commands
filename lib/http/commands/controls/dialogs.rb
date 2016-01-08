module HTTP
  module Commands
    module Controls
      module Dialogs
        def self.example
          Get.example
        end

        module Get
          def self.example
            request = Messages::Requests::Get.example
            response = Messages::Responses::Get.example

            return request, response
          end

          module JSON
            def self.example
              request = Messages::Requests::Get::JSON.example
              response = Messages::Responses::Get::JSON.example

              return request, response
            end
          end
        end
      end
    end
  end
end
