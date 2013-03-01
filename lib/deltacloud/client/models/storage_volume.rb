module Deltacloud::Client
  class StorageVolume < Base

    attr_accessor :created
    attr_accessor :state
    attr_accessor :capacity
    attr_accessor :capacity_unit
    attr_accessor :device
    attr_accessor :realm_id
    attr_accessor :kind
    attr_accessor :mount

    # Check if the current volume is attached to an Instance
    #
    def attached?
      !mount[:instance].nil?
    end

    # Attach this volume to the instance
    #
    def attach(instance_id, device=nil)
      attach_storage_volume(_id, instance_id, device) && reload!
    end

    # Detach this volume from the currently attached instance
    #
    def detach
      detach_storage_volume(_id) && reload!
    end

    # Destroy the storage volume
    #
    def destroy!
      destroy_storage_volume(_id)
    end

    def self.parse(r)
      {
        :created =>             text_at(r, 'created'),
        :state =>               text_at(r, 'state'),
        :device =>              text_at(r, 'device'),
        :capacity =>            text_at(r, 'capacity'),
        :capacity_unit =>       attr_at(r, 'capacity', :unit),
        :state =>               text_at(r, 'state'),
        :realm_id =>            attr_at(r, 'realm', :id),
        :kind  =>               text_at(r, 'kind'),
        :mount  =>              {
          :instance => attr_at(r, 'mount/instance', :id),
          :device => attr_at(r, 'mount/device', :name)
        }
      }
    end

    private

    def reload!
      new_volume = storage_volume(_id)
      update_instance_variables!(
        :state => new_volume.state,
        :mount => new_volume.mount
      )
    end
  end
end
