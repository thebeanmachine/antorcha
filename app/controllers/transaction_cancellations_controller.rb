
class TransactionCancellationsController < ApplicationController
  def create
    @transaction = Transaction.find(params[:transaction_id])
    @transaction.cancelled!
    flash[:notice] = "Transaction was successfully cancelled."
    redirect_to @transaction
  end
end
