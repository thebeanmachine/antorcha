class Castable < ActiveRecord::Base
  include CrossAssociatedModel

  belongs_to :user
  belongs_to_resource :role

  validates_presence_of :user, :role

  def title
    "#{user_username} heeft rol #{role_title}"
  end
  
  def role_title
    role ? role.title : "leeg"
  end

  def user_username
    user ? user.username : "leeg"
  end
end
