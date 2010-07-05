module RolesHelper

  def link_to_new_role definition
    if can? :new, Role
      link_to t('action.new', :model => Role.human_name), new_definition_role_path(@definition) 
    end
  end
  
  def button_to_destroy_role role
    if can? :destroy, role
      button_to t('action.destroy', :model => Role.human_name), [role.definition, role],
        :method => :delete, :confirm => t('confirm.destroy')
    end
  end

  def link_to_role role
    link_to h(role.title), [role.definition, role] if can? :show, role
  end
  
end
