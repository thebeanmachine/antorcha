class MessageDeliveriesController < ApplicationController
  def index
    @message = Message.find(params[:message_id])
    authorize! :show, @message
    authorize! :index, Delivery
    
    @deliveries = @message.deliveries
  end

  def create
    @message = Message.find(params[:message_id])
    authorize! :send, @message

    unless @message.cancelled?
      @message.send_deliveries
      redirect_to @message, :notice => 'Bericht is succesvol bij de uitgaande post terechtgekomen.'
    else
      redirect_to @message, :flash => {:error => 'Transactie is tussentijds geannuleerd, kan niet worden verzonden.'}
    end
  end
end
