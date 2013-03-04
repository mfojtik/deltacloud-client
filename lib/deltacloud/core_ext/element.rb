module Nokogiri
  module XML

    class Element

      def text_at(xpath)
        (val = self.at(xpath)) ? val.text.strip : nil
      end

      def attr_at(xpath, attr_name)
        (val = self.at(xpath)) ? val[attr_name.to_s.strip] : nil
      end

    end

  end
end
