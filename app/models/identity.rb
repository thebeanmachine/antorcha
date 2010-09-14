class Identity < ActiveRecord::Base
  include CrossAssociatedModel

  belongs_to_record :organization

  validates_presence_of :organization, :private_key
  validate :verification_of_private_key
  validate :only_one_identity

private

  def verification_of_private_key
    return if private_key.blank?
    
    begin
      pkey = OpenSSL::PKey::RSA.new(private_key)
      errors.add :private_key, 'is niet de privésleutel voor het certificaat van de organisatie.' unless organization.certificate.check_private_key(pkey)
    rescue OpenSSL::PKey::RSAError
      errors.add :private_key, 'is geen geldige RSA-sleutel'
    end
  end

  def only_one_identity
    errors.add_to_base 'Een antorcha kan enkel een identiteit hebben.' unless Identity.count == 0
  end

end

