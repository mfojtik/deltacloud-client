require_relative '../test_helper'

describe Deltacloud::Client::Methods::Driver do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #drivers' do
    @client.must_respond_to :drivers
    @client.drivers.must_be_kind_of Array
    @client.drivers.each { |r| r.must_be_instance_of Deltacloud::Client::Driver }
  end

  it 'supports #driver' do
    @client.must_respond_to :driver
    result = @client.driver('ec2')
    result.must_be_instance_of Deltacloud::Client::Driver
    lambda { @client.driver(nil) }.must_raise Deltacloud::Client::NotFound
    lambda { @client.driver('foo') }.must_raise Deltacloud::Client::NotFound
  end

  it 'supports #providers' do
    @client.must_respond_to :providers
    @client.providers.must_be_empty
  end

end
