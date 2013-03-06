module Deltacloud::Client
  module Helpers
    module Property

      class Property
        attr_reader :name, :unit, :default

        def initialize(name, unit, default=nil)
          @name = name
          @unit = unit
          @default = default
        end

        def value
          @default || 'opaque'
        end

        def self.parse(body)
          Property.new(body['name'], body['unit'], body['value'])
        end

        def kind
          self.class.name.split('::').last.downcase.to_sym
        end

      end

      class Range < Property

        attr_reader :first, :last

        def initialize(name, unit, first, last, default=nil)
          @first, @last = first, last
          super(name, unit, default)
        end

        def value
          ::Range.new(@first.to_i, @last.to_i)
        end

        def self.parse(body)
          base = super
          new(base.name, base.unit, body.at('range')['first'], body.at('range')['last'], base.default)
        end

      end

      class Enum < Property
        include Enumerable
        attr_reader :values

        def initialize(name, unit, values, default=nil)
          @values = values
          super(name, unit, default)
        end

        def value
          @values
        end

        def each
          value.each
        end

        def self.parse(body)
          base = super
          new(base.name, base.unit, body.xpath('enum/entry').map { |e| e['value'] }, base.default)
        end
      end

      class Fixed < Property
        attr_reader :value

        def initialize(name, unit, value)
          @value = value
          super(name, unit, @value)
        end

        def self.parse(body)
          base = super
          new(base.name, base.unit, body['value'])
        end

      end

    end
  end
end
