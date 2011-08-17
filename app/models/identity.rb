class Identity < ActiveRecord::Base
  include CrossAssociatedModel

  belongs_to_record :organization

  validates_presence_of :organization_id, :private_key
  validate :verification_of_private_key
  validate :only_one_identity

  def self.first!
    identity = Identity.first
    raise "No identity" unless identity
    identity
  end

  def self.certificate
    first!.organization.certificate
  end
  
  def self.private_key
    OpenSSL::PKey::RSA.new(first!.private_key)
  end

private

  def verification_of_private_key
    return if private_key.blank? or organization.blank?

    if organization.certificate.blank?
      errors.add :organization_id, 'heeft geen bijbehorend certificaat voor de opgegeven privésleutel. Vraag een registratie van uw certificaat aan bij de UITWEG Cooperatie.'
    else
      begin
        pkey = OpenSSL::PKey::RSA.new(private_key)
        errors.add :private_key, 'komt niet overeen met de privésleutel voor het geregistreerde certificaat van de organisatie.' unless organization.certificate.check_private_key(pkey)
      rescue OpenSSL::PKey::RSAError
        errors.add :private_key, 'is geen geldige RSA-sleutel'
      end
    end
  end

  def only_one_identity
    errors.add_to_base 'Een Antorcha kan enkel een identiteit hebben.' unless Identity.count == 0
  end

end

