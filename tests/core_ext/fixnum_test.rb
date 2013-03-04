require_relative '../test_helper'

describe Fixnum do

  it 'support #is_redirect?' do
    300.must_respond_to :"is_redirect?"
    300.is_redirect?.must_equal true
    310.is_redirect?.must_equal true
    399.is_redirect?.must_equal true
    510.is_redirect?.must_equal false
  end

  it 'support #is_ok?' do
    200.must_respond_to :"is_ok?"
    200.is_ok?.must_equal true
    210.is_ok?.must_equal true
    299.is_ok?.must_equal true
    510.is_ok?.must_equal false
  end
end
