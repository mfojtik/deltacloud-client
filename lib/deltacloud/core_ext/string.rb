class String

  # Used to automagically convert any XML in String
  # (like HTTP response body) to Nokogiri::XML object
  #
  # If Nokogiri::XML fails, InvalidXMLError is returned.
  #
  def to_xml
    begin
      Nokogiri::XML(self)
    rescue => e
      raise Deltacloud::Client::InvalidXMLError.new(e.message)
    end
  end

  def text_at(xpath)
    to_xml.text_at(xpath)
  end

  def attr_at(xpath, attr_name)
    to_xml.attr_at(xpath, attr_name)
  end

  unless method_defined? :camelize
    def camelize
      split('_').map { |w| w.capitalize }.join
    end
  end

  def pluralize
    return self + 'es' if self =~ /ess$/
    return self[0, self.length-1] + "ies" if self =~ /ty$/
    return self if self =~ /data$/
    self + "s"
  end

  def singularize
    return self.gsub(/ies$/, 'y') if self =~ /ies$/
    return self.gsub(/es$/, '') if self =~ /sses$/
    self.gsub(/s$/, '')
  end
end
