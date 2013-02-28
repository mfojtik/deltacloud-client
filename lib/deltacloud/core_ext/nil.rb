class NilClass

  def to_xml
    raise Deltacloud::Client::InvalidXMLError.new('Server returned empty body')
  end

end
