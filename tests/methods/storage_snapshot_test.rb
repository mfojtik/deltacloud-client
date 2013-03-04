require_relative '../test_helper'

describe Deltacloud::Client::Methods::StorageSnapshot do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #storage_snapshots' do
    @client.must_respond_to :storage_snapshots
    @client.storage_snapshots.must_be_kind_of Array
    @client.storage_snapshots.each { |r| r.must_be_instance_of Deltacloud::Client::StorageSnapshot }
  end

  it 'supports filtering #storage_snapshots by :id param' do
    result = @client.storage_snapshots(:id => 'snap1')
    result.must_be_kind_of Array
    result.size.must_equal 1
    result.first.must_be_instance_of Deltacloud::Client::StorageSnapshot
    result = @client.storage_snapshots(:id => 'unknown')
    result.must_be_kind_of Array
    result.size.must_equal 0
  end

  it 'support #storage_snapshot' do
    @client.must_respond_to :storage_snapshot
    result = @client.storage_snapshot('snap1')
    result.must_be_instance_of Deltacloud::Client::StorageSnapshot
    lambda { @client.storage_snapshot(nil) }.must_raise Deltacloud::Client::NotFound
    lambda { @client.storage_snapshot('foo') }.must_raise Deltacloud::Client::NotFound
  end

end
