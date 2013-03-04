module Deltacloud::Client
  class Realm < Base

    attr_reader :limit
    attr_reader :state

    def self.parse(xml_body)
      {
        :state => xml_body.text_at('state'),
        :limit => xml_body.text_at('limit')
      }
    end
  end
end
