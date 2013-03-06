require_relative '../test_helper'

describe Deltacloud::Client::Image do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #hardware_profiles' do
    img = @client.image('img1')
    img.must_respond_to :hardware_profiles
    img.hardware_profiles.wont_be_empty
    img.hardware_profiles.first.must_be_instance_of Deltacloud::Client::HardwareProfile
  end

  it 'supports #is_compatible?' do
    img = @client.image('img1')
    img.must_respond_to 'is_compatible?'
    img.is_compatible?('m1-small').must_equal true
    img.is_compatible?('m1-large').must_equal true
  end

  it 'supports #lunch_image' do
    img = @client.image('img1')
    img.must_respond_to :launch
    inst = img.launch(:hwp_id => 'm1-large')
    inst.must_be_instance_of Deltacloud::Client::Instance
    inst.hardware_profile_id.must_equal 'm1-large'
    inst.stop!
    inst.destroy!
  end

end
