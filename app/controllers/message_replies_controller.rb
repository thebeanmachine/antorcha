
class MessageRepliesController < ApplicationController

  def new
    @origin = Message.find(params[:message_id])
    @steps = @origin.definition.steps
    
    @message = Message.new
  end

end
