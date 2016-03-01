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
        def call(uri, headers=nil, connection: nil)
          instance = build connection
          instance.(uri, headers)
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

        connection = coalesce_connection self.connection, uri do
          headers['Connection'] ||= 'close'
        end

        resource_target = uri.request_uri
        host = uri.host

        Request.(
          connection,
          action,
          host,
          resource_target,
          body: body,
          headers: headers
        )
      end

      def coalesce_connection(connection, uri, &block)
        return connection if connection

        connection = Connect.(uri)
        block.()
        connection
      end
    end
  end
end
