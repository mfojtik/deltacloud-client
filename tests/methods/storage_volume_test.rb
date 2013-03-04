require_relative '../test_helper'

describe Deltacloud::Client::Methods::StorageVolume do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #storage_volumes' do
    @client.must_respond_to :storage_volumes
    @client.storage_volumes.must_be_kind_of Array
    @client.storage_volumes.each { |r| r.must_be_instance_of Deltacloud::Client::StorageVolume }
  end

  it 'supports filtering #storage_volumes by :id param' do
    result = @client.storage_volumes(:id => 'vol1')
    result.must_be_kind_of Array
    result.size.must_equal 1
    result.first.must_be_instance_of Deltacloud::Client::StorageVolume
    result = @client.storage_volumes(:id => 'unknown')
    result.must_be_kind_of Array
    result.size.must_equal 0
  end

  it 'support #storage_volume' do
    @client.must_respond_to :storage_volume
    result = @client.storage_volume('vol1')
    result.must_be_instance_of Deltacloud::Client::StorageVolume
    lambda { @client.storage_volume(nil) }.must_raise Deltacloud::Client::NotFound
    lambda { @client.storage_volume('foo') }.must_raise Deltacloud::Client::NotFound
  end

end
