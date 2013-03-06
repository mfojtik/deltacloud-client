require_relative '../test_helper'

describe Deltacloud::Client do

  before do
    VCR.insert_cassette(__name__)
  end

  after do
    VCR.eject_cassette
  end

  it 'support #VERSION' do
    Deltacloud::Client::VERSION.wont_be_nil
  end

  it 'support #Client' do
    Deltacloud.must_respond_to 'Client'
  end

  it 'support to change driver with #Client' do
    client = Deltacloud::Client(
      DELTACLOUD_URL, DELTACLOUD_USER, DELTACLOUD_PASSWORD,
      :driver => :ec2
    )
    client.request_driver.must_equal :ec2
    client.current_driver.must_equal 'ec2'
  end

  it 'support to test of valid DC connection' do
    Deltacloud::Client.must_respond_to 'valid_connection?'
    Deltacloud::Client.valid_connection?(DELTACLOUD_URL).must_equal true
    Deltacloud::Client.valid_connection?('http://unknown:9999').must_equal false
  end

end
