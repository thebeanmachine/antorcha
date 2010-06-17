class Task < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :name, :if => :title
  validates_uniqueness_of :name
  
  before_validation :parameterize_title_for_name

  def parameterize_title_for_name
    self.name = title.parameterize if title
  end
end
