class Ability
  include CanCan::Ability

  def initialize(user)
    if user.include? :maintainer
      can :manage, :all
      can :send, Message
    end
    if user.include? :advisor
      can :manage, :all
      cannot :manage, Worker
      can :send, Message
    end
    if user.include? :sender
      can :send, Message
    end
    can :read, [Transaction, Message]
  end
end
