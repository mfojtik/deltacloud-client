module Deltacloud::Client
  module Helpers
    module XmlHelper

      # Returns Nokogiri::Element attribute value.
      # Returns 'nil' if the Element is nil
      #
      def attr_at(item, xpath, attr)
        (val = item.at(xpath)) ? val[attr.to_s.strip] : nil
      end

      # Returns stripped text of Nokogiri::Element
      # Returns 'nil' if the Element is nil
      #
      def text_at(item, xpath)
        (val = item.at(xpath)) ? val.text.strip : nil
      end

      # Extract XML string from the various objects
      #
      def extract_xml_body(obj)
        case obj
        when Faraday::Response then obj.body
        when Nokogiri::XML::Element then obj.to_s
        else obj
        end
      end
    end
  end
end
