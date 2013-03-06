module Deltacloud::Client
  class Instance < Base

    include Deltacloud::Client::Methods::Common
    include Deltacloud::Client::Methods::Instance
    include Deltacloud::Client::Methods::Realm

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

    # Retrieve the +Realm+ associated with Instance
    #
    def realm
      super(realm_id)
    end

    def method_missing(name, *args)
      return self.state.downcase == $1 if name.to_s =~ /^is_(\w+)\?$/
      super
    end

    # Helper for is_STATE?
    #
    # is_running?
    # is_stopped?
    #
    def method_missing(name, *args)
      if name =~ /^is_(\w+)\?$/
        return state == $1.upcase
      end
      super
    end

    class << self

      def parse(xml_body)
        {
          :state =>               xml_body.text_at('state'),
          :owner_id =>            xml_body.text_at('owner_id'),
          :realm_id =>            xml_body.attr_at('realm', :id),
          :image_id =>            xml_body.attr_at('image', :id),
          :hardware_profile_id => xml_body.attr_at('hardware_profile', :id),
          :public_addresses => InstanceAddress.convert(
            xml_body.xpath('public_addresses/address')
          ),
          :private_addresses => InstanceAddress.convert(
            xml_body.xpath('private_addresses/address')
          )
        }
      end

    end

    # Attempt to reload :public_addresses, :private_addresses and :state
    # of the instance, after the instance is modified by calling method
    #
    def reload!
      new_instance = instance(_id)
      update_instance_variables!(
        :public_addresses => new_instance.public_addresses,
        :private_addresses => new_instance.private_addresses,
        :state => new_instance.state
      )
    end

  end
end
