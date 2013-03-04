require_relative '../test_helper'

describe Deltacloud::Client::Helpers::Model do

  include Deltacloud::Client::Helpers::Model

  it 'supports #model' do
    model(:error).must_equal Deltacloud::Client::Error
    model('error').must_equal Deltacloud::Client::Error
    lambda { model(nil) }.must_raise Deltacloud::Client::Error
  end

  it 'supports #error' do
    error.must_equal Deltacloud::Client::Error
    error(:not_supported).must_equal Deltacloud::Client::NotSupported
  end

end
