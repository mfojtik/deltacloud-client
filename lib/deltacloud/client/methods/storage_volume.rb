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

      # Create new storage volume
      #
      # - :snapshot_id -> Snapshot to use for creating a new volume
      # - :capaccity   -> Initial Volume capacity
      # - :realm_id    -> Create volume in this realm
      # - :name        -> Volume name
      # - :description -> Volume description
      #
      # NOTE: Some create options might not be supported by backend cloud
      #
      def create_storage_volume(create_opts={})
        must_support! :storage_volumes
        r = connection.post(api_uri("storage_volumes")) do |request|
          request.params = create_opts
        end
        from_resource :storage_volume, r
      end

      # Destroy the current +StorageVolume+
      # Returns 'true' if the response was 204 No Content
      #
      # - volume_id -> The 'id' of the volume to destroy
      #
      def destroy_storage_volume(volume_id)
        must_support! :storage_volumes
        r = connection.delete(api_uri("storage_volumes/#{volume_id}"))
        r.status == 204
      end

      def attach_storage_volume(volume_id, instance_id, device=nil)
        must_support! :storage_volumes
        result = connection.post(api_uri("/storage_volumes/#{volume_id}/attach")) do |r|
          r.params = { :instance_id => instance_id, :device => device }
        end
        if result.status.is_ok?
          from_resource(:storage_volume, result)
        end
      end

      def detach_storage_volume(volume_id)
        must_support! :storage_volumes
        result = connection.post(api_uri("/storage_volumes/#{volume_id}/detach"))
        if result.status.is_ok?
          from_resource(:storage_volume, result)
        end
      end

    end
  end
end
