class DeliveriesController < ApplicationController
  
  authorize_resource
  
  def index
    @queued_deliveries = Delivery.queued 
    respond_to do |wants|
      wants.html { }
      wants.xml { render :xml => @queued_deliveries.to_xml }      
    end
  end
end
