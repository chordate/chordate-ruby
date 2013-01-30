module Chordate
  class Error
    def initialize(*args)
      @ex = args.shift

      @json = {
        :env => Chordate.config.env,
        :generated_at => Time.now,
        :klass => @ex.class.name,
        :message => @ex.message,
        :backtrace => @ex.backtrace,
        :server => Chordate.config.server
      }

      merge!(args.shift)
    end

    def merge!(other)
      other.each do |(k, v)|
        v.nil? ? @json.delete(k) : @json[k] = v
      end

      self
    end

    def as_json(*)
      @json
    end
  end
end
