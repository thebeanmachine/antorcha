class Ability
  include CanCan::Ability

  def initialize(user)
    if user.blank?
      cannot :manage, [Definition, Role, Step, Worker, Organization]
      cannot :create, Role
      cannot :update, Role   
      cannot :read, [Transaction, Message, Role]
      cannot :create, [Transaction]   
    else
      if user.static_user_type == :maintainer
        can :manage, Organization
        can :manage, Worker

        cannot :manage, [Definition, Role, Step]
        cannot :create, Role
        cannot :update, Role
      end
      if user.static_user_type == :advisor
        can :manage, [Definition, Step, Role]
        cannot :manage, Worker
        cannot :send, Message
      end
      if user.static_user_type == :communicator
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
end
