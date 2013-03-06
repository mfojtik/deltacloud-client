require_relative '../test_helper'

describe Deltacloud::Client::Blob do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #bucket' do
    blob = @client.blob('bucket1', 'blob1')
    blob.bucket.must_be_instance_of Deltacloud::Client::Bucket
    blob.bucket._id.must_equal 'bucket1'
  end

  it 'support #[] on Provider' do
    drv = @client.driver(:ec2)
    drv['eu-west-1']['s3'].wont_be_empty
  end

end
