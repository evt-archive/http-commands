module HTTP
  module Commands
    module Controls
      module URI
        def self.example
          ::URI::HTTP.build :host => host, :path => resource_target
        end

        def self.host
          Host.example
        end

        def self.resource_target
          ResourceTarget.example
        end
      end
    end
  end
end
