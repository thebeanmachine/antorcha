class Step < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :name, :if => :title
  validates_uniqueness_of :name

  belongs_to :definition
  has_many :messages
  has_many :roles, :through => :recipients
  
  has_many_siblings :reaction, :cause => :effect

  has_many :permissions
  has_many :roles, :through => :permissions


  named_scope :to_start_with, :conditions => {:start => true}

  before_validation :parameterize_title_for_name
  
  delegate :definition_roles, :to => :definition

  def parameterize_title_for_name
    self.name = title.parameterize if title
  end    
end
