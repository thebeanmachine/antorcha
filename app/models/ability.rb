class Ability
  include CanCan::Ability

  def initialize(user)
    if user.include? :maintainer
      can :manage, :all
      can :send, Message
      cannot :manage, [Definition, Role, Step]
      cannot :create, Role
      cannot :update, Role
    end
    if user.include? :advisor
      can :manage, :all
      cannot :manage, Worker
      cannot :send, Message
    end
    if user.include? :communicator
      can :send, Message
      can :create, Message
      cannot :create, Role
      cannot :update, Role
      cannot :manage, [Definition, Step]
    end
    can :read, [Transaction, Message, Role]
    can :create, [Transaction]
  end
end
