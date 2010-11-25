class MessageDeliveriesController < ApplicationController
  def index
    @message = Message.find(params[:message_id])
    authorize! :show, @message
    authorize! :index, Delivery
    
    @deliveries = @message.deliveries
  end

  def create
    @message = Message.find(params[:message_id])
    authorize! :send, @message
    
    respond_to do |format|
      if @message.test?      
        unless @message.cancelled?
          @message.send_deliveries_and_ourself
          format.html { redirect_to @message, :notice => 'Testbericht is succesvol bij de uitgaande post terechtgekomen.' }
          format.xml { render :xml => @message, :status => :created }
        else
          format.html { redirect_to @message, :flash => {:error => 'Testtransactie is tussentijds geannuleerd, kan niet worden verzonden.'} }
          format.xml { render :xml => @message, :status => :cancelled }
        end
      else
        unless @message.cancelled?       
          @message.send_deliveries        
          format.html { redirect_to @message, :notice => 'Bericht is succesvol bij de uitgaande post terechtgekomen.' }
          format.xml { render :xml => @message, :status => :created }
        else
          format.html { redirect_to @message, :flash => {:error => 'Transactie is tussentijds geannuleerd, kan niet worden verzonden.'} }
          format.xml { render :xml => @message, :status => :cancelled }
        end
      end
    end
  end
end
