module Deltacloud::Client
  module Helpers
    module XmlHelper

      # Extract XML string from the various objects
      #
      def extract_xml_body(obj)
        case obj
        when Faraday::Response then obj.body
        when Rack::MockResponse then obj.body
        when Nokogiri::XML::Element then obj.to_s
        when Nokogiri::XML::Document then obj.to_s
        else obj
        end
      end

    end
  end
end
