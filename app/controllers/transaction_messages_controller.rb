
class TransactionMessagesController < ApplicationController
  def index
    @transaction = Transaction.find(params[:transaction_id])
    @search = @transaction.messages.search(params[:search])
    @messages = @search.all
    render :template => 'messages/index'
  end

  def new
    @transaction = Transaction.find(params[:transaction_id])
    @steps_to_start_with = @transaction.definition.steps.to_start_with.all
    @message = Message.new
  end
  
  def create
    @transaction = Transaction.find(params[:transaction_id])
    @message = @transaction.messages.new(params[:message])
    if @message.save
      redirect_to(@message, :notice => t('notice.created', :model => Message.human_name))
    else
      render :action => "new"
    end
  end
end
