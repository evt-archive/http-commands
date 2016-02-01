module HTTP
  module Commands
    class Substitute
      attr_accessor :response_body
      attr_accessor :reason_phrase
      attr_accessor :status_code

      def initialize(status_code, reason_phrase)
        @reason_phrase = reason_phrase
        @status_code = status_code
      end

      def self.build(status_code, reason_phrase, response_body=nil)
        instance = new status_code, reason_phrase
        instance.response_body = response_body if response_body
        instance
      end

      def call(*)
        Response.new http_protocol_response, response_body
      end

      def http_protocol_response
        HTTP::Protocol::Response.new status_code, reason_phrase
      end
    end
  end
end
