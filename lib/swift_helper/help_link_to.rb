
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
        RUBY
      end
    end
    
  end
end

