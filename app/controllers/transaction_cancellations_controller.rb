
class TransactionCancellationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!
  
  def create
    @transaction = Transaction.find_by_uri(params[:transaction_uri]) if params[:transaction_uri]
    @transaction = Transaction.find(params[:transaction_id]) if params[:transaction_id]

    unless @transaction.cancelled?
      @transaction.cancelled!
      Delayed::Job.enqueue(TransactionCancellationJob.new(@transaction.id))
      flash[:notice] = "De transactie is geannuleerd"
    else
      flash[:notice] = "De transactie was al geannuleerd"
    end
  
    @message = @transaction.messages.find(params[:message_id]) if params[:message_id]
  
    if @message
      redirect_to @message
    else
      redirect_to @transaction
    end
  end
end
