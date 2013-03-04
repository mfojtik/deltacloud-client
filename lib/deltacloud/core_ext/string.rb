class String

  # Used to automagically convert any XML in String
  # (like HTTP response body) to Nokogiri::XML object
  #
  # If Nokogiri::XML fails, InvalidXMLError is returned.
  #
  def to_xml
    Nokogiri::XML(self)
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
