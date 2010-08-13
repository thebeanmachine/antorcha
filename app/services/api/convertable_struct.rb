
module Api
  class ConvertableStruct < ActionWebService::Struct
  
    def initialize hash_or_model={}
      if hash_or_model.is_a?(Hash)
        super hash_or_model
      else
        super(common_attributes(hash_or_model.attributes))
      end
    end
    
    def == other
      return false unless other.is_a? self.class
      self.class.members.keys.inject true do |memo, key|
        memo && self[key] == other[key]
      end
    end
    
    def attributes= hash
      common_attributes(hash).each {|k,v| self.send("#{k}=", v)}
    end

    
    def attributes
      self.class.members.keys.inject({}) {|memo, key| memo[key.to_sym] = self[key]; memo}
    end
    
  private
    def common_attributes hash
      hash.symbolize_keys.slice(*self.class.members.keys.collect(&:to_sym))
    end
  end
end
