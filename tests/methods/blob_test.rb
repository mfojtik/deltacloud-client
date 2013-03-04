require_relative '../test_helper'

describe Deltacloud::Client::Methods::Blob do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #blobs' do
    @client.must_respond_to :blobs
    @client.blobs('bucket1').must_be_kind_of Array
    @client.blobs('bucket1').each { |r| r.must_be_instance_of Deltacloud::Client::Blob }
  end

  it 'support #blob' do
    @client.must_respond_to :blob
    result = @client.blob('bucket1', 'blob1')
    result.must_be_instance_of Deltacloud::Client::Blob
    lambda { @client.blob('bucket1', 'foo') }.must_raise Deltacloud::Client::NotFound
  end

end
