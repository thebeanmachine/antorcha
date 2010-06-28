class Ability
  include CanCan::Ability

  def initialize(user)
    if user.include? :maintainer
      can :manage, :all
      can :send, Message
    elsif user.include? :sender
      can :send, Message
    end
    can :read, [Transaction, Message]
  end
end
