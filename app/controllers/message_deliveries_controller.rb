class MessageDeliveriesController < ApplicationController
  def index
    @message = Message.find(params[:message_id])
    authorize! :show, @message
    authorize! :index, Delivery
    
    @deliveries = @message.deliveries
  end

  def create
    @message = Message.find(params[:message_id] || (params[:delivery][:message_id] if params[:delivery]))
    authorize! :send, @message
    
    respond_to do |format|
      unless @message.cancelled?
        if @message.test?
          @message.send_deliveries_and_ourself
        else
          @message.send_deliveries        
        end
        format.html { redirect_to @message, :notice => "#{test_or_default('Bericht')} is succesvol bij de uitgaande post terechtgekomen." }
        format.xml { render :xml => @message, :status => :created }
      else
        format.html { redirect_to @message, :flash => {:error => "#{test_or_default('Transactie')} is tussentijds geannuleerd, kan niet worden verzonden."} }
        format.xml { render :xml => @message, :status => :gone }
      end
    end
  end
  
private
  def test_or_default word
    @message.test? ? "Test#{word.downcase}" : word
  end
end
