module Chordate
  class HTTP
    class << self
      def post(path, body = {})
        Typhoeus.post(url_for(path), :body => body.merge(:token => Chordate.config.token))
      end

      private

      def url_for(path)
        "#{Chordate.config.proto}#{Chordate.config.host}#{Chordate.config.base_url}/#{path}.json"
      end
    end
  end
end
