module Deltacloud::Client
  module Methods
    module InstanceState

      # Representation of the current driver state machine
      #
      def instance_states
        r = connection.get("#{path}/instance_states")
        r.body.to_xml.root.xpath('state').map do |se|
          state = Deltacloud::Client::InstanceState.new_state(se['name'])
          se.xpath('transition').each do |te|
            state.transitions << Deltacloud::Client::InstanceState.new_transition(
              te['to'], te['action']
            )
          end
          state
        end
      end

      def instance_state(name)
        instance_states.find { |s| s.name.to_s.eql?(name.to_s) }
      end

    end
  end
end
