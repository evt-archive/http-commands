module HTTP
  module Commands
    module Controls
      module Connection
        module Persistent
          def self.example
            reconnect_policy = ::Connection::Client::ReconnectPolicy.get :when_closed

            ::Connection::Client.new(
              Host.example,
              Port.example,
              reconnect_policy
            )
          end
        end

        module NotPersistent
          def self.example
            reconnect_policy = ::Connection::Client::ReconnectPolicy.get :never

            ::Connection::Client.new(
              Host.example,
              Port.example,
              reconnect_policy
            )
          end
        end
      end
    end
  end
end
