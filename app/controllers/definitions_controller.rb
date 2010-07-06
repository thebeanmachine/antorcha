class DefinitionsController < ApplicationController
  def index
    @definitions = Definition.all
  end

  def show
    @definition = Definition.find(params[:id])
    @steps = @definition.steps
  end

  def new
    @definition = Definition.new

  end

  def edit
    @definition = Definition.find(params[:id])
  end

  def create
    @definition = Definition.new(params[:definition])

    if @definition.save
      redirect_to(@definition, :notice => 'Definition created successfully')
    else
      render :action => "new"
    end
  end

  def update
    @definition = Definition.find(params[:id])

    if @definition.update_attributes(params[:definition])
      redirect_to(@definition, :notice => 'Transactiedefinitie was succesvol gewijzigd.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @definition = Definition.find(params[:id])
    @definition.destroy

    redirect_to(definitions_url)
  end
end
