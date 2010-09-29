
module CertificateVerification

  #
  # Verifies certificates.
  #
  # Be sure to:
  # - have the received certificate under #certificate method
  # - have the claimed organization id in #organization method

  def verified_organization_certificate?
    return true unless Rails.env.production?
    registered_certificate == received_certificate
  end

  def registered_certificate
    organization.certificate.certificate
  end

  def received_certificate
    OpenSSL::X509::Certificate.new(certificate)
  end
end


class OpenSSL::X509::Certificate
  def == c
    subject.eql? c.subject and
    public_key.to_s == c.public_key.to_s
  end
end
