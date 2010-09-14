class MessagesController < ApplicationController
  load_and_authorize_resource :except => :create
  
  def self.open_https_client_auth_for_sending_messages_on_create
    skip_before_filter :authenticate_user!, :only => :create
    skip_before_filter :verify_authenticity_token, :only => :create
    #before_filter :ensure_https_connection, :only => :create
  end

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

  open_https_client_auth_for_sending_messages_on_create

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
      redirect_to(@message, :notice => 'Bericht is bijgewerkt')
    else
      render :action => "edit"
    end
  end

end
