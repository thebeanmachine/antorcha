class MessagesController < ApplicationController
  def index
    @messages = Message.all
    @steps_to_start_with = Step.to_start_with
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create
    @message = Message.new(params[:message])
    respond_to do |format|
      if @message.save
        format.html { redirect_to(@message, :notice => 'Message was successfully created.') }
        format.json { render :json => @message, :status => :created, :location => message_url(@message) }
      else
        format.html { render :action => "new" }
        format.json { render :nothing, :status => 442 }
      end
    end
  end

  def update
    @message = Message.find(params[:id])
    if @message.update_attributes(params[:message])
      redirect_to(@message, :notice => 'Message was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to(messages_url)
  end

end
