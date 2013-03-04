require_relative '../test_helper'

describe Deltacloud::Client::Connection do

  before do
    VCR.insert_cassette(__name__)
  end

  after do
    VCR.eject_cassette
  end

  it 'connects to Deltacloud API' do
    client = new_client
    client.connection.wont_be_nil
    client.connection.must_be_kind_of Faraday::Connection
    client.version.wont_be_nil
  end

  it 'supports #version' do
    client = new_client
    client.must_respond_to :version
    client.version.wont_be_nil
    client.version.wont_be_empty
  end

  it 'caches the API entrypoint' do
    client = new_client
    client.cache_entrypoint!.wont_be_nil
  end

  it 'supports #valid_credentials?' do
    client = new_client
    client.must_respond_to :"valid_credentials?"
    client.valid_credentials?.must_equal true
    client = Deltacloud::Client(DELTACLOUD_URL, 'foo', 'bar')
    client.valid_credentials?.must_equal false
  end

  it 'supports switching drivers per instance' do
    client = new_client
    client.current_driver.must_equal 'mock'
    ec2_client = client.use(:ec2, 'foo', 'bar')
    ec2_client.current_driver.must_equal 'ec2'
    client.current_driver.must_equal 'mock'
  end

  it 'supports switching providers per instance' do
    client = new_client
    ec2_client = client.use(:ec2, 'foo', 'bar', 'eu-west-1')
    ec2_client.current_provider.must_equal 'eu-west-1'
    ec2_client = client.use(:ec2, 'foo', 'bar', 'us-east-1')
    ec2_client.current_provider.must_equal 'us-east-1'
  end

  it 'support switching provider without credentials' do
    client = new_client.use(:ec2, 'foo', 'bar', 'eu-west-1')
    new_provider = client.use_provider('us-east-1')
    new_provider.current_provider.must_equal 'us-east-1'
  end

end
