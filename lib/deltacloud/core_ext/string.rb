class String

  def to_xml
    begin
      Nokogiri::XML(self)
    rescue => e
      raise Deltacloud::Client::InvalidXMLError.new(e.message)
    end
  end

  def camelize
    split('_').map { |w| w.capitalize }.join
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
