module HTTP
  module Commands
    class Post
      include Action

      def call(body, uri, headers=nil)
        action 'POST', uri, body: body, headers: headers
      end

      module Substitute
        def self.build
          Commands::Substitute.build status_code, reason_phrase
        end

        def self.reason_phrase
          'Created'
        end

        def self.status_code
          201
        end
      end
    end
  end
end
