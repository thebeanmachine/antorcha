module MessagesHelper
  include SwiftHelper
  
  help_can_link_to :message

  def link_to_reply_message message
    if message.replyable? and can? :send, message
      link_to t('action.reply', :model => Message.human_name), new_message_reply_path(@message)
    end
  end
  
  def link_to_send_message(message)
    if not message.sent? and message.outgoing? and can? :send, message
      button_to t('action.send', :model => Message.human_name), message_deliveries_path(@message), :method => :post
    end
  end

  def button_to_message_transaction_cancellation message
    button_to_transaction_cancellation message.transaction, message if message.cancellable?
  end
  
  def message_status message
    options = [:created_at, :sent_at, :delivered_at].inject({}) do |memo, atr|
      value = message.send(atr.to_sym)
      memo[atr.to_sym] = l(value, :format => :short) unless value.blank?
      memo
    end
    I18n.t "view.message.show.status.#{message.status}", options
  end
  
end

