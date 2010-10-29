module TransactionsHelper
  include SwiftHelper
  
  help_can_link_to :transaction

  def link_to_transactions_always
    if controller_name == "transaction_messages"
      link_to "Transaction", transactions_path, :class => 'transaction selected'
    else
      link_to_transactions
    end
  end

  def link_to_new_transaction_message(transaction)
    if can? :new, Message
      link_to h(t('action.new', :model => Message.human_name)), new_transaction_message_path(transaction), :class => 'message'
    end
  end
  
  def button_to_transaction_cancellation transaction, message = nil
    if can? :cancel, Transaction
      button_to h(t('action.cancel', :model => Transaction.human_name)), transaction_cancellation_path(transaction, :message_id => message ), :method => :post, :confirm => 'Weet u het zeker?'
    end
  end
end
