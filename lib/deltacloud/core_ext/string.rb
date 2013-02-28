class String

  def to_xml
    begin
      Nokogiri::XML(self)
    rescue => e
      raise Deltacloud::Client::InvalidXMLError.new(e.message)
    end
  end

end
