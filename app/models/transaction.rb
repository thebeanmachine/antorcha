class Transaction < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :name, :if => :title
  validates_uniqueness_of :name

  validates_presence_of :uri, :on => :update, :message => 'should have been assigned'
  validates_presence_of :definition

  belongs_to :definition
  has_many :messages

  before_validation :parameterize_title_for_name

  flagstamp :cancelled, :stopped

private
  def parameterize_title_for_name
    self.name = title.parameterize if title
  end
  
end
