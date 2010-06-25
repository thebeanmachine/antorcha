class TransactionCancellationJob < Struct.new(:transaction_id)
  include ActionView::Helpers::UrlHelper
  
  def perform
    transaction = Transaction.find(transaction_id)

    transaction.messages.outbox.each do |message|
      RestClient.post('http://localhost:3000/transactions/cancellation', :transaction => transaction.uri)
    end
  end
end
