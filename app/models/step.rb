class Step < Resource
  #validates_presence_of :title
  #validates_presence_of :name, :if => :title
  #validates_uniqueness_of :name

  belongs_to :definition
  has_many :messages
  
  #has_many_siblings :reaction, :cause => :effect

  #has_many :recipients
  #has_many :recipient_roles, :through => :recipients, :source => :role

  #has_many :permissions
  #has_many :permission_roles, :through => :permissions, :class_name => 'Role', :source => :role

  def self.to_start_with
    Step.find :all, :from => :start
  end

  before_validation :parameterize_title_for_name
  
  delegate :definition_roles, :to => :definition

  # No premature optimalizations.
  def destination_organizations
    recipient_roles.all.inject [] do |memo, role|
      memo += role.organizations
      memo.uniq
    end
  end

  def parameterize_title_for_name
    self.name = title.parameterize if title
  end    
end
