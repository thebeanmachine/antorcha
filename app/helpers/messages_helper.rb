module MessagesHelper
  include SwiftHelper
  
  help_can_link_to :message

  def link_to_reply_message message
    if message.effect_steps.count > 0 and message.incoming? and can? :send, message
      link_to t('action.reply', :model => Message.human_name), new_message_reply_path(@message)
    end
  end
  
  def link_to_send_message(message)
    if not message.sent? and message.outgoing? and can? :send, message
      button_to t('action.send', :model => Message.human_name), message_deliveries_path(@message), :method => :post
    end
  end
end

