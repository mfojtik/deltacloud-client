require_relative '../test_helper'

describe Nokogiri::XML::Element do

  before do
    mock_xml = Nokogiri::XML(
      '<root><test id="1"><inner id="2">VALUE</inner><r></r></test></root>'
    )
    @mock_el = mock_xml.root
  end

  it 'support #text_at' do
    @mock_el.text_at('test/inner').must_equal 'VALUE'
    @mock_el.text_at('test/unknown').must_be_nil
    @mock_el.text_at('test/r').must_equal ''
  end

  it 'support #attr_at' do
    @mock_el.attr_at('test', :id).must_equal '1'
    @mock_el.attr_at('test', 'id').must_equal '1'
    @mock_el.attr_at('test/inner', 'id').must_equal '2'
    @mock_el.attr_at('r', 'id').must_be_nil
  end

end
