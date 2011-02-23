class MessageService < AuthenticatedService
  
  include TransactionInitiationsController::TransactionInitiationMixin
  
  web_service_api MessageAPI

  before_invocation :load_and_authorize_message
  after_invocation :scrub_returned_messages

  def index_expired_unread token
    Message.expired.unread
  end
  
  def index_by_roles token
    user = User.find_by_username token.username
    user.messages
  end
  
  def index_cancelled_unread token
    Message.cancelled.unread
  end
  
  def index_unexpired_unread token
    Message.unexpired.unread
  end

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
  
  # def reply token, api_message
  #   Message.find(api_message.id).replies.build(api_message.attributes)
  # end
  
  def reply token, api_message, api_step
    Message.find(api_message.id).replies.create(:step_id => api_step.id, :user => current_user)
  end
  
  
  def deliver_message_after_init_transaction token, api_step, message_title, message_body
    
    begin
      @step = Step.find(api_step.id)
    rescue ActiveResource::ResourceNotFound
      raise TransactionServiceError, "Step #{api_step.id} not found"
    end
    
    @transaction = Transaction.new
    
    @message = create_transaction_and_message(@transaction, @step)
    @message.title = message_title
    @message.body = message_body
    @message.send_deliveries
    @message.shown_at = Time.now
    @message.save
    @message
  end
  
  def deliver token, api_message
    @message = Message.find(api_message.id)
    @message.send_deliveries
    @message
  end
  
  def delete token, api_message
    Message.find(api_message.id).destroy
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
  
private
  def load_and_authorize_message method_name, args
    @message = Message.find(args[1].id) if args[1].is_a?(Api::Message)
    authorize! soap_method_to_resource_action(method_name), @message.blank? ? Message : @message
  end

  def soap_method_to_resource_action method_name
    method_name.to_s =~ /[a-z]+/
    action = $&
    action = 'send' if action == 'deliver'
    action.to_sym
  end

  def scrub_returned_messages method_name, params, return_value
    case return_value
    when Array:
      return_value = scrub_messages return_value
    when Message:
      return_value = scrub_message return_value
    end
    [return_value]
  end
  
  def scrub_messages messages
    messages.each {|message| scrub_message message }
  end
  
  def scrub_message message
    message.body = nil unless can? :examine, message
  end
  
  class TransactionServiceError < StandardError
  end

end


