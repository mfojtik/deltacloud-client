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
        must_support! :drivers
        Deltacloud::Client::Driver.from_collection(self, connection.get("#{path}/drivers", filter_opts))
      end

      # Retrieve the given driver
      #
      # - driver_id -> Driver to retrieve
      #
      def driver(driver_id)
        must_support! :drivers
        Deltacloud::Client::Driver.convert(self, connection.get("#{path}/drivers/#{driver_id}"))
      end

      # List of the current driver providers
      #
      def providers
        driver(current_driver).providers
      end

    end

  end
end
