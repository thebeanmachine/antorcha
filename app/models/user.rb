class User < ActiveRecord::Base
  
  STATIC_USER_TYPE = :communicator
  
  # Include default devise modules. Others available are:
  # :registerable, :recoverable, :trackable, :rememberable, :confirmable, :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :validatable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation
  
  has_many :castables
  has_many :roles, :through => :castables

  
  def static_user_type
    STATIC_USER_TYPE
  end
  
end
