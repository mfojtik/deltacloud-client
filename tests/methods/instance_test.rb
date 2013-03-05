require_relative '../test_helper'

describe Deltacloud::Client::Methods::Instance do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
    @created_instances = []
  end

  after do
    VCR.eject_cassette
    VCR.use_cassette('instances_cleanup') do
      cleanup_instances(@created_instances)
    end
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

  it 'support #create_instance' do
    @client.must_respond_to :create_instance
    inst = @client.create_instance('img1')
    inst.must_be_instance_of Deltacloud::Client::Instance
    inst.image_id.must_equal 'img1'
    @created_instances << inst
  end

  it 'support #create_instance with hwp_id' do
    @client.must_respond_to :create_instance
    inst = @client.create_instance('img1', :hwp_id => 'm1-large')
    inst.must_be_instance_of Deltacloud::Client::Instance
    inst.image_id.must_equal 'img1'
    inst.hardware_profile_id.must_equal 'm1-large'
    @created_instances << inst
  end

  it 'support #create_instance with realm_id' do
    @client.must_respond_to :create_instance
    inst = @client.create_instance('img1', :realm_id => 'eu')
    inst.must_be_instance_of Deltacloud::Client::Instance
    inst.realm_id.must_equal 'eu'
    @created_instances << inst
  end

  it 'support #create_instance with name' do
    @client.must_respond_to :create_instance
    inst = @client.create_instance('img1', :realm_id => 'eu', :name => 'test_instance')
    inst.must_be_instance_of Deltacloud::Client::Instance
    inst.name.must_equal 'test_instance'
    inst.realm_id.must_equal 'eu'
    @created_instances << inst
  end

  it 'support #stop_instance' do
    @client.must_respond_to :stop_instance
    inst = @client.create_instance('img1')
    inst.must_be_instance_of Deltacloud::Client::Instance
    inst = @client.stop_instance(inst._id)
    inst.state.must_equal 'STOPPED'
    @created_instances << inst
  end

  it 'support #start_instance' do
    @client.must_respond_to :start_instance
    inst = @client.create_instance('img1')
    inst.must_be_instance_of Deltacloud::Client::Instance
    inst = @client.stop_instance(inst._id)
    inst.state.must_equal 'STOPPED'
    inst = inst.start_instance(inst._id)
    inst.state.must_equal 'RUNNING'
    @created_instances << inst
  end

  it 'support #reboot_instance' do
    @client.must_respond_to :reboot_instance
    inst = @client.create_instance('img1')
    inst.must_be_instance_of Deltacloud::Client::Instance
    inst = @client.reboot_instance(inst._id)
    inst.state.must_equal 'RUNNING'
    @created_instances << inst
  end

end
