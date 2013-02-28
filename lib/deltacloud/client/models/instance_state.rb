module Deltacloud::Client

  class InstanceState

    def self.new_state(name)
      State.new(name)
    end

    def self.new_transition(to, action)
      Transition.new(to, action)
    end

    class State
      attr_reader :name
      attr_reader :transitions

      def initialize(name)
        @name, @transitions = name, []
      end
    end

    class Transition
      attr_reader :to
      attr_reader :action

      def initialize(to, action)
        @to = to
        @action = action
      end

      def auto?
        @action.nil?
      end
    end

  end
end
