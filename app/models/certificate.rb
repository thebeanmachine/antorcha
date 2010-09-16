class Certificate < Resource
  def check_private_key(key)
    certificate.check_private_key(key)
  end
  
  def certificate
    @certificate ||= OpenSSL::X509::Certificate.new(content)
  end
end
