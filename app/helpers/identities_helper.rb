module IdentitiesHelper
  
  def link_to_identity
    link_to "Identiteit", identity_url, :class => "identity #{'selected' if controller.controller_name == 'identities' }" if can? :show, Identity
  end
  
end
