class Definition < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :name, :if => :title
  validates_uniqueness_of :name
  
  before_validation :parameterize_title_for_name

  has_many :steps
  
  has_many :transactions
  has_many :messages, :through => :transactions

  has_many :roles

  has_many :reactions, :through => :steps, :source => :effect_reactions

  def parameterize_title_for_name
    self.name = title.parameterize if title
  end
  
  def step_roles()
    roles
  end
end
