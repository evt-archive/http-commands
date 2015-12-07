module HTTP
  module Commands
    module Controls
      module URI
        def self.example(resource_target=nil, port: nil)
          resource_target ||= 'some-resource'
          port ||= 8000

          File.join "http://localhost:#{port}", resource_target
        end
      end
    end
  end
end
