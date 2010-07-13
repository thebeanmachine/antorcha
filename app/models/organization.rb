# We use this entity to address Messages and not to organize Users.
# Thus, an Organisation equals an other Antorcha system.

class Organization < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
  
  has_many :fulfills
  has_many :roles, :through => :fulfills 
end
