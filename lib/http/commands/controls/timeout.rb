module HTTP
  module Commands
    module Controls
      module Timeout
        def self.example
          11
        end

        module Time
          def self.example
            Exceeds.example
          end
        end

        module Within
          def self.example
            ::Time.parse iso8601
          end

          def self.iso8601
            seconds = Timeout.example - 1
            ::Controls::Time::Elapsed.example seconds, precision: 0
          end
        end

        module Exceeds
          def self.example
            ::Time.parse iso8601
          end

          def self.iso8601
            seconds = Timeout.example
            ::Controls::Time::Elapsed.example seconds, precision: 0
          end
        end
      end
    end
  end
end
