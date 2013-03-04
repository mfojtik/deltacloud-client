require_relative '../test_helper'

describe Deltacloud::Client::Methods::Bucket do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #buckets' do
    @client.must_respond_to :buckets
    @client.buckets.must_be_kind_of Array
    @client.buckets.each { |r| r.must_be_instance_of Deltacloud::Client::Bucket }
  end

  it 'supports filtering #buckets by :id param' do
    result = @client.buckets(:id => 'bucket1')
    result.must_be_kind_of Array
    result.size.must_equal 1
    result.first.must_be_instance_of Deltacloud::Client::Bucket
    result = @client.buckets(:id => 'unknown')
    result.must_be_kind_of Array
    result.size.must_equal 0
  end

  it 'support #bucket' do
    @client.must_respond_to :bucket
    result = @client.bucket('bucket1')
    result.must_be_instance_of Deltacloud::Client::Bucket
    lambda { @client.bucket(nil) }.must_raise Deltacloud::Client::NotFound
    lambda { @client.bucket('foo') }.must_raise Deltacloud::Client::NotFound
  end

end
