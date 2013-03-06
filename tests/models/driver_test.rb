require_relative '../test_helper'

describe Deltacloud::Client::Driver do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #[] to get providers' do
    @client.driver(:ec2).must_respond_to '[]'
    @client.driver(:ec2)['eu-west-1'].wont_be_nil
    @client.driver(:ec2)['eu-west-1'].must_be_instance_of Deltacloud::Client::Driver::Provider
    @client.driver(:ec2)['eu-west-1'].entrypoints.wont_be_empty
    @client.driver(:ec2)['foo'].must_be_nil
  end

  it 'support #[] on Provider' do
    drv = @client.driver(:ec2)
    drv['eu-west-1']['s3'].wont_be_empty
  end

end
