require_relative '../test_helper'

describe Deltacloud::Client::Methods::Address do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #addresses' do
    @client.must_respond_to :addresses
    @client.addresses.must_be_kind_of Array
    @client.addresses.each { |r| r.must_be_instance_of Deltacloud::Client::Address }
  end

  it 'supports filtering #addresses by :id param' do
    result = @client.addresses(:id => '192.168.0.1')
    result.must_be_kind_of Array
    result.size.must_equal 1
    result.first.must_be_instance_of Deltacloud::Client::Address
    result = @client.addresses(:id => 'unknown')
    result.must_be_kind_of Array
    result.size.must_equal 0
  end

  it 'support #address' do
    @client.must_respond_to :address
    result = @client.address('192.168.0.1')
    result.must_be_instance_of Deltacloud::Client::Address
    lambda { @client.address(nil) }.must_raise Deltacloud::Client::NotFound
    lambda { @client.address('foo') }.must_raise Deltacloud::Client::NotFound
  end

end
