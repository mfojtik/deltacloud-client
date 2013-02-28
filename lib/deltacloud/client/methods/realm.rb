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
        must_support! :realms
        Deltacloud::Client::Realm.from_collection(self, connection.get("#{path}/realms", filter_opts))
      end

      # Retrieve the given realm
      #
      # - realm_id -> Instance to retrieve
      #
      def realm(realm_id)
        must_support! :realms
        Deltacloud::Client::Realm.convert(self, connection.get("#{path}/realms/#{realm_id}"))
      end

    end
  end
end
