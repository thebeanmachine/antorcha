
class InstructionMessagesController < ApplicationController
  def new
    @instruction = Instruction.find(params[:instruction_id])
    @message = Message.new
  end
  
  def create
    @instruction = Instruction.find(params[:instruction_id])
    @message = @instruction.messages.new(params[:message])
    if @message.save
      redirect_to(@message, :notice => 'Bericht was succesvol aangemaakt.')
    else
      render :action => "new"
    end
  end
end
