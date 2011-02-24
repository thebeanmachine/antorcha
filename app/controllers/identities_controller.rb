class IdentitiesController < ApplicationController


  # GET /identity
  # GET /identity.xml
  def show
    @identity = Identity.first
    authorize! :show, Identity

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @identity }
    end
  end


  # GET /identity/new
  def new
    @identity = Identity.new
    authorize! :new, @identity

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @identity }
    end
  end


  # POST /identity
  def create
    @identity = Identity.new params[:identity]
    authorize! :create, @identity

    respond_to do |format|
      if @identity.save
        format.html { redirect_to identity_url, :notice => 'De identiteit is succesvol geverifieerd en toegevoegd.' }
        format.xml  { render :xml => @identity, :status => :created, :location => @identity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @identity.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /identity
  def destroy
    @identity = Identity.first
    authorize! :destroy, @identity
    @identity.destroy

    respond_to do |format|
      format.html { redirect_to(identity_url) }
      format.xml  { head :ok }
    end
  end
end
