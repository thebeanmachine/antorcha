module MessagesHelper
  include SwiftHelper
  
  help_can_link_to :message
  
  def link_to_send_message(message)
    if not message.sent? and message.outgoing? and can? :send, message
      button_to t('action.send', :model => Message.human_name), message_delivery_path(@message), :method => :post
    end
  end
end
