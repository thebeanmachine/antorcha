class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    
    permit_maintainer if user.maintainer?
    permit_communicator(user) if user.communicator?
  end

  private 
  def permit_maintainer
    default_permissions

    can :manage, User
    can :manage, Worker
    can :manage, Castable
    can :read, Transaction
    #can :manage, Identity
  end
  
  def permit_communicator(user)
    default_permissions
    
    can :send, Message
    can :create, Message
    can :update, Message do |message| message.updatable? end
    #can :cancel, Message { |message| message.cancellable?}
    can :examine, Message
    
    can :create, Transaction unless user.castables.empty?
    can :cancel, Transaction
  end
  
  def default_permissions
    can :read, [Message]
  end
end
