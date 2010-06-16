class Step < ActiveRecord::Base
  validates_presence_of :title

  named_scope :to_start_with, :conditions => {:start => true}
end
