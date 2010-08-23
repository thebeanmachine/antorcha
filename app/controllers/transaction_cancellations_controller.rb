
class TransactionCancellationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!
  
  def create
    if params[:transaction_id]
      authenticate_user!
      authorize! :cancel, Transaction
      @transaction = Transaction.find(params[:transaction_id]) if params[:transaction_id]
    else
      # authenticate between antorcha's
      @transaction = Transaction.find_by_uri(params[:transaction_uri]) if params[:transaction_uri]
    end

    unless @transaction.cancel_and_cascade_cancellations
      flash[:notice] = "De transactie wordt geannuleerd"
    else
      flash[:notice] = "De transactie was al geannuleerd"
    end
  
    respond_to do |format|
      format.html do
        @message = @transaction.messages.find(params[:message_id]) if params[:message_id]
        if @message
          redirect_to @message
        else
          redirect_to @transaction
        end
      end
      format.xml { head :ok }
    end
  end
end
