
module Antorcha
  class DefinitionBuilder < Struct.new(:title)
    def build &block
      #puts "Building definition #{title}"

      @definition = Definition.find_by_title title
      @definition = Definition.create :title => title unless @definition
      
      block.call self
      unless @definition.save
        raise "#{@definition.errors.full_messages}"
      end
    end
    
    def role title
      unless @definition.roles.exists? :title => title.to_s
        @definition.roles.create :title => title.to_s
      end
    end
    
    def step title, &block
      builder = StepBuilder.new(@definition, title)
      builder.build &block
    end
    
  end
  
  class StepBuilder < Struct.new(:definition, :title)
    def build &block
      #puts "Building step #{title} for #{definition.title}"
      
      @step = definition.steps.find_by_title title
      @step = definition.steps.create :title => title unless @step
      
      block.call self
      unless @step.save
        raise "#{@step.errors.full_messages}"
      end
    end
    
    def start
      @step.start = true
    end
    
    def follows *steps
      steps.each do |cause|
        @step.causes << definition.steps.find_by_title!(cause)
      end
    end

    def permits *roles
      roles.each do |role|
        @step.permission_roles << definition.roles.find_by_title!(role)
      end
    end

    def recipients *roles
      roles.each do |role|
        @step.recipient_roles << definition.roles.find_by_title!(role)
      end
    end

  end
end
