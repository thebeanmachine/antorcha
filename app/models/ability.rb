class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    
    permit_maintainer if user.maintainer?
    permit_communicator if user.communicator?
  end

  def permit_maintainer
    default_permissions

    can :manage, Organization
    can :manage, Worker
    can :read, Transaction
  end
  
  def permit_communicator
    default_permissions
    
    can :send, Message
    can :create, Message
    can :update, Message do |message| message.updatable? end
    can :examine, Message
  
    can :create, Transaction
    can :cancel, Transaction
  end
  
  def default_permissions
    can :read, [Message]
  end
end
