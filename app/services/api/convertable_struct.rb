
module Api
  class ConvertableStruct < ActionWebService::Struct
  
    def initialize hash_or_model={}
      if hash_or_model.is_a?(Hash)
        super hash_or_model
      else
        super hash_or_model.attributes.reject {|k,v|
          not self.class.members.keys.include? k.to_sym
        }
      end
    end
    
    def == other
      return false unless other.is_a? self.class
      self.class.members.keys.inject true do |memo, key|
        memo && self[key] == other[key]
      end
    end
  end
end
