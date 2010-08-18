class MessagesController < ApplicationController
  load_and_authorize_resource :except => :create
  skip_before_filter :authenticate_user!, :only => [:create]

  def index    
    @search = Message.search(params[:search])
    @messages = @search.all(:include => :transaction)
  end

  def show
    @message = Message.show(params[:id])
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @message }
    end
  end

  def edit
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
    if @message.update_attributes(params[:message])
      redirect_to(@message, :notice => 'Message was successfully updated.')
    else
      render :action => "edit"
    end
  end

end
