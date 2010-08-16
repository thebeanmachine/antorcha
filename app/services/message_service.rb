class MessageService < AuthenticatedService
  web_service_api MessageAPI

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

  def delete token, message_id
    Message.destroy message_id
  end

  def show token, message_id
    Message.show(message_id)
  end
  
  def reply token, api_message
    Message.find(api_message.id).replies.build(api_message.attributes)
  end
  
  def deliver token, message_id
    Message.find(message_id).send_deliveries
  end
  
  def index token
    Message.all
  end
  
  def update token, api_message
    message = Message.find(api_message.id)
    message.attributes = api_message.attributes.slice :title, :body
    message.save
    message
  end
end
