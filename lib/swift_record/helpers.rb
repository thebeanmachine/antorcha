
module SwiftRecord
  module Helpers
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      def flagstamp *names
        names.each do |name|
          self.class_eval <<-RUBY
            def #{name}!
              update_attributes(:#{name}_at => Time.zone.now) unless #{name}?
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
      
      def antonym antonyms
        antonyms.each do |antonym, word|
          self.class_eval <<-RUBY
            def #{antonym}
              not #{word}
            end
            def #{antonym}?
              not #{word}?
            end
            def #{antonym}= value
              self.#{word} = !value
            end
          RUBY
        end
      end
    end
  end
end
