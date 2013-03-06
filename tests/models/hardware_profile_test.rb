require_relative '../test_helper'

describe Deltacloud::Client::HardwareProfile do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'support #cpu' do
    @client.hardware_profile('m1-small').must_respond_to :cpu
    @client.hardware_profile('m1-small').cpu.wont_be_nil
    @client.hardware_profile('m1-small').cpu.must_respond_to :default
    @client.hardware_profile('m1-small').cpu.default.wont_be_empty
    @client.hardware_profile('m1-small').cpu.must_respond_to :kind
    @client.hardware_profile('m1-small').cpu.kind.wont_be_empty
    @client.hardware_profile('m1-small').cpu.must_respond_to :unit
    @client.hardware_profile('m1-small').cpu.unit.wont_be_empty
  end

  it 'support #memory' do
    @client.hardware_profile('m1-small').must_respond_to :memory
    @client.hardware_profile('m1-small').memory.wont_be_nil
    @client.hardware_profile('m1-small').memory.must_respond_to :default
    @client.hardware_profile('m1-small').memory.default.wont_be_empty
    @client.hardware_profile('m1-small').memory.must_respond_to :kind
    @client.hardware_profile('m1-small').memory.kind.wont_be_empty
    @client.hardware_profile('m1-small').memory.must_respond_to :unit
    @client.hardware_profile('m1-small').memory.unit.wont_be_empty
  end

  it 'support #storage' do
    @client.hardware_profile('m1-small').must_respond_to :storage
    @client.hardware_profile('m1-small').storage.wont_be_nil
    @client.hardware_profile('m1-small').storage.must_respond_to :default
    @client.hardware_profile('m1-small').storage.default.wont_be_empty
    @client.hardware_profile('m1-small').storage.must_respond_to :kind
    @client.hardware_profile('m1-small').storage.kind.wont_be_empty
    @client.hardware_profile('m1-small').storage.must_respond_to :unit
    @client.hardware_profile('m1-small').storage.unit.wont_be_empty
  end

  it 'support #architecture' do
    @client.hardware_profile('m1-small').must_respond_to :architecture
    @client.hardware_profile('m1-small').architecture.wont_be_nil
    @client.hardware_profile('m1-small').architecture.must_respond_to :default
    @client.hardware_profile('m1-small').architecture.default.wont_be_empty
    @client.hardware_profile('m1-small').architecture.must_respond_to :kind
    @client.hardware_profile('m1-small').architecture.kind.wont_be_empty
    @client.hardware_profile('m1-small').architecture.must_respond_to :unit
    @client.hardware_profile('m1-small').architecture.unit.wont_be_empty
  end

  it 'support #opaque?' do
    @client.hardware_profile('opaque').opaque?.must_equal true
    @client.hardware_profile('m1-small').opaque?.must_equal false
  end



end
