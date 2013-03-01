module Deltacloud::Client
  class Image < Base

    attr_reader :owner_id, :architecture, :state
    attr_reader :creation_time, :root_type, :hardware_profile_ids

    def hardware_profiles
      @client.hardware_profiles.select { |hwp| @hardware_profile_ids.include?(hwp._id) }
    end

    def is_compatible?(hardware_profile_id)
      hardware_profile_ids.include? hardware_profile_id
    end

    # Launch the image using +Instance+#+create_instance+ method.
    # This method is more strict in checking +HardwareProfile+
    # and in case you use incompatible HWP it raise an error.
    #
    # - create_instance_opts -> +create_instance+ options
    #
    def launch(create_instance_opts={})

      if hwp_id = create_instance_opts.delete(:hwp_id)
        raise Deltacloud::Client::IncompatibleHardwareProfile.new(
          "Profile '#{hwp_id}' is not compatible with this image."
        ) unless is_compatible?(hwp_id)
      end

      @client.create_instance(self._id, create_instance_opts)
    end

    def self.parse(i)
      {
        :owner_id =>        text_at(i, 'state'),
        :architecture =>    text_at(i, 'architecture'),
        :state =>           text_at(i, 'state'),
        :creation_time =>   text_at(i, 'creation_time'),
        :root_type =>       text_at(i, 'root_type'),
        :hardware_profile_ids => i.xpath('hardware_profiles/hardware_profile').map { |h|
          h['id']
        }
      }
    end
  end
end
