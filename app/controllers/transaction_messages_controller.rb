
class TransactionMessagesController < ApplicationController
  def index
    @transaction = Transaction.find(params[:transaction_id])
    @search = @transaction.messages.search(params[:search])
    @messages = @search.all
    render :template => 'messages/index'
  end

  #REVIEW: Ik zie niet waar deze nieuw en create worden gebruikt, kan dit niet weg? De 'new' template die hier bij hoort is ook nog niet vertaald...

  def new
    @transaction = Transaction.find(params[:transaction_id])
    #@steps_starting_steps = @transaction.definition.steps.starting_steps.all
    @steps = @transaction.definition.steps.all
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
