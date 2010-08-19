
module SwiftHelper
  module HelpLinkTo
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      def help_link_to model, with = 'model.title'
        models = model.to_s.pluralize
        model_class = model.to_s.classify.constantize
        self.class_eval <<-RUBY
          def link_to_#{model}(model)
            link_to h(#{with}), model, :class => '#{model}'
          end
    
          def link_to_#{models}
            link_to h("#{model_class.human_name(:count => 10)}"), #{models}_path, :class => '#{models}'
          end

          def link_to_edit_#{model}(model)
            link_to h(t('action.edit', :model => '#{model_class.human_name}')), edit_#{model}_path(model), :class => '#{model}'
          end

          def link_to_new_#{model}
            link_to h(t('action.new', :model => '#{model_class.human_name}')), new_#{model}_path, :class => '#{model}'
          end
          
          def button_to_destroy_#{model}(model)
            button_to h(t('action.destroy', :model => '#{model_class.human_name}')), #{model}_path(model), :class => '#{model}', :method => :delete, :confirm => 'Weet u dit zeker?'
          end
         

        RUBY
      end


      def help_can_link_to model, with = 'model.title'
        models = model.to_s.pluralize
        model_class = model.to_s.classify.constantize
        self.class_eval <<-RUBY
          def link_to_#{model}(model)
            if can? :show, #{model.to_s.classify.constantize}
              link_to h(#{with}), model, :class => '#{model}'
            end
          end
    
          def link_to_#{models}
            if can? :index, #{model.to_s.classify.constantize}
              link_to h("#{model_class.human_name(:count => 10)}"), #{models}_path,
                :class => "#{models} \#{'selected' if controller.controller_name == '#{models}' }"
            end
          end

          def link_to_edit_#{model}(model)
            if can? :edit, model
              link_to h(t('action.edit', :model => '#{model_class.human_name}')), edit_#{model}_path(model), :class => '#{model}'
            end
          end

          def link_to_new_#{model}
            if can? :new, #{model.to_s.classify.constantize}
              link_to h(t('action.new', :model => '#{model_class.human_name}')), new_#{model}_path, :class => '#{model}'
            end
          end
          
          def button_to_destroy_#{model}(model)
            if can? :destroy, model
              button_to h(t('action.destroy', :model => '#{model_class.human_name}')), #{model}_path(model), :class => '#{model}', :method => :delete, :confirm => 'Are you sure?'
            end
          end
        RUBY
      end

    end
  end
end

