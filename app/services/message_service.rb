class MessageService < ActionWebService::Base  
  web_service_api MessageAPI

  before_invocation :check_token
  
  def index_inbox token
    Message.inbox
  end
  
  def index_outbox token
    Message.outbox
  end
  
  def index_read token
    Message.read
  end
  
  def index_unread token
    Message.unread
  end

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
