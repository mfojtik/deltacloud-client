require_relative '../test_helper'

describe Deltacloud::Client::StorageVolume do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #blobs' do
    b = @client.bucket('bucket1')
    b.must_respond_to :blobs
    b.blobs.wont_be_empty
    b.blobs.first.must_be_instance_of Deltacloud::Client::Blob
  end


end
