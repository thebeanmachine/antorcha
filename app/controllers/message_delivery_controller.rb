
class MessageDeliveryController < ApplicationController
  def create
    @message = Message.find(params[:message_id])
    authorize! :send, @message

    @message.send_deliveries
    
    redirect_to @message, :notice => 'Message is being sent'
  end
end
