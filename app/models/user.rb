class User < ActiveRecord::Base  
  USER_TYPES = %w[ registered communicator maintainer ].collect &:to_s
  
  # Include default devise modules. Others available are:
  # :registerable, :recoverable, :trackable, :rememberable, :confirmable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :validatable, :registerable, :http_authenticatable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation

  has_many :castables

  # Note to self: e-mail and username are already validated on uniqueness and presense by devise.
  # Note to self: also password is validated on presence

  validates_presence_of :username, :password_confirmation 
  validates_uniqueness_of :username

  validates_inclusion_of :user_type, :in => USER_TYPES
  
  named_scope :inactivated, :conditions => {:activated => false}
  
  def cast(role_ids)
    role_ids.each do |id|
      self.castables.build(:role_id => id).save  
    end
  end
  
  def role_ids
    self.castables.map(&:role_id).uniq
  end
  
  def roles
    role_ids.map{|id| Role.find(id)}
  end
  
  def messages
    Message.user_id(id)
  end
  
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
