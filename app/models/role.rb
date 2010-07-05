class Role < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
  
  has_many :fulfills
  has_many :organizations, :through => :fulfills
  belongs_to :definition
end
