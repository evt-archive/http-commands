module HTTP
  module Commands
    class Get
      include Action

      def call(uri, headers=nil, &blk)
        action 'GET', uri, headers: headers, &blk
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
