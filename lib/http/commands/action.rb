module HTTP
  module Commands
    module Action
      def self.included(cls)
        cls.extend Actuate
        cls.extend Build
        cls.extend Configure
        cls.extend Connection
        cls.extend Logger

        cls.class_exec do
          # TODO Is this otherwise a dependency? [Scott, Wed Mar 30 2016]
          attr_accessor :connection

          dependency :logger, Telemetry::Logger
        end
      end

      module Actuate
        def call(*arguments, connection: nil, &blk)
          instance = build connection
          instance.(*arguments, &blk)
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
          attr_name ||= receiver_attr_name

          instance = build connection
          receiver.send "#{attr_name}=", instance
          instance
        end

        def receiver_attr_name
          self.name.downcase.split('::').last
        end
      end

      module Connection
        def get_connection(connection, uri, headers, &blk)
          if connection.nil?
            connection = get_one_time_connection(uri, headers, &blk)
          end

          connection
        end

        def get_one_time_connection(uri, headers, &blk)
          logger.trace "Creating one-time connection"

          headers['Connection'] ||= 'close'
          connection = Connect.(uri)

          if blk
            blk.(connection)
          end

          logger.debug "Created one-time connection"

          connection
        end
      end

      module Logger
        def logger
          Telemetry::Logger.get self
        end
      end

      def action(action, uri, body: nil, headers: nil, &blk)
        # TODO headers is a candidate for instance member (it's passed around) [Scott, Wed Mar 30 2016]
        headers ||= {}

        # TODO uri is a candidate for instance member (it's passed around) [Scott, Wed Mar 30 2016]
        uri = URI(uri)

        connection = self.class.get_connection(self.connection, uri, headers, &blk)

        Request.(
          connection,
          action,
          uri.host,
          uri.request_uri,
          body: body,
          headers: headers
        )
      end
    end
  end
end
