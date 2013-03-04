require_relative '../test_helper'

describe String do

  it 'support #to_xml' do
    "".must_respond_to :to_xml
    "<root></root>".to_xml.must_be_kind_of Nokogiri::XML::Document
    "<root></root>".to_xml.root.must_be_kind_of Nokogiri::XML::Element
    "<root></root>".to_xml.root.name.must_equal 'root'
  end

  it 'support #camelize' do
    "".must_respond_to :camelize
    "test".camelize.must_equal 'Test'
    "foo_bar".camelize.must_equal 'FooBar'
  end

  it 'support #pluralize' do
    ''.must_respond_to :pluralize
    "test".pluralize.must_equal 'tests'
    "address".pluralize.must_equal 'addresses'
    "entity".pluralize.must_equal 'entities'
  end

  it 'support #singularize' do
    ''.must_respond_to :singularize
    'tests'.singularize.must_equal 'test'
    'addresses'.singularize.must_equal 'address'
    'entity'.singularize.must_equal 'entity'
  end

end
