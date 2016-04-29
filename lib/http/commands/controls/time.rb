module HTTP
  module Commands
    module Controls
      module Time
        def self.example
          ::Time.parse iso8601
        end

        def self.iso8601
          ::Controls::Time::Elapsed.reference
        end
      end
    end
  end
end
