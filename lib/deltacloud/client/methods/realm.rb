module Deltacloud::Client
  module Methods
    module Realm

      # Retrieve list of all realms
      #
      # Filter options:
      #
      # - :id -> Filter realms using their 'id'
      # - :state -> Filter realms  by their 'state'
      #
      def realms(filter_opts={})
        from_collection :realms,
          connection.get(api_uri("realms"), filter_opts)
      end

      # Retrieve the given realm
      #
      # - realm_id -> Instance to retrieve
      #
      def realm(realm_id)
        from_resource :realm,
          connection.get(api_uri("realms/#{realm_id}"))
      end

    end
  end
end
