module Deltacloud::Client
  class InstanceAddress < OpenStruct
    attr_reader :type
    attr_reader :value

    def to_s; @value; end

    def self.convert(address_xml_block)
      address_xml_block.map do |addr|
        new(
          :type => addr['type'],
          :value => addr.text
        )
      end
    end
  end
end
