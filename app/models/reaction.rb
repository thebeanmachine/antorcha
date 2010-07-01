class Reaction < ActiveRecord::Base
  belongs_to :cause, :class_name => 'Step'
  belongs_to :effect, :class_name => 'Step'

  delegate :title, :to => :cause, :prefix => true 
end
