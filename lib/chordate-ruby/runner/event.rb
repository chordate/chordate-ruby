require 'celluloid'

module Chordate
  module Runner
    class Event
      include Celluloid

      attr_reader :errors

      def initialize
        @errors = []
        @exit = false
      end

      def start
        if errors.any?
          HTTP.post(:events, :batch => errors)

          @errors = []
        end

        return if exit?

        after(5) { start }
      end

      def push(e)
        @errors << e
      end

      def exit
        @exit = true
      end

      def exit?
        @exit
      end
    end
  end
end
