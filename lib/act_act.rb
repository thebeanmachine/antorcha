
module ActAct
  
  class Builder < Struct.new( :action, :what, :who )

    def initialize action, what, who
      super action, what, abilitize(who)
    end
  
    def possible?
      who.can?(action, what)
    end

    def impossible?
      who.cannot?(action, what)
    end
  
    def as who
      ActAct.new action, what, abilitize(who)
    end
  
    def abilitize ability_or_model
      ability_or_model = Ability.new(ability_or_model) unless ability_or_model.is_a? Ability
      ability_or_model
    end
  
    def to_s
      "#{action}ing #{what} as #{who}"
    end
  end

  def listing what
    what = what.to_s.singularize.classify.constantize if what.is_a? Symbol
    Builder.new(:index, what, subject)
  end

  def destroying what
    Builder.new(:destroy, what, subject)
  end

  def updating what
    Builder.new(:update, what, subject)
  end

  def creating what
    Builder.new(:create, what, subject)
  end

  def showing what
    Builder.new(:show, what, subject)
  end

end

