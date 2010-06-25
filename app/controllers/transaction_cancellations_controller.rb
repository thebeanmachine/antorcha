
class TransactionCancellationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def create
    @transaction = Transaction.find_by_uri(params[:transaction_uri]) if params[:transaction_uri]
    @transaction = Transaction.find(params[:transaction_id]) if params[:transaction_id]

    unless @transaction.cancelled?
      @transaction.cancelled!
      Delayed::Job.enqueue(TransactionCancellationJob.new(@transaction.id))
      flash[:notice] = "Transaction was successfully cancelled."
    else
      flash[:notice] = "Transaction was already cancelled."
    end
  
    redirect_to @transaction
  end
end
