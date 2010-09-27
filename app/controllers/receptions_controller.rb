class ReceptionsController < ApplicationController
  
  def self.open_https_client_auth_for_receiving_message_on_create
    skip_before_filter :authenticate_user!, :only => :create
    skip_before_filter :verify_authenticity_token, :only => :create
    before_filter :impose_https_on_production, :only => :create
  end
  
  # GET /receptions
  # GET /receptions.xml
  def index
    authorize! :index, Reception
    @receptions = Reception.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @receptions }
    end
  end

  # GET /receptions/1
  # GET /receptions/1.xml
  def show
    @reception = Reception.find(params[:id])
    authorize! :show, @reception

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reception }
    end
  end

  open_https_client_auth_for_receiving_message_on_create

  def create
    @reception = Reception.new
    @reception.organization_id = params[:organization_id]
    @reception.delivery_id = params[:delivery][:id]
    @reception.content = params[:delivery][:message]
    @reception.certificate = Rails.env.production? ? request.headers['SSL_CLIENT_CERT'] : 'NO CERTIFICATE'

    respond_to do |format|
      if @reception.save
        format.html { redirect_to(@reception, :notice => 'Reception was successfully created.') }
        format.xml  { render :xml => @reception, :status => :created, :location => @reception }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reception.errors, :status => :unprocessable_entity }
      end
    end
  end

private
  def impose_https_on_production
    if Rails.env.production? and not request.ssl?
      raise "it is prohibited to send messages over http in production mode." 
    end
  end

end
