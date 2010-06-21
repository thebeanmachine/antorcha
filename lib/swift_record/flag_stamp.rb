
module SwiftRecord
  module FlagStamp
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      def flagstamp *names
        names.each do |name|
          self.class_eval <<-RUBY
            def #{name}!
              update_attributes(:#{name}_at => Time.now) unless #{name}?
            end
            def #{name}?
              :#{name} if not #{name}_at.nil?
            end
            def #{name}= value
              if value
                #{name}!
              else
                update_attributes(:#{name}_at => nil)
              end
            end
          RUBY
        end
      end
    end
  end
end
