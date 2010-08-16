class MessagesController < ApplicationController

  def index    
    @search = Message.search(params[:search])
    @messages = @search.all
    @steps_to_start_with = Step.to_start_with
  end

  def show
    @message = Message.show(params[:id])
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @message }
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create
    @message = Message.new
    @message = @message.from_hash(params[:message])
    @message.incoming = true
    respond_to do |format|
      if @message.save
        format.xml { render :xml => @message, :status => :created, :location => message_url(@message) }
      else
        format.xml { render :nothing => true, :status => 422 }
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
