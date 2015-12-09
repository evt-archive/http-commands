module HTTP
  module Commands
    module Controls
      module Data
        def self.text
          'some-text'
        end

        def self.json
          JSON.dump({ 'some-key' => 'some-text' })
        end
      end
    end
  end
end
