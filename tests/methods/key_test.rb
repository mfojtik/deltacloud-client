require_relative '../test_helper'

describe Deltacloud::Client::Methods::Key do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #keys' do
    @client.must_respond_to :keys
    @client.keys.must_be_kind_of Array
    @client.keys.each { |r| r.must_be_instance_of Deltacloud::Client::Key }
  end

  it 'supports filtering #keys by :id param' do
    result = @client.keys(:id => 'test-key')
    result.must_be_kind_of Array
    result.size.must_equal 1
    result.first.must_be_instance_of Deltacloud::Client::Key
    result = @client.keys(:id => 'unknown')
    result.must_be_kind_of Array
    result.size.must_equal 0
  end

  it 'support #key' do
    @client.must_respond_to :key
    result = @client.key('test-key')
    result.must_be_instance_of Deltacloud::Client::Key
    lambda { @client.key(nil) }.must_raise Deltacloud::Client::NotFound
    lambda { @client.key('foo') }.must_raise Deltacloud::Client::NotFound
  end

end
