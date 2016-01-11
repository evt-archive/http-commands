module HTTP
  module Commands
    module Controls
      module Messages
        module Resources
          def self.example
            'some-message'
          end

          def self.json
            { 'some-key' => 'some-value' }
          end

          def self.text
            example
          end
        end
      end
    end
  end
end
