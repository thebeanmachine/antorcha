class CastablesController < ApplicationController
  # GET /castables
  # GET /castables.xml
  def index
    @castables = Castable.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @castables }
    end
  end

  # GET /castables/1
  # GET /castables/1.xml
  def show
    @castable = Castable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @castable }
    end
  end

  # GET /castables/new
  # GET /castables/new.xml
  def new
    @castable = Castable.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @castable }
    end
  end

  # GET /castables/1/edit
  def edit
    @castable = Castable.find(params[:id])
  end

  # POST /castables
  # POST /castables.xml
  def create
    @castable = Castable.new(params[:castable])

    respond_to do |format|
      if @castable.save
        format.html { redirect_to(@castable, :notice => 'Castable was successfully created.') }
        format.xml  { render :xml => @castable, :status => :created, :location => @castable }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @castable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /castables/1
  # PUT /castables/1.xml
  def update
    @castable = Castable.find(params[:id])

    respond_to do |format|
      if @castable.update_attributes(params[:castable])
        format.html { redirect_to(@castable, :notice => 'Castable was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @castable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /castables/1
  # DELETE /castables/1.xml
  def destroy
    @castable = Castable.find(params[:id])
    @castable.destroy

    respond_to do |format|
      format.html { redirect_to(castables_url) }
      format.xml  { head :ok }
    end
  end
end
