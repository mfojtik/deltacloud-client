module Deltacloud::Client
  class InstanceAddress

    attr_reader :type, :value

    def initialize(type, value)
      @type = type
      @value = value
    end

    def [](attr)
      instance_variable_get("@#{attr}")
    end

    def to_s
      @value
    end

    def self.convert(address_xml_block)
      address_xml_block.map do |addr|
        new(addr['type'].to_sym, addr.text)
      end
    end
  end
end
