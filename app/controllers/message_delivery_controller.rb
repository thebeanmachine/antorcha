
class MessageDeliveryController < ApplicationController
  def create
    @message = Message.find(params[:message_id])
    @message.sent!
    Delayed::Job.enqueue MessageDeliveryJob.new(@message.id)
    
    redirect_to @message, :notice => 'Message is being send'
  end
end
