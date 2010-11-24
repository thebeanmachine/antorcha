class AuthenticatedService < ActionWebService::Base
  before_invocation :check_token

private

  def initialize controller
    @controller = controller
  end

  def warden
    @controller.warden
  end

  def url_for *options
    @controller.url_for *options
  end
  
  def authorize! *args
    raise StandardError, "Authorization failed: Can not #{args.collect(&:to_s).join(', ')}" unless @controller.can? *args
  end

  def can? *args
    @controller.can? *args
  end

  def check_token method_name, args
    token = args[0]
    return [false, "No token specified"] unless token
    user = User.find_by_username token.username
    if user and user.valid_password? token.password
      warden.set_user(user, :scope => :user)
    else
      return [false, "Access denied"]
    end
  end
  
end