module HTTP
  module Commands
    class PersistentConnection
      dependency :logger, Telemetry::Logger

      def self.build
        instance = new
        Telemetry::Logger.configure instance
        instance
      end

      def call(connection)
        logger.opt_trace "Checking for persistent HTTP connection support (Type: #{connection.class.name.inspect})"

        return false unless connection.respond_to? :reconnect_policy

        reconnect_policy = connection.reconnect_policy
        supported = when_closed_policy? reconnect_policy

        logger.opt_debug "Checked for persistent HTTP connection support (Type: #{connection.class.name.inspect}, Supported: #{supported})"

        supported
      end

      def when_closed_policy?(reconnect_policy)
        reconnect_policy.is_a? self.class.when_closed_policy
      end

      def self.when_closed_policy
        Connection::Client::ReconnectPolicy.policy_class :when_closed
      end

      def self.configure(receiver, attr_name=nil)
        attr_name ||= :persistent_connection

        instance = build
        receiver.public_send "#{attr_name}=", instance
        instance
      end

      class Substitute
        attr_accessor :persistent

        def self.build
          instance = new
          instance.persistent = true
          instance
        end

        def call(connection)
          if persistent
            true
          else
            false
          end
        end
      end
    end
  end
end
