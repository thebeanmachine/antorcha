class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    
    if user.maintainer?
      can :manage, Organization
      can :manage, Worker

      cannot :manage, [Definition, Role, Step]
      cannot :create, Role
      cannot :update, Role
    end
    if user.communicator?
      can :send, Message
      can :create, Message
      can :examine, Message
    
      can :cancel, Transaction
    
      cannot :create, Role
      cannot :update, Role
      cannot :manage, [Definition, Step]
    end
    can :read, [Transaction, Message, Role]
    can :create, [Transaction]
  end
end
