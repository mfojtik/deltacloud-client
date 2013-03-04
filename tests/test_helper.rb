require 'bundler'

Bundler.setup(:default, :development)
Bundler.require(:default, :development)

ENV['TEST_ENV'] = 'true'

require 'minitest/autorun'
require_relative './../lib/deltacloud/client'

require 'vcr'
#
# Change this at will
#
DELTACLOUD_URL = ENV['API_URL'] || 'http://localhost:3001/api'
DELTACLOUD_USER = 'mockuser'
DELTACLOUD_PASSWORD = 'mockpassword'

VCR.configure do |c|
  c.hook_into :faraday
  c.default_cassette_options = { :serialize_with => :syck }
  c.cassette_library_dir = File.join(File.dirname(__FILE__), 'fixtures')
  c.default_cassette_options = { :record => :new_episodes }
end

def new_client
  Deltacloud::Client(DELTACLOUD_URL, DELTACLOUD_USER, DELTACLOUD_PASSWORD)
end
