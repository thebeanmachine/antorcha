class Organization < Resource
  validates_presence_of :title
  validates_uniqueness_of :title
  
  #has_many :fulfills
  #has_many :roles, :through => :fulfills 
end
