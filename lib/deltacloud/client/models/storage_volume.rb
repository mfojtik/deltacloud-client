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

    def attached?
      !mount[:instance].nil?
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
  end
end
