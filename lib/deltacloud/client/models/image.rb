module Deltacloud::Client
  class Image < Base

    attr_reader :owner_id, :architecture, :state
    attr_reader :creation_time, :root_type, :hardware_profile_ids

    def self.parse(i)
      {
        :owner_id =>        text_at(i, 'state'),
        :architecture =>    text_at(i, 'architecture'),
        :state =>           text_at(i, 'state'),
        :creation_time =>   text_at(i, 'creation_time'),
        :root_type =>       text_at(i, 'root_type'),
        :hardware_profile_ids => i.xpath('hardware_profiles/hardware_profile').map { |h|
          h['id']
        }
      }
    end
  end
end
