module Chordate
  class Config
    def initialize
      @config = {
        'env' => rails(:env) || 'default',
        'proto' => 'https://',
        'host' => "chordate.io",
        'server' => {
          :root => rails(:root) || `pwd`.chomp,
          :hostname => `hostname`.chomp,
          :gem_version => Chordate::Version::STRING
        }
      }
    end

    def [](key)
      @config[key.to_s]
    end

    def token=(token)
      token = token.split(':')

      (@config['token'] = token[1]).tap do
        @config['base_url'] ||= "/v1/applications/#{token[0]}"
      end
    end

    def method_missing(meth, *args)
      case meth
      when /=$/
        @config[meth.to_s[0..-2]] = args.first
      else
        @config[meth.to_s]
      end
    end

    private

    def rails(method)
      defined?(Rails) ? Rails.send(method).to_s : nil
    end
  end
end
