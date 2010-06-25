class TransactionCancellationJob < Struct.new(:transaction_id)
  include ActionView::Helpers::UrlHelper
  
  def perform
    transaction = Transaction.find(transaction_id)

    if transaction.cancelled? and not transaction.stopped?
      transaction.messages.outbox.each do |message|
        RestClient.post('http://localhost:3000/transactions/cancellations', :transaction_uri => transaction.uri)
      end
      transaction.stopped!
    end
  end
end
