
module Jobs
  class TransactionCancellationJob < Struct.new(:cancellation_id)
    include ResourceMixIn
  
    def perform
      cancellation = Cancellation.find(cancellation_id)

      transaction = cancellation.transaction
      resource(cancellation).post :transaction_uri => transaction.uri
      cancellation.cancelled!
    end
  end
end
