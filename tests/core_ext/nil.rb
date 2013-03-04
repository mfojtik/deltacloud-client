require_relative '../test_helper'

describe Nil do

  it 'support #to_xml' do
    nil.must_respond_to :to_xml
    lambda {
      nil.to_xml
    }.must_raise Deltacloud::Client::InvalidXMLError
  end

end
