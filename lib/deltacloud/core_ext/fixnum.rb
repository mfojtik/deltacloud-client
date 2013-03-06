class Fixnum

  def is_redirect?
    (self.to_s =~ /^3(\d+)$/) ? true : false
  end

  def is_ok?
    (self.to_s =~ /^2(\d+)$/) ? true : false
  end

  def is_no_content?
    self == 204
  end

end
