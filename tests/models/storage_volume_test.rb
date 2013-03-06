require_relative '../test_helper'

describe Deltacloud::Client::StorageVolume do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #attached?' do
    vol = @client.storage_volume('vol1')
    vol.attached?.must_equal false
    vol.attach('inst1')
    vol.attached?.must_equal true
  end

  it 'supports #snapshot!' do
    vol = @client.storage_volume('vol1')
    vol.snapshot!.must_be_instance_of Deltacloud::Client::StorageSnapshot
  end

end
