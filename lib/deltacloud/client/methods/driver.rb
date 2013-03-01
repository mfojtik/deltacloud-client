module Deltacloud::Client
  module Methods
    module Driver

      # Retrieve list of all drivers
      #
      # Filter options:
      #
      # - :id -> Filter drivers using their 'id'
      # - :state -> Filter drivers  by their 'state'
      #
      def drivers(filter_opts={})
        from_collection(
          :drivers,
          connection.get(api_uri('drivers'), filter_opts)
        )
      end

      # Retrieve the given driver
      #
      # - driver_id -> Driver to retrieve
      #
      def driver(driver_id)
        from_resource(
          :driver,
          connection.get(api_uri("drivers/#{driver_id}"))
        )
      end

      # List of the current driver providers
      #
      def providers
        driver(current_driver).providers
      end

    end

  end
end
