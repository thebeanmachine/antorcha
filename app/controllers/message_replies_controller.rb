
class MessageRepliesController < ApplicationController
  before_filter :find_and_authorize_origin_message

  def new
    authorize! :new, Message
    @message = Message.new
  end

  def create
    @message = @origin.replies.build(params[:message])
    authorize! :create, @message

    if @message.save
      flash_notice :created, @message
      redirect_to edit_message_path(@message)
    else
      render :action => 'new'
    end
  end

private
  def find_and_authorize_origin_message
    @origin = Message.find(params[:message_id])
    authorize! :show, @origin

    @steps = @origin.effect_steps
  end

end
