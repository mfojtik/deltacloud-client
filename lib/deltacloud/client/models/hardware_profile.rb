module Deltacloud::Client
  class HardwareProfile < Base

    include Deltacloud::Client::Helpers

    attr_reader :properties

    def self.parse(hwp)
      {
        :properties => hwp.xpath('property').map { |p| property_klass(p['kind']).parse(p) }
      }
    end

    def cpu
      property :cpu
    end

    def memory
      property :memory
    end

    def architecture
      property :architecture
    end

    def storage
      propery :storage
    end

    def opaque?
      @properties.empty? && @name == 'opaque'
    end

    private

    def property(name)
      @properties.find { |p| p.name == name.to_s }
    end

    def self.property_klass(kind)
      case kind
        when 'enum'   then Property::Enum
        when 'range'  then Property::Range
        when 'fixed'  then Property::Fixed
        when 'opaque' then Property::Property
        else raise error.new("Unknown HWP property: #{kind}")
      end
    end

  end
end
