class MessageService < ActionWebService::Base  
  web_service_api MessageAPI

  before_invocation :check_token

  def show token, message_id
    Message.show(message_id)
  end
  
  def index token
    Message.all
  end

private

  def check_token method_name, args
    token = args[0]
    return [false, "No token specified"] unless token
    unless token.username == 'aap' and token.password == 'noot'
      return [false, "Access denied"]
    end
  end

end
