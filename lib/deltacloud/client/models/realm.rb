module Deltacloud::Client
  class Realm < Base

    attr_reader :limit
    attr_reader :state

    def self.parse(r)
      {
        :state =>               text_at(r, 'state'),
        :limit =>               text_at(r, 'limit')
      }
    end
  end
end
