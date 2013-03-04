require_relative '../test_helper'

describe Deltacloud::Client::Methods::Instance do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #instances' do
    @client.must_respond_to :instances
    @client.instances.must_be_kind_of Array
    @client.instances.each { |r| r.must_be_instance_of Deltacloud::Client::Instance }
  end

  it 'supports filtering #instances by :id param' do
    result = @client.instances(:id => 'inst1')
    result.must_be_kind_of Array
    result.size.must_equal 1
    result.first.must_be_instance_of Deltacloud::Client::Instance
    result = @client.instances(:id => 'unknown')
    result.must_be_kind_of Array
    result.size.must_equal 0
  end

  it 'support #instance' do
    @client.must_respond_to :instance
    result = @client.instance('inst1')
    result.must_be_instance_of Deltacloud::Client::Instance
    lambda { @client.instance(nil) }.must_raise Deltacloud::Client::NotFound
    lambda { @client.instance('foo') }.must_raise Deltacloud::Client::NotFound
  end

end
