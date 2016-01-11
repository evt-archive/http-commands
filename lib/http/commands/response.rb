module HTTP
  module Commands
    class Response
      attr_reader :body
      attr_reader :response

      def initialize(response, body)
        @body = body
        @response = response
      end

      def method_missing(method_name, *arguments, &block)
        response.public_send method_name, *arguments, &block
      end

      def respond_to?(method_name)
        return true if super
        response.respond_to? method_name
      end
    end
  end
end
