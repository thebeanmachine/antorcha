class Step < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :name, :if => :title
  validates_uniqueness_of :name

  belongs_to :definition
  has_many :messages
  has_many :roles, :through => :recipients

  named_scope :to_start_with, :conditions => {:start => true}

  before_validation :parameterize_title_for_name
  
  delegate :step_roles, :to => :definition

  def parameterize_title_for_name
    self.name = title.parameterize if title
  end    
end
