module HTTP
  module Commands
    module Action
      def self.included(cls)
        cls.extend Actuate
        cls.extend Build
        cls.extend Configure

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
        # TODO Why is this an optional positional param when the other methods at this level are named param? [Scott, Wed Mar 30 2016]
        # Postulation: because it's the only param
        # This pattern is in other libraries as well
        def build(connection=nil, &blk)
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

      def action(action, uri, body: nil, headers: nil, &blk)
        # TODO headers is a candidate for instance member (it's passed around) [Scott, Wed Mar 30 2016]
        headers ||= {}

        # TODO uri is a candidate for instance member (it's passed around) [Scott, Wed Mar 30 2016]
        uri = URI(uri)

        connection = get_connection(self.connection, uri, headers, &blk)

        Request.(
          connection,
          action,
          uri.host,
          uri.request_uri,
          body: body,
          headers: headers
        )
      end

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
  end
end
