module HTTP
  module Commands
    class Get
      include Command

      def call(uri, headers=nil)
        execute 'GET', uri, headers: headers
      end

      module Substitute
        def self.build
          Commands::Substitute.build status_code, reason_phrase
        end

        def self.reason_phrase
          'OK'
        end

        def self.status_code
          200
        end
      end
    end
  end
end
