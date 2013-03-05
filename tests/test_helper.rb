require 'bundler'

Bundler.setup(:default, :development)
Bundler.require(:default, :development)

require 'require_relative' if RUBY_VERSION < '1.9'

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

require 'minitest/autorun'
#
# Change this at will
#
DELTACLOUD_URL = ENV['API_URL'] || 'http://localhost:3001/api'
DELTACLOUD_USER = 'mockuser'
DELTACLOUD_PASSWORD = 'mockpassword'

def new_client
  Deltacloud::Client(DELTACLOUD_URL, DELTACLOUD_USER, DELTACLOUD_PASSWORD)
end

unless ENV['NO_VCR']
  require 'vcr'
  VCR.configure do |c|
    c.hook_into :faraday
    c.cassette_library_dir = File.join(File.dirname(__FILE__), 'fixtures')
    c.default_cassette_options = { :record => :new_episodes }
  end
end

require_relative './../lib/deltacloud/client'

def cleanup_instances(inst_arr)
  inst_arr.each do |i|
    i.reload!
    i.stop! unless i.is_stopped?
    i.destroy!
  end
end
