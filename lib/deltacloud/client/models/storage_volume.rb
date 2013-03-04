module Deltacloud::Client
  class StorageVolume < Base
    include Deltacloud::Client::Methods::StorageVolume

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

    def self.parse(xml_body)
      {
        :created =>             xml_body.text_at('created'),
        :state =>               xml_body.text_at('state'),
        :device =>              xml_body.text_at('device'),
        :capacity =>            xml_body.text_at('capacity'),
        :capacity_unit =>       xml_body.attr_at('capacity', :unit),
        :state =>               xml_body.text_at('state'),
        :realm_id =>            xml_body.attr_at('realm', :id),
        :kind  =>               xml_body.text_at('kind'),
        :mount  =>              {
          :instance => xml_body.attr_at('mount/instance', :id),
          :device => xml_body.attr_at('mount/device', :name)
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
