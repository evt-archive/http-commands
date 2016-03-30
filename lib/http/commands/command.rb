module HTTP
  module Commands
    module Command
      def self.included(cls)
        cls.extend Actuate
        cls.extend Build
        cls.extend Info
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
          attr_name ||= receiver_attr_name

          instance = build connection
          receiver.public_send "#{attr_name}=", instance
          instance
        end
      end

      module Info
        def receiver_attr_name
          class_name.downcase
        end

        def action
          class_name.upcase
        end

        def class_name
          self.name.split('::').last
        end
      end
    end
  end
end
