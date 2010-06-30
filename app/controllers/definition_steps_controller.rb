class DefinitionStepsController < ApplicationController
  def index
    @definition = Definition.find(params[:definition_id])
    @steps = @definition.steps
  end
  
  def new
    @step = Step.new
    @definition = Definition.find(params[:definition_id])
    @steps = @definition.steps
  end

  def create
    @definition = Definition.find(params[:definition_id])
    @step = @definition.steps.new(params[:step])
    @steps = @definition.steps

    if @step.save
      redirect_to @step, :notice => 'Step created successfully.'
    else
      render :action => "new"
    end
  end
end