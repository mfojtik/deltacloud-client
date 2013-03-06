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

      if hwp_id = create_instance_opts[:hwp_id]
        raise error(:incompatible_hardware_profile).new(
          "Profile '#{hwp_id}' is not compatible with this image."
        ) unless is_compatible?(hwp_id)
      end

      @client.create_instance(self._id, create_instance_opts)
    end

    def self.parse(xml_body)
      {
        :owner_id =>        xml_body.text_at(:owner_id),
        :architecture =>    xml_body.text_at(:architecture),
        :state =>           xml_body.text_at(:state),
        :creation_time =>   xml_body.text_at('creation_time'),
        :root_type =>       xml_body.text_at('root_type'),
        :hardware_profile_ids => xml_body.xpath('hardware_profiles/hardware_profile').map { |h|
          h['id']
        }
      }
    end
  end
end
