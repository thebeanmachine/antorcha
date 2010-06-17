class TaskStepsController < ApplicationController
  def new
    @step = Step.new
    @task = Task.find(params[:task_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @step }
    end
  end

  def create
    @step = Step.new(params[:step])

    respond_to do |format|
      if @step.save
        format.html { redirect_to(@step, :notice => 'Step was successfully created.') }
        format.xml  { render :xml => @step, :status => :created, :location => @step }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end
end