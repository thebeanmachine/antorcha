
module SwiftRecord
  module HasManySiblings
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      def has_many_siblings name, source_destination
        model_name = name.to_s
        models_name = name.to_s.pluralize
        model_class = model_name.classify
        
        source_name = source_destination.keys.first.to_s
        sources_name = source_name.pluralize
        destination_name = source_destination.values.first.to_s
        destinations_name = destination_name.pluralize
        source_collection_name = "#{source_name}_#{models_name}"
        destination_collection_name = "#{destination_name}_#{models_name}"

        has_many source_collection_name.to_sym, :class_name => model_class, :foreign_key => "#{destination_name}_id"
        has_many destination_collection_name.to_sym, :class_name => model_class, :foreign_key => "#{source_name}_id"

        has_many sources_name.to_sym, :through => source_collection_name.to_sym, :source => source_name.to_sym
        has_many destinations_name.to_sym, :through => destination_collection_name.to_sym, :source => destination_name.to_sym
      end
    end
  end
end


#has_many :cause_reactions, :class_name => 'Reaction', :foreign_key => 'cause_id'
#has_many :effect_reactions, :class_name => 'Reaction', :foreign_key => 'effect_id'

#has_many :causes, :through => :cause_reactions, :source => :effect
#has_many :effects, :through => :effect_reactions, :source => :cause

