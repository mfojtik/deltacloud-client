require 'bundler'

Bundler.setup(:default, :development)
Bundler.require(:default, :development)

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.command_name 'tests:units'
  SimpleCov.start do
    add_group "Models", "lib/deltacloud/client/models"
    add_group "Methods", "lib/deltacloud/client/methods"
    add_group "Helpers", "lib/deltacloud/client/helpers"
    add_group "Extensions", "lib/deltacloud/core_ext"
    add_filter "tests/"
  end
end

ENV['TEST_ENV'] = 'true'

require 'minitest/autorun'
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

require_relative './../lib/deltacloud/client'

def new_client
  Deltacloud::Client(DELTACLOUD_URL, DELTACLOUD_USER, DELTACLOUD_PASSWORD)
end
