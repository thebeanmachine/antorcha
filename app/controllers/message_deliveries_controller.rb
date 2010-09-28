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
    
    if @message.test?      
      unless @message.cancelled?
        @message.send_deliveries_and_ourself
        redirect_to @message, :notice => 'Testbericht is succesvol bij de uitgaande post terechtgekomen.'
      else
        redirect_to @message, :flash => {:error => 'Testtransactie is tussentijds geannuleerd, kan niet worden verzonden.'}
      end
    else
      unless @message.cancelled?
        @message.send_deliveries
        redirect_to @message, :notice => 'Bericht is succesvol bij de uitgaande post terechtgekomen.'
      else
        redirect_to @message, :flash => {:error => 'Transactie is tussentijds geannuleerd, kan niet worden verzonden.'}
      end
    end
  end
end
