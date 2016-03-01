module HTTP
  module Commands
    class Get
      attr_accessor :connection

      dependency :logger, Telemetry::Logger

      def self.build(connection=nil)
        new.tap do |instance|
          Telemetry::Logger.configure instance

          instance.connection = connection if connection
        end
      end

      def self.configure(receiver, attr_name=nil, connection: nil)
        attr_name ||= :get

        instance = build connection
        receiver.send "#{attr_name}=", instance
        instance
      end

      def self.call(uri, headers=nil, connection: nil)
        instance = build connection
        instance.(uri, headers)
      end

      def call(uri, headers=nil)
        headers ||= {}

        uri = URI(uri)
        connection = self.connection

        if connection.nil?
          headers['Connection'] ||= 'close'
          connection = Connect.(uri)
        end

        resource_target = uri.request_uri
        host = uri.host

        Request.(
          connection,
          'GET',
          host,
          resource_target,
          headers: headers
        )
      end

      module Substitute
        def self.build
          Commands::Substitute.build status_code, reason_phrase
        end

        def self.reason_phrase
          'OK'
        end

        def self.status_code
          200
        end
      end
    end
  end
end
