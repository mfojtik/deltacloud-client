require_relative '../test_helper'

describe Deltacloud::Client::Methods::Firewall do

  def new_client
    Deltacloud::Client(DELTACLOUD_URL, 'AKIAJYOQYLLOIWN5LQ3A', 'Ra2ViYaYgocAJqPAQHxMVU/l2sGGU2pifmWT4q3H', :driver => :ec2 )
  end

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #firewalls' do
    @client.must_respond_to :firewalls
    @client.firewalls.must_be_kind_of Array
    @client.firewalls.each { |r| r.must_be_instance_of Deltacloud::Client::Firewall }
  end

  it 'supports filtering #firewalls by :id param' do
    result = @client.firewalls(:id => 'mfojtik')
    result.must_be_kind_of Array
    result.size.must_equal 1
    result.first.must_be_instance_of Deltacloud::Client::Firewall
  end

  it 'support #firewall' do
    @client.must_respond_to :firewall
    result = @client.firewall('mfojtik')
    result.must_be_instance_of Deltacloud::Client::Firewall
    lambda { @client.firewall(nil) }.must_raise Deltacloud::Client::NotFound
    lambda { @client.firewall('foo') }.must_raise Deltacloud::Client::NotFound
  end

  it 'support #create_firewall and #destroy_firewall' do
    @client.must_respond_to :create_firewall
    @client.must_respond_to :destroy_firewall
    lambda {
      @client.create_firewall('foofirewall')
    }.must_raise Deltacloud::Client::ClientFailure
    result = @client.create_firewall('foofirewall', :description => 'testing firewalls')
    result.must_be_instance_of Deltacloud::Client::Firewall
    result.name.must_equal 'foofirewall'
    @client.destroy_firewall(result._id).must_equal true
  end


  # FIXME: TBD, not supported by mock driver yet.
end
