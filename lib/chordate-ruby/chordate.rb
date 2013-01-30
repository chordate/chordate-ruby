require 'chordate-ruby/config'
require 'chordate-ruby/runner/event'
require 'chordate-ruby/error'

module Chordate
  class << self
    def configure
      (@config ||= Chordate::Config.new).tap do |config|
        yield config
      end
    end

    def config
      @config
    end

    def run!
      unless running?
        (@event_runner ||= Runner::Event.new).tap do |runner|
          runner.start
        end

        @running = true
      end
    end

    def running?
      !!@running
    end

    def error(*args)
      @event_runner.async.push(
        Chordate::Error.new(*args).as_json
      )
    end

    private

    def clear
      @event_runner && @event_runner.terminate

      @running = @event_runner = nil
    end
  end
end
