module Deltacloud::Client
  module Methods
    module HardwareProfile

      # Retrieve list of all hardware_profiles
      #
      # Filter options:
      #
      # - :id -> Filter hardware_profiles using their 'id'
      #
      def hardware_profiles(filter_opts={})
        from_collection :hardware_profiles,
          connection.get(api_uri('hardware_profiles'), filter_opts)
      end

      # Retrieve the given hardware_profile
      #
      # - hardware_profile_id -> hardware_profile to retrieve
      #
      def hardware_profile(hwp_id)
        from_resource :hardware_profile,
          connection.get(api_uri("hardware_profiles/#{hwp_id}"))
      end

    end
  end
end
