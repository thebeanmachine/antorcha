class Step < ActiveRecord::Base
  validates_presence_of :title

  has_many :messages

  named_scope :to_start_with, :conditions => {:start => true}
end
