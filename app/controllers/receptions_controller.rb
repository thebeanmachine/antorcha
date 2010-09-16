class ReceptionsController < ApplicationController
  # GET /receptions
  # GET /receptions.xml
  def index
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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reception }
    end
  end

  # POST /receptions
  # POST /receptions.xml
  def create
    @reception = Reception.new(params[:reception])

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

end
