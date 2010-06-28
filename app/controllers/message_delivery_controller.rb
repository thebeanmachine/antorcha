
class MessageDeliveryController < ApplicationController
  def create
    
    @message = Message.find(params[:message_id])
    authorize! :send, @message

    @message.sent!
    Delayed::Job.enqueue MessageDeliveryJob.new(@message.id)
    
    redirect_to @message, :notice => 'Message is being sent'
  end
end
