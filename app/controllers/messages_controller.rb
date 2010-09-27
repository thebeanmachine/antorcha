class MessagesController < ApplicationController
  load_and_authorize_resource :except => [:create, :roles_messages]
  

  def index    
    @search = Message.search(params[:search])
    @messages = @search.paginate(:page => params[:page], :include => :transaction,  :per_page => 25)
    # render :text => @messages.class
    if @messages.empty?
      flash.now[:error] = "Er zijn geen berichten die '#{t(params[:search].keys)}' zijn."
    end
  end
  
  def roles_messages
    @messages = current_user.messages.paginate(:page => params[:page], :include => :transaction,  :per_page => 25)
    render :index
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
    raise "DEPRECATED - this functionality has been moved."
  end

  def update
    if @message.update_attributes(params[:message])
      redirect_to(@message, :notice => 'Bericht is bijgewerkt')
    else
      render :action => "edit"
    end
  end

end
