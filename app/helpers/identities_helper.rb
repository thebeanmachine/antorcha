module IdentitiesHelper
  
  def link_to_identity
    link_to "Identiteit", identity_url if can? :show, Identity
  end
  
end
