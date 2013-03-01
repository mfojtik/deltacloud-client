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
        must_support! :hardware_profiles
        Deltacloud::Client::HardwareProfile.from_collection(
          self,
          connection.get("#{path}/hardware_profiles", filter_opts)
        )
      end

      # Retrieve the given hardware_profile
      #
      # - hardware_profile_id -> hardware_profile to retrieve
      #
      def hardware_profile(hardware_profile_id)
        must_support! :hardware_profiles
        Deltacloud::Client::HardwareProfile.convert(
          self,
          connection.get("#{path}/hardware_profiles/#{hardware_profile_id}")
        )
      end

    end
  end
end
