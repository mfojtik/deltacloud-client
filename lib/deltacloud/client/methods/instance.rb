module Deltacloud::Client
  module Methods
    module Instance

      # Retrieve list of all instances
      #
      # Filter options:
      #
      # - :id -> Filter instances using their 'id'
      # - :state -> Filter instances by their 'state'
      # - :realm_id -> Filter instances based on their 'realm_id'
      #
      def instances(filter_opts={})
        must_support! :instances
        model.from_collection(self, connection.get("#{path}/instances", filter_opts))
      end

      # Retrieve the given instance
      #
      # - instance_id -> Instance to retrieve
      #
      def instance(instance_id)
        must_support! :instances
        model.convert(self, connection.get("#{path}/instances/#{instance_id}"))
      end

      # Create a new instance
      #
      # - image_id ->    Image to use for instance creation (img1, ami-12345, etc...)
      # - create_opts -> Various options that DC support for the current
      #                  provider.
      #
      # Returns created instance, or list of created instances or all instances.
      #
      def create_instance(image_id, create_opts={})
        must_support! :instances
        create_opts.merge!(:image_id => image_id)
        r = connection.post("#{path}/instances") do |request|
          request.params = create_opts
        end
        # If Deltacloud API return only Location (30x), follow it and
        # retrieve created instance from there.
        #
        if r.status.to_s =~ /3(\d+)/
          # If Deltacloud API redirect to list of instances
          # then return list of **all** instances, otherwise
          # grab the instance_id from Location header
          #
          if r.headers['Location'].split('/').last == 'instances'
            return instances
          else
            return instance(r.headers['Location'].split('/').last)
          end
        end
        # If more than 1 instance was created, return list
        #
        if r.body.to_xml.root.name == 'instances'
          return model.from_collection(self, r.body)
        end

        model.convert(self, r)
      end

      # Destroy the current +Instance+
      # Returns 'true' if the response was 204 No Content
      #
      # - instance_id -> The 'id' of the Instance to destroy
      #
      def destroy_instance(instance_id)
        must_support! :instances
        r = connection.delete("#{path}/instances/#{instance_id}")
        r.status == 204
      end

      # Attempt to change the +Instance+ state to STOPPED
      #
      # - instance_id -> The 'id' of the Instance to stop
      #
      def stop_instance(instance_id)
        must_support! :instances
        result = connection.post("#{path}/instances/#{instance_id}/stop")
        if result.status.to_s =~ /20\d/
          model.convert(self, result)
        else
          instance(instance_id)
        end
      end

      # Attempt to change the +Instance+ state to STARTED
      #
      # - instance_id -> The 'id' of the Instance to start
      #
      def start_instance(instance_id)
        must_support! :instances
        result = connection.post("#{path}/instances/#{instance_id}/start")
        if result.status.to_s =~ /20\d/
          model.convert(self, result)
        else
          instance(instance_id)
        end
      end

      # Attempt to reboot the +Instance+
      #
      # - instance_id -> The 'id' of the Instance to reboot
      #
      def reboot_instance(instance_id)
        must_support! :instances
        result = connection.post("#{path}/instances/#{instance_id}/reboot")
        if result.status.to_s =~ /20\d/
          model.convert(self, result)
        else
          instance(instance_id)
        end
      end

      private

      def model
        Deltacloud::Client::Instance
      end

    end
  end
end
