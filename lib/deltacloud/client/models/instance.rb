module Deltacloud::Client
  class Instance < Base

    include Deltacloud::Client::Methods::Instance

    attr_reader :realm_id
    attr_reader :owner_id
    attr_reader :image_id
    attr_reader :hardware_profile_id

    attr_accessor :state
    attr_accessor :public_addresses
    attr_accessor :private_addresses

    # Destroy the current Instance
    #
    def destroy!
      destroy_instance(_id)
    end

    # Execute +stop_instance+ method on current Instance
    #
    def stop!
      stop_instance(_id) && reload!
    end

    # Execute +start_instance+ method on current Instance
    #
    def start!
      start_instance(_id) && reload!
    end

    # Execute +reboot_instance+ method on current Instance
    #
    def reboot!
      reboot_instance(_id) && reload!
    end

    class << self

      def parse(inst)
        {
          :name =>                text_at(inst, 'name'),
          :description =>         text_at(inst, 'description'),
          :state =>               text_at(inst, 'state'),
          :realm_id =>            attr_at(inst, 'realm', :id),
          :owner_id =>            text_at(inst, 'owner_id'),
          :image_id =>            attr_at(inst, 'image', :id),
          :hardware_profile_id => attr_at(inst, 'hardware_profile', :id),
          :public_addresses => InstanceAddress.convert(
            inst.xpath('public_addresses/address')
          ),
          :private_addresses => InstanceAddress.convert(
            inst.xpath('private_addresses/address')
          )
        }
      end

    end

    private

    # Attempt to reload :public_addresses, :private_addresses and :state
    # of the instance, after the instance is modified by calling method
    #
    def reload!
      new_instance = instance(_id)
      update_instance_variables!(
        :public_addresses => new_instance.public_addresses,
        :private_addresses => new_instance.private_addresses,
        :state => new_instance.state,
      )
    end

  end
end
