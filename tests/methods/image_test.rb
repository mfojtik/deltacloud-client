require_relative '../test_helper'

describe Deltacloud::Client::Methods::Image do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #images' do
    @client.must_respond_to :images
    @client.images.must_be_kind_of Array
    @client.images.each { |r| r.must_be_instance_of Deltacloud::Client::Image }
  end

  it 'supports filtering #images by :id param' do
    result = @client.images(:id => 'img1')
    result.must_be_kind_of Array
    result.size.must_equal 1
    result.first.must_be_instance_of Deltacloud::Client::Image
    result = @client.images(:id => 'unknown')
    result.must_be_kind_of Array
    result.size.must_equal 0
  end

  it 'support #image' do
    @client.must_respond_to :image
    result = @client.image('img1')
    result.must_be_instance_of Deltacloud::Client::Image
    lambda { @client.image(nil) }.must_raise Deltacloud::Client::NotFound
    lambda { @client.image('foo') }.must_raise Deltacloud::Client::NotFound
  end

  it 'support #create_image and #destroy_image' do
    @client.must_respond_to :create_image
    img = @client.create_image('inst1', :name => 'test')
    img.must_be_instance_of Deltacloud::Client::Image
    img.name.must_equal 'test'
    @client.destroy_image(img._id)
    lambda {
      @client.create_image(nil, :name => 'test')
    }.must_raise Deltacloud::Client::ServerError
  end

end
