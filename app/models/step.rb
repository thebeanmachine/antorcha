class Step < Resource
  #validates_presence_of :title
  #validates_presence_of :name, :if => :title
  #validates_uniqueness_of :name

  fortify :title, :name

  belongs_to :definition
  
  has_many :messages
  
  delegate :roles, :to => :definition 

  #has_many_siblings :reaction, :cause => :effect

  #has_many :recipients
  #has_many :recipient_roles, :through => :recipients, :source => :role

  #has_many :permissions
  #has_many :permission_roles, :through => :permissions, :class_name => 'Role', :source => :role

  before_validation :parameterize_title_for_name


  def self.starting_steps options = {}
    user = options.delete :user if options[:user]
    params = {}
    params[:permitted_for_roles] = user.castables.collect(&:role_id) if user
    Step.find :all, :from => :start, :params => params
  end

  def effects
    Step.find :all, :from => "/steps/#{to_param}/effects.xml"
  end

  def destination_organizations
    Organization.find :all, :from => "/steps/#{to_param}/destination_organizations.xml"
  end

private
  def parameterize_title_for_name
    self.name = title.parameterize if title
  end    
end
