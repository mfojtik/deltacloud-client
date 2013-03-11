module Deltacloud::Client
  module Helpers
    module XmlHelper

      # Extract XML string from the various objects
      #
      def extract_xml_body(obj)
        return obj.body if obj.respond_to?(:body)
        case obj
          when Nokogiri::XML::Element then obj.to_s
          when Nokogiri::XML::Document then obj.to_s
          else obj
        end
      end

    end
  end
end
