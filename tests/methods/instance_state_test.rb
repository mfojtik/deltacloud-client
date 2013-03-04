require_relative '../test_helper'

describe Deltacloud::Client::Methods::InstanceState do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #instance_states' do
    @client.must_respond_to :instance_states
    @client.instance_states.must_be_kind_of Array
    @client.instance_states.each { |r| r.must_be_instance_of Deltacloud::Client::InstanceState::State }
  end

  it 'support #instance_state' do
    @client.must_respond_to :instance_state
    result = @client.instance_state('start')
    result.must_be_instance_of Deltacloud::Client::InstanceState::State
    @client.instance_state(nil).must_be_nil
    @client.instance_state('foo').must_be_nil
  end

end
