class DeliveriesController < ApplicationController
  
  authorize_resource
  
  def index
    @queued_deliveries = Delivery.queued
  end
end
