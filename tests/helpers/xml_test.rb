require_relative '../test_helper'

describe Deltacloud::Client::Helpers::XmlHelper do

  include Deltacloud::Client::Helpers::XmlHelper

  before do
    VCR.insert_cassette(__name__)
  end

  after do
    VCR.eject_cassette
  end

  it 'supports #extract_xml_body using string' do
    extract_xml_body("test").must_be_kind_of String
  end

  it 'supports #extract_xml_body using faraday connection' do
    result = extract_xml_body(new_client.connection.get('/api'))
    result.must_be_kind_of String
    result.wont_be_empty
  end

  it 'supports #extract_xml_body using nokogiri::document' do
    result = extract_xml_body(
      Nokogiri::XML(new_client.connection.get('/api').body)
    )
    result.must_be_kind_of String
    result.wont_be_empty
  end

  it 'supports #extract_xml_body using nokogiri::element' do
    result = extract_xml_body(
      Nokogiri::XML(new_client.connection.get('/api').body).root
    )
    result.must_be_kind_of String
    result.wont_be_empty
  end

end
