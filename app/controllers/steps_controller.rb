class StepsController < ApplicationController
  load_and_authorize_resource
  # GET /steps
  # GET /steps.xml
  def index
    @steps = Step.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @steps }
    end
  end

  def show
    @step = Step.find(params[:id])
    @definition = @step.definition

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step }
    end
  end

  def edit
    @step = Step.find(params[:id])
    @definition = @step.definition
    @steps = @definition.steps
  end

  def update
    # @step = Step.find(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        format.html { redirect_to(@step, :notice => 'Step was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @step = Step.find(params[:id])
    @step.destroy

    redirect_to(definition_url(@step.definition))
  end
end
