class ConfirmationsController < ApplicationController
  
  def self.open_https_client_auth_for_confirming_a_delivery_on_create
    skip_before_filter :authenticate_user!, :only => :create
    skip_before_filter :verify_authenticity_token, :only => :create
    before_filter :impose_https_on_production, :only => :create
  end
  
  open_https_client_auth_for_confirming_a_delivery_on_create

  def create
    @delivery = Delivery.find(params[:delivery_id], :conditions => { :organization_id => params[:organization_id]})
    @delivery.confirmed = true
    @delivery.certificate = header_client_certificate

    respond_to do |format|
      if @delivery.save
        format.html { redirect_to(@delivery, :notice => 'Confirmation was successfully created.') }
        format.xml  { render :xml => @delivery, :status => :created, :location => @reception }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @delivery.errors, :status => :unprocessable_entity }
      end
    end
  end

private
  def impose_https_on_production
    if Rails.env.production? and not request.ssl?
      raise "it is prohibited to confirm message deliveries over http in production mode." 
    end
  end
end
