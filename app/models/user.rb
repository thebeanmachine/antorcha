class User < ActiveRecord::Base  
  USER_TYPES = %w[ registered communicator maintainer ].collect &:to_s
  
  # Include default devise modules. Others available are:
  # :registerable, :recoverable, :trackable, :rememberable, :confirmable, :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :validatable, :registerable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation
  
  has_many :castables
  #has_many :roles, :through => :castables

  validates_uniqueness_of :username, :email

  validates_inclusion_of :user_type, :in => USER_TYPES
  
  named_scope :inactivated, :conditions => {:activated => false}
  
  def static_user_type
    logger.warn 'static_user_type is deprecated user User#user_type instead.'
    user_type
  end

  USER_TYPES.each do |user_type|
    self.class_eval <<-RUBY
      named_scope :#{user_type.pluralize}, :conditions => {:user_type => '#{user_type}'}
    
      def #{user_type}?
        read_attribute(:user_type) == '#{user_type}'
      end
    RUBY
  end
end
