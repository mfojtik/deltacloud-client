module Deltacloud::Client
  module Methods
    module StorageVolume

      # Retrieve list of all storage_volumes
      #
      # Filter options:
      #
      # - :id -> Filter storage_volumes using their 'id'
      # - :state -> Filter storage_volumes  by their 'state'
      #
      def storage_volumes(filter_opts={})
        from_collection :storage_volumes,
          connection.get(api_uri("storage_volumes"), filter_opts)
      end

      # Retrieve the given storage_volume
      #
      # - storage_volume_id -> Instance to retrieve
      #
      def storage_volume(storage_volume_id)
        from_resource :storage_volume,
          connection.get(api_uri("storage_volumes/#{storage_volume_id}"))
      end

    end
  end
end
