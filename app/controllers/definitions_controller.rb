class DefinitionsController < ApplicationController
  # GET /definitions
  # GET /definitions.xml
  def index
    @definitions = Definition.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @definitions }
    end
  end

  def show
    @definition = Definition.find(params[:id])
    @steps = @definition.steps

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @definition }
    end
  end

  # GET /definitions/new
  # GET /definitions/new.xml
  def new
    @definition = Definition.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @definition }
    end
  end

  # GET /definitions/1/edit
  def edit
    @definition = Definition.find(params[:id])
  end

  # POST /definitions
  # POST /definitions.xml
  def create
    @definition = Definition.new(params[:definition])

    respond_to do |format|
      if @definition.save
        format.html { redirect_to(@definition, :notice => 'Definition created successfully') }
        format.xml  { render :xml => @definition, :status => :created, :location => @definition }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /definitions/1
  # PUT /definitions/1.xml
  def update
    @definition = Definition.find(params[:id])

    respond_to do |format|
      if @definition.update_attributes(params[:definition])
        format.html { redirect_to(@definition, :notice => 'Transactiedefinitie was succesvol gewijzigd.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /definitions/1
  # DELETE /definitions/1.xml
  def destroy
    @definition = Definition.find(params[:id])
    @definition.destroy

    respond_to do |format|
      format.html { redirect_to(definitions_url) }
      format.xml  { head :ok }
    end
  end
end
