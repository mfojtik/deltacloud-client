require_relative '../test_helper'

describe Deltacloud::Client::Methods::Realm do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #realms' do
    @client.must_respond_to :realms
    @client.realms.must_be_kind_of Array
    @client.realms.each { |r| r.must_be_instance_of Deltacloud::Client::Realm }
  end

  it 'supports filtering #realms by :id' do
    result = @client.realms(:id => 'eu')
    result.must_be_kind_of Array
    result.size.must_equal 1
    result.first.must_be_instance_of Deltacloud::Client::Realm
  end

  it 'support #realm' do
    @client.must_respond_to :realm
    result = @client.realm('eu')
    result.must_be_instance_of Deltacloud::Client::Realm
    lambda { @client.realm(nil) }.must_raise Deltacloud::Client::NotFound
    lambda { @client.realm('foo') }.must_raise Deltacloud::Client::NotFound
  end

end
