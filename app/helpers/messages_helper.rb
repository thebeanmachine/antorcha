module MessagesHelper
  include SwiftHelper
  
  help_can_link_to :message
  
  def link_to_send_message(message)
    if not message.sent? and can? :send, message
      button_to 'Send Message', message_delivery_path(@message), :method => :post
    end
  end
end
