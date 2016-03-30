module HTTP
  module Commands
    module Action
      def self.included(cls)
        cls.extend Actuate
        cls.extend Build
        cls.extend Configure

        cls.class_exec do
          attr_accessor :connection

          dependency :logger, Telemetry::Logger
        end
      end

      module Actuate
        def call(*arguments, connection: nil)
          instance = build connection
          instance.(*arguments)
        end
      end

      module Build
        def build(connection=nil)
          new.tap do |instance|
            Telemetry::Logger.configure instance
            instance.connection = connection if connection
          end
        end
      end

      module Configure
        def configure(receiver, attr_name=nil, connection: nil)
          attr_name ||= :get

          instance = build connection
          receiver.send "#{attr_name}=", instance
          instance
        end
      end

      def action(action, uri, body: nil, headers: nil)
        headers ||= {}

        uri = URI(uri)

        connection = self.connection

        if connection.nil?
          headers['Connection'] ||= 'close'
          connection = Connect.(uri)
        end

        response = Request.(
          connection,
          action,
          uri.host,
          uri.request_uri,
          body: body,
          headers: headers
        )

        return response, connection
      end
    end
  end
end
