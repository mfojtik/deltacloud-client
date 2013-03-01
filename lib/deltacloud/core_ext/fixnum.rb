class Fixnum

  def is_redirect?
    self.to_s =~ /^3(\d+)$/
  end

  def is_ok?
    self.to_s =~ /^2(\d+)$/
  end

end
