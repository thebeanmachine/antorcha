class TransactionCancellationJob < Struct.new(:cancellation_id)
  include ActionView::Helpers::UrlHelper
  
  def perform
    cancellation = Cancellation.find(cancellation_id)

    transaction = cancellation.transaction
    RestClient.post(cancellation.url, :transaction_uri => transaction.uri)
    cancellation.cancelled!
  end
end
