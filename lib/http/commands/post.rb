module HTTP
  module Commands
    class Post
      attr_accessor :connection

      dependency :logger, Telemetry::Logger

      def self.build(connection=nil)
        new.tap do |instance|
          Telemetry::Logger.configure instance

          instance.connection = connection if connection
        end
      end

      def self.call(body, uri, headers=nil, connection: nil)
        instance = build connection
        instance.(body, uri, headers)
      end

      def self.configure(receiver, attr_name=nil, connection: nil)
        attr_name ||= :post

        instance = build connection
        receiver.send "#{attr_name}=", instance
        instance
      end

      def call(body, uri, headers=nil)
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
          'POST',
          host,
          resource_target,
          body: body,
          headers: headers
        )
      end

      module Substitute
        def self.build
          Commands::Substitute.build status_code, reason_phrase
        end

        def self.reason_phrase
          'Created'
        end

        def self.status_code
          201
        end
      end
    end
  end
end
