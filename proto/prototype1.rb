require 'faraday'
require 'nokogiri'
require 'pry'
require 'ostruct'

require_relative './../lib/deltacloud/client'

API_URL = 'http://localhost:3002/api'

client = Deltacloud::Client(API_URL, 'mockuser', 'mockpassword')

c = client.use(:mock, 'mockuser', 'mockpassword', 'us')

binding.pry

#p mock_client.version
#p mock_client.current_driver
#p mock_client.current_provider
#p mock_client.supported_collections

#p mock_client.instances
#p mock_client.instance('inst1')

#mock_client.create_instance('img1', :hwp_id => 'm1-xlarge')
#mock_client.reboot_instance('inst1')
#mock_client.destroy_instance('inst1')
