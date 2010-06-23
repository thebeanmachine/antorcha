
module SwiftHelper
  module HelpLinkTo
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      def help_link_to model, with = 'model.title'
        models = model.to_s.pluralize
        self.class_eval <<-RUBY
          def link_to_#{model}(model)
            link_to h(#{with}), model, :class => '#{model}'
          end
    
          def link_to_#{models}
            link_to h("#{models.humanize}"), #{models}_path, :class => '#{models}'
          end

          def link_to_edit_#{model}(model)
            link_to h(t('action.edit', :model => '#{model.to_s.humanize}')), edit_#{model}_path(model), :class => '#{model}'
          end

          def link_to_new_#{model}
            link_to h(t('action.new', :model => '#{model.to_s.humanize}')), new_#{model}_path, :class => '#{model}'
          end
          
          def link_to_destroy_#{model}(model)
            link_to h(t('action.destroy', :model => '#{model.to_s.humanize}')), #{model}_path(model), :class => '#{model}', :method => :delete, :confirm => 'Are you sure?'
          end
         

        RUBY
      end
    end
    
  end
end

