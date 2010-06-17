class TaskStepsController < ApplicationController
  def new
    @step = Step.new
    @task = Task.find(params[:task_id])
  end

  def create
    @task = Task.find(params[:task_id])
    @step = @task.steps.new(params[:step])

    if @step.save
      redirect_to @step, :notice => 'Stap succesvol aangemaakt.'
    else
      render :action => "new"
    end
  end
end