class MessagesController < ApplicationController
#  web_service_dispatching_mode :delegated
#  web_service :message, MessageService.new
#  wsdl_namespace 'http://antorcha.nl/soap/v1/'
#  web_service_scaffold :invoke if Rails.env.test? or Rails.env.development?
  
  def index
    @search = Message.search(params[:search])
    @messages = @search.all
    @steps_to_start_with = Step.to_start_with
  end

  def show
    @message = Message.find(params[:id])
    @message.shown!
    
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
