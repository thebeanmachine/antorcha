class MessagesController < ApplicationController
  load_and_authorize_resource :except => [:create, :roles_messages]
  

  def index
    @search = Message.search(params[:search])

    @messages = @search.paginate(:page => params[:page], :include => :transaction,  :per_page => 25)

    if @messages.empty?
      if params[:search]
        searchkeys = []
        params[:search].keys.each do |k|
          searchkeys.push t("view.message.scope.#{k}")
        end
        searchkeys = searchkeys.join(", ").reverse.sub(/,/," ne ").reverse.downcase
        flash.now[:notice] = "Er zijn geen berichten die #{searchkeys} zijn."
      else 
        flash.now[:info] = "Er zijn nog geen berichten, begin zelf een transactie of wacht totdat iemand anders u een bericht stuurt"
      end
    end
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @search.all(:include => :transaction).to_xml(:local => true, :scrub => cannot?(:examine, Message)) }
    end
  end
  
  def show
    @message = Message.show(params[:id])
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @message.to_xml(:local => true, :scrub => cannot?(:examine, Message)) }
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
