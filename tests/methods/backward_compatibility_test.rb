require_relative '../test_helper'

describe Deltacloud::Client::Methods::BackwardCompatibility do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #api_host' do
    @client.must_respond_to :api_host
    @client.api_host.must_equal 'localhost'
  end

  it 'supports #api_port' do
    @client.must_respond_to :api_port
    @client.api_port.must_equal 3001
  end

  it 'supports #connect' do
    @client.must_respond_to :connect
    @client.connect do |new_client|
      new_client.must_be_instance_of Deltacloud::Client::Connection
    end
  end

  it 'supports #with_config' do
    @client.must_respond_to :with_config
    @client.with_config(:driver => :ec2, :username => 'f', :password => 'b') do |c|
      c.must_be_instance_of Deltacloud::Client::Connection
      c.current_driver.must_equal 'ec2'
      c.request_driver.must_equal :ec2
    end
  end

  it 'supports #use_driver' do
    @client.must_respond_to :use_driver
    @client.use_driver(:ec2, :username => 'f', :password => 'b') do |c|
      c.must_be_instance_of Deltacloud::Client::Connection
      c.current_driver.must_equal 'ec2'
      c.request_driver.must_equal :ec2
    end
  end

  it 'supports #discovered?' do
    @client.must_respond_to :"discovered?"
    @client.discovered?.must_equal true
  end

  it 'supports #valid_credentials? on class' do
    Deltacloud::Client.must_respond_to :"valid_credentials?"
    r = Deltacloud::Client.valid_credentials? DELTACLOUD_USER,
      DELTACLOUD_PASSWORD, DELTACLOUD_URL
    r.must_equal true
    r = Deltacloud::Client.valid_credentials? 'foo',
      DELTACLOUD_PASSWORD, DELTACLOUD_URL
    r.must_equal false
    r = Deltacloud::Client.valid_credentials? 'foo',
      'bar', DELTACLOUD_URL
    r.must_equal false
    lambda {
      Deltacloud::Client.valid_credentials? 'foo',
        'bar', 'http://unknown.local'
    }.must_raise Faraday::Error::ConnectionFailed
  end


end
