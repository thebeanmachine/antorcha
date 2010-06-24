module TransactionsHelper
  include SwiftHelper
  
  help_link_to :transaction
  
  def button_to_transaction_cancellation transaction
    button_to "Cancel Transaction", transaction_cancellation_path(transaction), :method => :post, :confirm => 'Are you sure?'
  end
end
