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
            Controls::Time::Offset::Raw.example offset, precision: 0
          end

          def self.offset
            Exceeds.offset - 1
          end
        end

        module Exceeds
          def self.example
            Controls::Time::Offset::Raw.example offset, precision: 0
          end

          def self.offset
            Timeout.example
          end
        end
      end
    end
  end
end
