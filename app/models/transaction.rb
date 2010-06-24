class Transaction < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :name, :if => :title
  validates_uniqueness_of :name

  belongs_to :definition
  has_many :messages

  before_validation :parameterize_title_for_name

  flagstamp :cancelled

private
  def parameterize_title_for_name
    self.name = title.parameterize if title
  end
end
