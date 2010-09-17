
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
      
      def cache_and_delegate(*methods)
        options = methods.pop
        unless options.is_a?(Hash) && to = options[:to]
          raise ArgumentError, "Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, :to => :greeter)."
        end

        if options[:prefix] == true && options[:to].to_s =~ /^[^a-z_]/
          raise ArgumentError, "Can only automatically set the delegation prefix when delegating to a method."
        end

        prefix = options[:prefix] && "#{options[:prefix] == true ? to : options[:prefix]}_"

        file, line = caller.first.split(':', 2)
        line = line.to_i

        methods.each do |method|
          on_nil =
            if options[:allow_nil]
              'return'
            else
              %(raise "#{prefix}#{method} delegated to #{to}.#{method}, but #{to} is nil: \#{self.inspect}")
            end

            module_eval(<<-RUBY, file, line)
              def #{prefix}#{method}(*args, &block)               # def customer_name(*args, &block)
                return read_attribute(:#{prefix}#{method}) if #{prefix}#{method}?\n
                value = #{to}.__send__(#{method.inspect}, *args, &block)  #   client.__send__(:name, *args, &block)
                update_attribute :#{prefix}#{method}, value unless new_record?\n
                value
              rescue NoMethodError                                # rescue NoMethodError
                if #{to}.nil?                                     #   if client.nil?
                  #{on_nil}
                else                                              #   else
                  raise                                           #     raise
                end                                               #   end
              end                                                 # end
            RUBY

          # module_eval("
          #   def \#{prefix}\#{method}(*args, &block)\n               # def customer_name(*args, &block)
          #     return read_attribute(:#{prefix}#{method}) if #{prefix}#{method}?\n
          #     r = \#{to}.__send__(\#{method.inspect}, *args, &block)\n  #   client.__send__(:name, *args, &block)
          #     write_attribute :\#{prefix}\#{method}, r\n
          #     return r\n
          #   rescue NoMethodError\n                                  # rescue NoMethodError
          #     if \#{to}.nil?\n                                      #   if client.nil?
          #       \#{on_nil}\n
          #     else\n                                                #   else
          #       raise\n                                             #     raise
          #     end\n                                                 #   end
          #   end\n                                                   # end
          #       
          #   ", file, line)
        end
      end
    end
  end
end
